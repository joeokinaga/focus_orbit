import 'package:flutter_test/flutter_test.dart';

import 'package:focus_orbit/core/domain/ids.dart';
import 'package:focus_orbit/core/domain/sync_mode.dart';
import 'package:focus_orbit/features/session/domain/focus_session.dart';
import 'package:focus_orbit/features/session/domain/session_phase.dart';
import 'package:focus_orbit/features/session/domain/session_transition.dart';
import 'package:focus_orbit/features/stance/domain/device_stance.dart';

/// P1-T7: SessionTransition(T0-A3 v1.1)の遷移表テスト。
///
/// 【設計原則(写経防止)】
/// 期待値は実装の switch を反映して生成せず、ARCHITECTURE §4 / T0-A3 の
/// 遷移表を「手書きのデータ行」として二重に宣言する。実装とテストの両方が
/// 同じ表を独立に転記していることで、どちらかの転記ミスが即 FAIL になる。
/// 凡例: T=Transitioned / U=Unchanged(正当なno-op) / R=Rejected(プロトコル違反)
void main() {
  FocusSession make({
    SessionPhase phase = const SessionPhase.idle(),
    SyncMode sync = SyncMode.solo,
    Duration elapsed = Duration.zero,
  }) =>
      FocusSession(
        id: const SessionId('s-777'),
        plannedDuration: const Duration(minutes: 25),
        elapsed: elapsed,
        phase: phase,
        motifId: const MotifId('water'),
        syncMode: sync,
      );

  Transitioned mustTransition(FocusSession s, SessionEvent e) {
    final r = SessionTransition.apply(s, e);
    expect(r, isA<Transitioned>(),
        reason: '${s.phase} × $e はTransitionedであるべき');
    return r as Transitioned;
  }

  // -------------------------------------------------------------------------
  // 1. 全域网羅スイープ: 5フェーズ × 7非stanceイベント = 35行(手書き期待値)
  // -------------------------------------------------------------------------
  group('遷移表スイープ(非stanceイベント 35行)', () {
    final phases = <String, SessionPhase>{
      'idle': const SessionPhase.idle(),
      'running': const SessionPhase.running(),
      'warning': const SessionPhase.warning(),
      'completed': const SessionPhase.completed(rewardCoins: 30),
      'aborted': const SessionPhase.aborted(reason: AbortReason.pickedUp),
    };
    final events = <String, SessionEvent>{
      'startRequested': const SessionEvent.startRequested(),
      'graceTimeout': const SessionEvent.graceTimeout(),
      'timerCompleted': const SessionEvent.timerCompleted(rewardCoins: 30),
      'userCancelled': const SessionEvent.userCancelled(),
      'systemInterrupted': const SessionEvent.systemInterrupted(),
      'rewardClaimed': const SessionEvent.rewardClaimed(),
      'acknowledged': const SessionEvent.acknowledged(),
    };

    // §4 の手書き転記。行 = (phase, event) → 期待種別。
    const table = <(String, String, String)>[
      // idle: 開始だけが正当
      ('idle', 'startRequested', 'T'),
      ('idle', 'graceTimeout', 'R'),
      ('idle', 'timerCompleted', 'R'),
      ('idle', 'userCancelled', 'R'),
      ('idle', 'systemInterrupted', 'R'),
      ('idle', 'rewardClaimed', 'R'),
      ('idle', 'acknowledged', 'R'),
      // running: 完走/中断系は正当、staleな猶予タイマーは無害(T4)、二重開始は違反
      ('running', 'startRequested', 'R'),
      ('running', 'graceTimeout', 'U'),
      ('running', 'timerCompleted', 'T'),
      ('running', 'userCancelled', 'T'),
      ('running', 'systemInterrupted', 'T'),
      ('running', 'rewardClaimed', 'R'),
      ('running', 'acknowledged', 'R'),
      // warning: 猶予切れ含め中断系すべて正当、完走も正当(猶予中の満了)
      ('warning', 'startRequested', 'R'),
      ('warning', 'graceTimeout', 'T'),
      ('warning', 'timerCompleted', 'T'),
      ('warning', 'userCancelled', 'T'),
      ('warning', 'systemInterrupted', 'T'),
      ('warning', 'rewardClaimed', 'R'),
      ('warning', 'acknowledged', 'R'),
      // completed: 請求だけが正当
      ('completed', 'startRequested', 'R'),
      ('completed', 'graceTimeout', 'R'),
      ('completed', 'timerCompleted', 'R'),
      ('completed', 'userCancelled', 'R'),
      ('completed', 'systemInterrupted', 'R'),
      ('completed', 'rewardClaimed', 'T'),
      ('completed', 'acknowledged', 'R'),
      // aborted: 了承だけが正当
      ('aborted', 'startRequested', 'R'),
      ('aborted', 'graceTimeout', 'R'),
      ('aborted', 'timerCompleted', 'R'),
      ('aborted', 'userCancelled', 'R'),
      ('aborted', 'systemInterrupted', 'R'),
      ('aborted', 'rewardClaimed', 'R'),
      ('aborted', 'acknowledged', 'T'),
    ];

    test('表の行数 = フェーズ数 × イベント数(転記漏れ検知)', () {
      expect(table, hasLength(phases.length * events.length));
      final seen = {for (final r in table) '${r.$1}/${r.$2}'};
      expect(seen, hasLength(table.length), reason: '重複行なし');
    });

    for (final (p, ev, kind) in table) {
      test('$p × $ev → $kind', () {
        final s = make(phase: phases[p]!);
        final r = SessionTransition.apply(s, events[ev]!);
        switch (kind) {
          case 'T':
            expect(r, isA<Transitioned>());
          case 'U':
            expect(r, isA<Unchanged>());
            expect((r as Unchanged).session, same(s));
          case 'R':
            expect(r, isA<Rejected>());
            final rej = r as Rejected;
            expect(rej.session, same(s), reason: 'Rejectedは状態を保持する');
            expect(rej.event, same(events[ev]), reason: '違反イベントを保持する');
        }
      });
    }
  });

  // -------------------------------------------------------------------------
  // 2. stanceイベント: 5フェーズ × 3スタンス = 15行(D8含む)
  // -------------------------------------------------------------------------
  group('遷移表スイープ(StanceChanged 15行)', () {
    const still = DeviceStance.faceUpStill();
    const vib = DeviceStance.microVibration(rms: 0.3);
    const lifted = DeviceStance.lifted();

    final rows = <(String, SessionPhase, DeviceStance, String)>[
      // 非アクティブ相: 連続イベントゆえ全て無害no-op(D8)
      ('idle', const SessionPhase.idle(), still, 'U'),
      ('idle', const SessionPhase.idle(), vib, 'U'),
      ('idle', const SessionPhase.idle(), lifted, 'U'),
      ('completed', const SessionPhase.completed(rewardCoins: 30), still, 'U'),
      ('completed', const SessionPhase.completed(rewardCoins: 30), vib, 'U'),
      ('completed', const SessionPhase.completed(rewardCoins: 30), lifted, 'U'),
      (
        'aborted',
        const SessionPhase.aborted(reason: AbortReason.graceTimeout),
        still,
        'U'
      ),
      (
        'aborted',
        const SessionPhase.aborted(reason: AbortReason.graceTimeout),
        vib,
        'U'
      ),
      (
        'aborted',
        const SessionPhase.aborted(reason: AbortReason.graceTimeout),
        lifted,
        'U'
      ),
      // アクティブ相
      ('running', const SessionPhase.running(), still, 'U'),
      ('running', const SessionPhase.running(), vib, 'T'),
      ('running', const SessionPhase.running(), lifted, 'T'),
      ('warning', const SessionPhase.warning(), still, 'T'),
      ('warning', const SessionPhase.warning(), vib, 'U'),
      ('warning', const SessionPhase.warning(), lifted, 'T'),
    ];

    test('表の行数 = 5フェーズ × 3スタンス(転記漏れ検知)', () {
      expect(rows, hasLength(15));
    });

    for (final (label, phase, stance, kind) in rows) {
      test('$label × stance(${stance.runtimeType}) → $kind', () {
        final s = make(phase: phase);
        final r =
            SessionTransition.apply(s, SessionEvent.stanceChanged(stance));
        expect(r, kind == 'T' ? isA<Transitioned>() : isA<Unchanged>());
      });
    }
  });

  // -------------------------------------------------------------------------
  // 3. Transitioned の詳細: 行き先フェーズ・副作用の内容と順序・ペイロード
  // -------------------------------------------------------------------------
  group('起動(idle → running)', () {
    test('solo: 副作用は [StartSessionTimer] のみ、elapsed はゼロへリセット', () {
      final s = make(elapsed: const Duration(minutes: 5));
      final r = mustTransition(s, const SessionEvent.startRequested());
      expect(r.session.phase, const SessionPhase.running());
      expect(r.session.elapsed, Duration.zero);
      expect(r.effects, [isA<StartSessionTimer>()]);
    });

    test('multi: 副作用は [StartSessionTimer, JoinPresence] の順', () {
      final s = make(sync: SyncMode.multi);
      final r = mustTransition(s, const SessionEvent.startRequested());
      expect(r.effects, [isA<StartSessionTimer>(), isA<JoinPresence>()]);
    });
  });

  group('警告(running ⇄ warning)', () {
    test('running × 微小振動 → warning + [StartGraceTimer]', () {
      final s = make(phase: const SessionPhase.running());
      final r = mustTransition(
          s, const SessionEvent.stanceChanged(DeviceStance.microVibration(rms: 0.3)));
      expect(r.session.phase, const SessionPhase.warning());
      expect(r.effects, [isA<StartGraceTimer>()]);
    });

    test('warning × 静止復帰 → running + [CancelGraceTimer](猶予解除)', () {
      final s = make(phase: const SessionPhase.warning());
      final r = mustTransition(
          s, const SessionEvent.stanceChanged(DeviceStance.faceUpStill()));
      expect(r.session.phase, const SessionPhase.running());
      expect(r.effects, [isA<CancelGraceTimer>()]);
    });
  });

  group('中断(→ aborted): 理由とsolo/multi副作用', () {
    final cases = <(String, SessionPhase, SessionEvent, AbortReason)>[
      (
        'running×持ち上げ',
        const SessionPhase.running(),
        const SessionEvent.stanceChanged(DeviceStance.lifted()),
        AbortReason.pickedUp
      ),
      (
        'warning×持ち上げ',
        const SessionPhase.warning(),
        const SessionEvent.stanceChanged(DeviceStance.lifted()),
        AbortReason.pickedUp
      ),
      (
        'warning×猶予切れ',
        const SessionPhase.warning(),
        const SessionEvent.graceTimeout(),
        AbortReason.graceTimeout
      ),
      (
        'running×ユーザー中断',
        const SessionPhase.running(),
        const SessionEvent.userCancelled(),
        AbortReason.userCancelled
      ),
      (
        'warning×ユーザー中断',
        const SessionPhase.warning(),
        const SessionEvent.userCancelled(),
        AbortReason.userCancelled
      ),
      (
        'running×システム中断(D3)',
        const SessionPhase.running(),
        const SessionEvent.systemInterrupted(),
        AbortReason.systemInterrupted
      ),
      (
        'warning×システム中断(D3)',
        const SessionPhase.warning(),
        const SessionEvent.systemInterrupted(),
        AbortReason.systemInterrupted
      ),
    ];

    for (final (label, phase, event, reason) in cases) {
      test('$label → aborted($reason)', () {
        final r = mustTransition(make(phase: phase), event);
        expect(
          r.session.phase,
          isA<Aborted>().having((a) => a.reason, 'reason', reason),
        );
        expect(r.effects, [isA<StopAllTimers>()], reason: 'soloはタイマー停止のみ');
      });
    }

    test('multi の中断は [StopAllTimers, LeavePresence] の順で退室する', () {
      final s = make(phase: const SessionPhase.warning(), sync: SyncMode.multi);
      final r = mustTransition(s, const SessionEvent.graceTimeout());
      expect(r.effects, [isA<StopAllTimers>(), isA<LeavePresence>()]);
    });
  });

  group('完走と請求(→ completed → idle)', () {
    test('running × 満了 → completed(コイン額はイベントのペイロードを透過)', () {
      final s = make(phase: const SessionPhase.running());
      final r = mustTransition(
          s, const SessionEvent.timerCompleted(rewardCoins: 42));
      expect(
        r.session.phase,
        isA<Completed>().having((c) => c.rewardCoins, 'rewardCoins', 42),
      );
      expect(r.effects, [isA<StopAllTimers>()]);
    });

    test('multi の完走は [StopAllTimers, LeavePresence] の順', () {
      final s = make(phase: const SessionPhase.running(), sync: SyncMode.multi);
      final r = mustTransition(
          s, const SessionEvent.timerCompleted(rewardCoins: 42));
      expect(r.effects, [isA<StopAllTimers>(), isA<LeavePresence>()]);
    });

    test('completed × 請求 → idle + GrantReward(sessionId とコイン額を正確に運搬)', () {
      final s = make(phase: const SessionPhase.completed(rewardCoins: 42));
      final r = mustTransition(s, const SessionEvent.rewardClaimed());
      expect(r.session.phase, const SessionPhase.idle());
      expect(r.effects, hasLength(1));
      expect(
        r.effects.single,
        isA<GrantReward>()
            .having((g) => g.coins, 'coins', 42)
            .having((g) => g.sessionId, 'sessionId', const SessionId('s-777')),
      );
    });

    test('aborted × 了承 → idle + 副作用なし(報酬は発生しない)', () {
      final s = make(
          phase: const SessionPhase.aborted(reason: AbortReason.userCancelled));
      final r = mustTransition(s, const SessionEvent.acknowledged());
      expect(r.session.phase, const SessionPhase.idle());
      expect(r.effects, isEmpty);
    });
  });

  // -------------------------------------------------------------------------
  // 4. 不変条件: 純粋性とフィールド保存
  // -------------------------------------------------------------------------
  group('不変条件', () {
    test('apply は入力セッションを変異させない(純関数)', () {
      final s = make(elapsed: const Duration(minutes: 3));
      final before = s;
      SessionTransition.apply(s, const SessionEvent.startRequested());
      expect(s, same(before));
      expect(s.phase, const SessionPhase.idle());
      expect(s.elapsed, const Duration(minutes: 3));
    });

    test('遷移は id / motifId / syncMode / plannedDuration を保存する', () {
      var s = make(sync: SyncMode.multi);
      final journey = <SessionEvent>[
        const SessionEvent.startRequested(),
        const SessionEvent.stanceChanged(DeviceStance.microVibration(rms: 0.2)),
        const SessionEvent.stanceChanged(DeviceStance.faceUpStill()),
        const SessionEvent.timerCompleted(rewardCoins: 30),
        const SessionEvent.rewardClaimed(),
      ];
      for (final e in journey) {
        final r = SessionTransition.apply(s, e);
        expect(r, isA<Transitioned>(), reason: '正常旅程の各歩: $e');
        s = (r as Transitioned).session;
        expect(s.id, const SessionId('s-777'));
        expect(s.motifId, const MotifId('water'));
        expect(s.syncMode, SyncMode.multi);
        expect(s.plannedDuration, const Duration(minutes: 25));
      }
      expect(s.phase, const SessionPhase.idle(), reason: '完全な一周でidleへ帰還');
    });

    test('中断旅程も一周してidleへ帰還する(start→lifted→acknowledged)', () {
      var s = make();
      for (final e in <SessionEvent>[
        const SessionEvent.startRequested(),
        const SessionEvent.stanceChanged(DeviceStance.lifted()),
        const SessionEvent.acknowledged(),
      ]) {
        s = (SessionTransition.apply(s, e) as Transitioned).session;
      }
      expect(s.phase, const SessionPhase.idle());
    });
  });
}
