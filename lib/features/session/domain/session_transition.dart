import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:focus_orbit/core/domain/ids.dart';
import 'package:focus_orbit/core/domain/sync_mode.dart';
import 'package:focus_orbit/features/session/domain/focus_session.dart';
import 'package:focus_orbit/features/session/domain/session_phase.dart';
import 'package:focus_orbit/features/stance/domain/device_stance.dart';

part 'session_transition.freezed.dart';

/// ---- イベント(sealed) ----
/// D9 v1.1: session→stance はイベントペイロードのための許可済みdomain間エッジ。
@freezed
sealed class SessionEvent with _$SessionEvent {
  const factory SessionEvent.startRequested() = StartRequested;
  const factory SessionEvent.stanceChanged(DeviceStance stance) = StanceChanged;
  const factory SessionEvent.graceTimeout() = GraceTimeout;

  /// 報酬額はSessionControllerがRewardPolicyで算出しペイロード注入
  /// (D7: session⇔economyのdomain結合を回避)
  const factory SessionEvent.timerCompleted({required int rewardCoins}) =
      TimerCompleted;
  const factory SessionEvent.userCancelled() = UserCancelled;
  const factory SessionEvent.systemInterrupted() = SystemInterrupted;
  const factory SessionEvent.rewardClaimed() = RewardClaimed;
  const factory SessionEvent.acknowledged() = Acknowledged;
}

/// ---- 副作用コマンド(SessionControllerが解釈・実行) ----
sealed class SessionEffect {
  const SessionEffect();
}

final class StartSessionTimer extends SessionEffect {
  const StartSessionTimer();
}

final class StopAllTimers extends SessionEffect {
  const StopAllTimers();
}

final class StartGraceTimer extends SessionEffect {
  const StartGraceTimer();
}

final class CancelGraceTimer extends SessionEffect {
  const CancelGraceTimer();
}

final class JoinPresence extends SessionEffect {
  const JoinPresence();
}

final class LeavePresence extends SessionEffect {
  const LeavePresence();
}

final class GrantReward extends SessionEffect {
  const GrantReward({required this.sessionId, required this.coins});

  /// T6のidempotencyKey 'session:{id}' の材料
  final SessionId sessionId;
  final int coins;
}

/// ---- 遷移結果(sealed): 不正遷移はRejectedとして型で表面化 ----
sealed class TransitionResult {
  const TransitionResult();
}

final class Transitioned extends TransitionResult {
  const Transitioned(this.session, this.effects);
  final FocusSession session;
  final List<SessionEffect> effects;
}

/// 正当なno-op
final class Unchanged extends TransitionResult {
  const Unchanged(this.session);
  final FocusSession session;
}

/// プロトコル違反
final class Rejected extends TransitionResult {
  const Rejected(this.session, this.event);
  final FocusSession session;
  final SessionEvent event;
}

/// ---- 純関数遷移: T0-A3 v1.1が唯一の正 ----
class SessionTransition {
  const SessionTransition._();

  static TransitionResult apply(FocusSession s, SessionEvent e) =>
      switch ((s.phase, e)) {
        (Idle(), StartRequested()) => Transitioned(
            s.copyWith(
                phase: const SessionPhase.running(), elapsed: Duration.zero),
            [
              const StartSessionTimer(),
              if (s.syncMode == SyncMode.multi) const JoinPresence(),
            ]),
        (Running(), StanceChanged(stance: FaceUpStill())) => Unchanged(s),
        (Running(), StanceChanged(stance: MicroVibration())) => Transitioned(
            s.copyWith(phase: const SessionPhase.warning()),
            [const StartGraceTimer()]),
        (Warning(), StanceChanged(stance: FaceUpStill())) => Transitioned(
            s.copyWith(phase: const SessionPhase.running()),
            [const CancelGraceTimer()]),
        (Warning(), StanceChanged(stance: MicroVibration())) => Unchanged(s),
        (Running() || Warning(), StanceChanged(stance: Lifted())) =>
          _abort(s, AbortReason.pickedUp),
        (Warning(), GraceTimeout()) => _abort(s, AbortReason.graceTimeout),
        // キャンセルとすれ違いで遅延発火したstaleタイマーは無害化(T4レビューで追加)
        (Running(), GraceTimeout()) => Unchanged(s),
        (Running() || Warning(), UserCancelled()) =>
          _abort(s, AbortReason.userCancelled),
        (Running() || Warning(), SystemInterrupted()) =>
          _abort(s, AbortReason.systemInterrupted),
        (Running() || Warning(), TimerCompleted(rewardCoins: final coins)) =>
          Transitioned(
              s.copyWith(phase: SessionPhase.completed(rewardCoins: coins)),
              [
                const StopAllTimers(),
                if (s.syncMode == SyncMode.multi) const LeavePresence(),
              ]),
        (Completed(rewardCoins: final coins), RewardClaimed()) => Transitioned(
            s.copyWith(phase: const SessionPhase.idle()),
            [GrantReward(sessionId: s.id, coins: coins)]),
        (Aborted(), Acknowledged()) => Transitioned(
            s.copyWith(phase: const SessionPhase.idle()), const []),
        // 連続イベントであるstanceのみ、非アクティブ中はno-op(D8)
        (_, StanceChanged()) => Unchanged(s),
        _ => Rejected(s, e),
      };

  static Transitioned _abort(FocusSession s, AbortReason r) => Transitioned(
        s.copyWith(phase: SessionPhase.aborted(reason: r)),
        [
          const StopAllTimers(),
          if (s.syncMode == SyncMode.multi) const LeavePresence(),
        ],
      );
}
