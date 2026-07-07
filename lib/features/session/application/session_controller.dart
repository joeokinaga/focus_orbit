import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:focus_orbit/core/application/clock.dart';
import 'package:focus_orbit/core/domain/ids.dart';
import 'package:focus_orbit/core/domain/result.dart';
import 'package:focus_orbit/core/domain/sync_mode.dart';
import 'package:focus_orbit/features/economy/application/economy_providers.dart';
import 'package:focus_orbit/features/economy/domain/coin_transaction.dart';
import 'package:focus_orbit/features/economy/domain/economy_ledger.dart';
import 'package:focus_orbit/features/presence/application/presence_providers.dart';
import 'package:focus_orbit/features/session/domain/focus_session.dart';
import 'package:focus_orbit/features/session/domain/session_phase.dart';
import 'package:focus_orbit/features/session/domain/session_transition.dart';
import 'package:focus_orbit/features/stance/application/stance_providers.dart';
import 'package:focus_orbit/features/stance/domain/device_stance.dart';
import 'package:focus_orbit/features/stance/domain/stance_detector.dart';

/// D17: warning猶予。プロダクトチューニング可能な注入点。
final gracePeriodProvider =
    Provider<Duration>((_) => const Duration(seconds: 10));

/// D18: 報酬ポリシー(暫定: 1分=1コイン)。Phase 1でバランス調整。
final rewardPolicyProvider =
    Provider<int Function(Duration planned)>((_) => (d) => d.inMinutes);

/// claimReward()の結果。UIはこれで再試行可否を分岐する。
enum ClaimOutcome {
  granted,
  notClaimable,

  /// completedに留まっている=再試行してもコインは失われない(D16)
  failedRetryable,
}

final sessionControllerProvider =
    NotifierProvider<SessionController, FocusSession>(SessionController.new);

/// セッション統括(要件1・2・4・5の結線点)。
/// T4のSessionTransitionが唯一の遷移規則で、本クラスは
/// (1)イベント発火源の結線 (2)効果コマンドの実行 のみを担う。UI import ゼロ。
///
/// 【ライフサイクル監査(mobile-frontend-core)】生成/破棄ペア:
///   _tickTimer  : _startRuntime() / _teardownRuntime() + ref.onDispose
///   _graceTimer : _startGrace()   / _cancelGrace()・_teardownRuntime() + ref.onDispose
///   _stanceSub  : _startRuntime() / _teardownRuntime() + ref.onDispose
class SessionController extends Notifier<FocusSession> {
  Timer? _tickTimer;
  Timer? _graceTimer;
  StreamSubscription<DeviceStance>? _stanceSub;

  @override
  FocusSession build() {
    ref.onDispose(_teardownRuntime);
    return FocusSession(
      id: const SessionId('unstarted'),
      plannedDuration: Duration.zero,
      elapsed: Duration.zero,
      phase: const SessionPhase.idle(),
      motifId: const MotifId('water'), // 表示既定。実選択はUserSettings起点(UI層)
      syncMode: SyncMode.solo,
    );
  }

  // ---- 公開API(UI層が呼ぶ) ------------------------------------------------

  void start({
    required Duration duration,
    required MotifId motifId,
    required SyncMode syncMode,
  }) {
    if (state.phase is! Idle) {
      // 非idleからのstartは現セッションを汚さずFSMにRejectさせる(debugでassert表面化)
      _dispatch(const SessionEvent.startRequested());
      return;
    }
    state = state.copyWith(
      id: _newId(),
      plannedDuration: duration,
      elapsed: Duration.zero,
      motifId: motifId,
      syncMode: syncMode,
    );
    _dispatch(const SessionEvent.startRequested());
  }

  void cancel() => _dispatch(const SessionEvent.userCancelled());

  void acknowledgeAbort() => _dispatch(const SessionEvent.acknowledged());

  /// D3: Phase 1でWidgetsBindingObserver(UI層)からこのフックを呼ぶ。
  void onAppBackgrounded() =>
      _dispatch(const SessionEvent.systemInterrupted());

  /// D16: 効果先行コミット。apply成功(またはAlreadyApplied)後にのみidleへ遷移。
  /// 失敗時はcompletedに留まり再試行可能。キー(session:{id})がべき等性を保証
  /// するため、再試行・二重タップのいずれでも二重付与は起きない。
  Future<ClaimOutcome> claimReward() async {
    final phase = state.phase;
    if (phase is! Completed) return ClaimOutcome.notClaimable;

    final tx = CoinTransaction.sessionReward(
      sessionId: state.id,
      coins: phase.rewardCoins,
      occurredAt: ref.read(clockProvider)(),
    );
    final res = await ref.read(localPreferencesRepositoryProvider).apply(tx);
    if (!ref.mounted) return ClaimOutcome.notClaimable; // await後ガード(必須)

    return switch (res) {
      // 二重タップレース: 先行呼び出しが既にidleへ進めた場合は
      // AlreadyApplied+非completedとなるため、grantedを返すだけで整合(T9レビュー#2a)
      Success(value: Applied()) || Success(value: AlreadyApplied()) =>
        state.phase is Completed ? _claimAndGrant() : ClaimOutcome.granted,
      Success(value: LedgerRejected()) => ClaimOutcome.failedRetryable,
      Failure() => ClaimOutcome.failedRetryable,
    };
  }

  ClaimOutcome _claimAndGrant() {
    _dispatch(const SessionEvent.rewardClaimed());
    return ClaimOutcome.granted;
  }

  // ---- FSM結線 -------------------------------------------------------------

  /// D15: SessionIdはローカル一意で十分(同時1セッション・端末ローカル経済)。
  SessionId _newId() =>
      SessionId('s-${ref.read(clockProvider)().microsecondsSinceEpoch}');

  void _dispatch(SessionEvent event) {
    switch (SessionTransition.apply(state, event)) {
      case Transitioned(:final session, :final effects):
        state = session;
        _runEffects(effects);
        _syncActiveFlag();
      case Unchanged():
        break;
      case Rejected(:final event):
        // 開発時はプロトコル違反を即座に表面化。リリースではno-op。
        assert(false, 'Rejected: $event on ${state.phase}');
    }
  }

  void _runEffects(List<SessionEffect> effects) {
    for (final e in effects) {
      switch (e) {
        case StartSessionTimer():
          _startRuntime();
        case StopAllTimers():
          _teardownRuntime();
        case StartGraceTimer():
          _startGrace();
        case CancelGraceTimer():
          _cancelGrace();
        case JoinPresence():
          // D4: join失敗でもセッション継続。失敗はconnectionStateでUIに現れる。
          unawaited(_joinPresence());
        case LeavePresence():
          // T8エッジ#4: best-effort。不達はサーバ側TTLが後ろ盾。
          unawaited(ref.read(remoteRoomRepositoryProvider).leave());
        case GrantReward():
          // D16: claimReward()が先行コミット済み。ここでの再適用はべき等のため省略。
          break;
      }
    }
  }

  // ---- ランタイム(タイマー・センサー購読) -----------------------------------

  void _startRuntime() {
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) => _onTick());
    final detector =
        StanceDetector(thresholds: ref.read(stanceThresholdsProvider));
    final samples = ref.read(sensorGatewayProvider).motionSamples(
        samplingPeriod: ref.read(sensorSamplingPeriodProvider));
    _stanceSub = detector.bind(samples).listen(
          (s) => _dispatch(SessionEvent.stanceChanged(s)),
          // T3契約: SensorFailure(Streamエラー)はここで処理する。
          // センサー喪失=判定不能のため安全側で中断(D3と同区分)。
          onError: (Object _) =>
              _dispatch(const SessionEvent.systemInterrupted()),
        );
  }

  void _onTick() {
    final phase = state.phase;
    if (phase is! Running && phase is! Warning) return; // 競合安全弁
    final elapsed = state.elapsed + const Duration(seconds: 1);
    state = state.copyWith(elapsed: elapsed); // D12: tickは遷移ではない
    if (elapsed >= state.plannedDuration) {
      final coins = ref.read(rewardPolicyProvider)(state.plannedDuration);
      _dispatch(SessionEvent.timerCompleted(rewardCoins: coins));
    }
  }

  void _startGrace() {
    _graceTimer?.cancel();
    _graceTimer = Timer(
      ref.read(gracePeriodProvider),
      () => _dispatch(const SessionEvent.graceTimeout()),
    );
  }

  void _cancelGrace() {
    _graceTimer?.cancel();
    _graceTimer = null;
  }

  void _teardownRuntime() {
    _tickTimer?.cancel();
    _tickTimer = null;
    _cancelGrace();
    _stanceSub?.cancel();
    _stanceSub = null;
  }

  // ---- presence連携(要件4) --------------------------------------------------

  Future<void> _joinPresence() async {
    final res = await ref
        .read(remoteRoomRepositoryProvider)
        .join(RoomId(state.motifId.value)); // D19: 部屋=モチーフ
    // await後にstate/refを触らない(結果はログのみ)ためmountedガード不要(T9監査#3)
    if (res is Failure) {
      // ロギングフック(Phase 1)。セッションは継続(D4)。
    }
  }

  void _syncActiveFlag() {
    if (state.syncMode != SyncMode.multi) return;
    final active = state.phase is Running || state.phase is Warning;
    // 表示系の付随情報でセッション整合に影響しないためfire-and-forget(契約: join前はno-op)
    unawaited(ref.read(remoteRoomRepositoryProvider).reportActive(active));
  }
}
