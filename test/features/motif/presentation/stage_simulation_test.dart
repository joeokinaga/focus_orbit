import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

import 'package:focus_orbit/features/motif/presentation/stage/stage_simulation.dart';

/// P4-V1 テスト計画マトリクス(§qa: セル⇔テスト 1:1)
///
/// | # | 面 | ケース | オラクル |
/// |---|---|---|---|
/// | 1 | setTargetFill/fill | happy: 収束 | 60s後 |fill-1|<0.02・単調増加 |
/// | 2 | setTargetFill | 境界: >1 / <0 クランプ | 収束先が 1.0 / 0.0 |
/// | 3 | setIntensity | 境界: >1 / <0 クランプ | intensity==1.0 / 0.0 |
/// | 4 | advance | 初回=基準点(ステップなし) | fill==0 のまま |
/// | 5 | advance | 逆行Tick(dt<=0) | 状態不変 |
/// | 6 | advance | 巨大dt(復帰) | 全高さ有限・爆発なし |
/// | 7 | surface | 静止入力 | 無からエネルギーが湧かない(≈0) |
/// | 8 | surface | shatter衝撃の減衰 | 10s後 max|h| < 0.01 かつ < ピーク |
/// | 9 | droplets | pouring中の生成と着水波 | 滴が出現し表面が乱れる |
/// | 10 | budget | 粒子予算 | droplets/bubbles/freed が常に上限以下 |
/// | 11 | bubbles | 水面を越えない | 生存泡は y > surfaceY - 0.05 |
/// | 12 | orbit | 集中度→角速度 | 高intensityの変位 > 低intensity |
/// | 13 | orbit | しきい値で輪が点灯 | 0.2: ring0のみ / 0.8: 3輪 |
/// | 14 | shatter | 粉砕→飛散→再生 | motes 0・freed>0(速度≠0)→再生 |
/// | 15 | 決定性 | 同シード同操作 | 表面・fill・角度が完全一致 |
/// | 16 | reset (P4-V2) | 残滓の完全消去 | fill/粒子/飛散/水面が初期値 |
/// | 17 | reset (P4-V2) | 時間基準の再確立 | 新Tickerで1フレーム後に前進再開 |
///
/// フェイク: なし(simは純Dart・時刻は advance 引数で注入)。実時間スリープなし。
void main() {
  group('StageSimulation', () {
    test('fill_easesTowardTarget_monotonicallyConverges', () {
      final sim = StageSimulation(seed: 1);
      final drv = _SimDriver(sim);
      sim.setTargetFill(1.0);

      var prev = sim.fill;
      var monotonic = true;
      for (var s = 0; s < 60; s++) {
        drv.run(seconds: 1);
        if (sim.fill < prev - 1e-9) monotonic = false;
        prev = sim.fill;
      }
      expect(monotonic, isTrue, reason: '蓄積は減らずに満ちていく');
      expect((sim.fill - 1.0).abs(), lessThan(0.02));
    });

    test('setTargetFill_outOfRange_clampsToUnitInterval', () {
      final over = StageSimulation(seed: 2)..setTargetFill(1.5);
      final under = StageSimulation(seed: 2)..setTargetFill(-0.3);
      _SimDriver(over).run(seconds: 90);
      _SimDriver(under).run(seconds: 90);
      expect(over.fill, closeTo(1.0, 0.02));
      expect(under.fill, closeTo(0.0, 1e-6));
    });

    test('setIntensity_outOfRange_clampsToUnitInterval', () {
      final sim = StageSimulation(seed: 3);
      sim.setIntensity(2.0);
      expect(sim.intensity, 1.0);
      sim.setIntensity(-1.0);
      expect(sim.intensity, 0.0);
    });

    test('advance_firstCall_isBaselineOnly_noPhysicsStep', () {
      final sim = StageSimulation(seed: 4)..setTargetFill(1.0);
      sim.advance(const Duration(milliseconds: 500));
      expect(sim.fill, 0.0, reason: '初回advanceは基準点の記録のみ');
    });

    test('advance_nonMonotonicTick_isIgnored', () {
      final sim = StageSimulation(seed: 5)..setTargetFill(1.0);
      sim.advance(const Duration(milliseconds: 100)); // 基準点
      sim.advance(const Duration(milliseconds: 300)); // 前進
      final fillAfterForward = sim.fill;
      sim.advance(const Duration(milliseconds: 200)); // 逆行(dt<0)
      expect(sim.fill, fillAfterForward, reason: '逆行Tickで状態は動かない');
    });

    test('advance_hugeGap_clampsSubsteps_staysFinite', () {
      final sim = StageSimulation(seed: 6)..setTargetFill(1.0);
      sim.advance(Duration.zero);
      sim.shatter(impulse: 3.0); // わざと荒れた状態で
      sim.advance(const Duration(seconds: 10)); // アプリ復帰の巨大dt
      for (final h in sim.surfaceHeights) {
        expect(h.isFinite, isTrue);
        expect(h.abs(), lessThan(10));
      }
      expect(sim.fill, lessThan(0.2),
          reason: '巨大dtの追い付き実行はしない(最大サブステップで打ち切り)');
    });

    test('surface_withNoInput_generatesNoEnergy', () {
      final sim = StageSimulation(seed: 7);
      _SimDriver(sim).run(seconds: 5);
      expect(_maxAbs(sim.surfaceHeights), lessThan(1e-9));
    });

    test('shatter_surfaceShock_decaysUnderDamping', () {
      final sim = StageSimulation(seed: 8);
      final drv = _SimDriver(sim);
      drv.run(seconds: 0.1);
      sim.shatter();
      drv.run(seconds: 0.2);
      final peak = _maxAbs(sim.surfaceHeights);
      expect(peak, greaterThan(0), reason: '崩壊は表面を実際に乱す');
      drv.run(seconds: 10);
      final settled = _maxAbs(sim.surfaceHeights);
      expect(settled, lessThan(peak));
      expect(settled, lessThan(0.01), reason: '減衰項が波を静める');
    });

    test('droplets_spawnWhilePouring_andSplashesPerturbSurface', () {
      final sim = StageSimulation(seed: 9)
        ..setTargetFill(0.5)
        ..setPouring(true);
      final drv = _SimDriver(sim);
      var dropletSeen = false;
      for (var i = 0; i < 40; i++) {
        drv.run(seconds: 0.1);
        if (sim.droplets.isNotEmpty) dropletSeen = true;
      }
      expect(dropletSeen, isTrue, reason: '注入中は滴が生成される');
      expect(_maxAbs(sim.surfaceHeights), greaterThan(0),
          reason: '着水が表面を乱す');
    });

    test('particleBudgets_areNeverExceeded', () {
      final sim = StageSimulation(seed: 10)
        ..setTargetFill(1.0)
        ..setIntensity(1.0)
        ..setPouring(true);
      final drv = _SimDriver(sim);
      for (var i = 0; i < 20; i++) {
        drv.run(seconds: 1);
        sim.shatter(impulse: 3.0);
        expect(sim.droplets.length,
            lessThanOrEqualTo(StageSimulation.maxDroplets));
        expect(
            sim.bubbles.length, lessThanOrEqualTo(StageSimulation.maxBubbles));
        expect(sim.freedMotes.length,
            lessThanOrEqualTo(StageSimulation.maxFreedMotes));
      }
    });

    test('bubbles_neverSurviveAboveSurface', () {
      final sim = StageSimulation(seed: 11)
        ..setTargetFill(0.7)
        ..setPouring(true);
      final drv = _SimDriver(sim);
      for (var i = 0; i < 30; i++) {
        drv.run(seconds: 0.5);
        for (final b in sim.bubbles) {
          expect(b.y, greaterThan(sim.surfaceLevelY - 0.05),
              reason: '水面に達した泡は弾けて消える');
        }
      }
    });

    test('orbit_angularDisplacement_scalesWithIntensity', () {
      final low = StageSimulation(seed: 12)..setIntensity(0.1);
      final high = StageSimulation(seed: 12)..setIntensity(0.9);
      final drvLow = _SimDriver(low);
      final drvHigh = _SimDriver(high);
      // ring0 のモートが生えるまで育てる
      drvLow.run(seconds: 3);
      drvHigh.run(seconds: 3);
      expect(low.rings[0].moteAngles, isNotEmpty);
      expect(high.rings[0].moteAngles, isNotEmpty);

      final beforeLow = low.rings[0].moteAngles[0];
      final beforeHigh = high.rings[0].moteAngles[0];
      drvLow.run(seconds: 0.2);
      drvHigh.run(seconds: 0.2);
      final dLow = _wrappedDelta(beforeLow, low.rings[0].moteAngles[0]);
      final dHigh = _wrappedDelta(beforeHigh, high.rings[0].moteAngles[0]);
      expect(dHigh.abs(), greaterThan(dLow.abs()),
          reason: '集中が深いほどオービットは速く回る');
    });

    test('orbit_rings_activateOnlyAboveTheirThreshold', () {
      final calm = StageSimulation(seed: 13)..setIntensity(0.2);
      _SimDriver(calm).run(seconds: 10);
      expect(calm.rings[0].moteAngles, isNotEmpty);
      expect(calm.rings[1].moteAngles, isEmpty, reason: 'しきい値0.35未満');
      expect(calm.rings[2].moteAngles, isEmpty, reason: 'しきい値0.7未満');

      final deep = StageSimulation(seed: 13)..setIntensity(0.8);
      _SimDriver(deep).run(seconds: 10);
      expect(deep.rings[0].moteAngles, isNotEmpty);
      expect(deep.rings[1].moteAngles, isNotEmpty);
      expect(deep.rings[2].moteAngles, isNotEmpty);
    });

    test('shatter_freesAllMotesWithVelocity_thenOrbitRegrows', () {
      final sim = StageSimulation(seed: 14)..setIntensity(0.9);
      final drv = _SimDriver(sim);
      drv.run(seconds: 10);
      expect(sim.totalMoteCount, greaterThan(0));

      sim.shatter();
      expect(sim.totalMoteCount, 0, reason: '崩壊は全モートを解放する');
      expect(sim.freedMotes, isNotEmpty);
      for (final m in sim.freedMotes) {
        expect(m.velocity.distance, greaterThan(0),
            reason: '解放粒子は接線速度を持って飛散する');
      }

      drv.run(seconds: 6);
      expect(sim.totalMoteCount, greaterThan(0), reason: 'オービットは徐々に再生する');
      expect(sim.freedMotes, isEmpty, reason: '飛散粒子は寿命で消える');
    });

    test('determinism_sameSeedSameOps_producesIdenticalState', () {
      StageSimulation build() => StageSimulation(seed: 42);
      void script(StageSimulation sim, _SimDriver drv) {
        sim
          ..setTargetFill(0.8)
          ..setIntensity(0.7)
          ..setPouring(true);
        drv.run(seconds: 4);
        sim.shatter(impulse: 1.3);
        drv.run(seconds: 2);
      }

      final a = build();
      final b = build();
      script(a, _SimDriver(a));
      script(b, _SimDriver(b));

      expect(a.fill, b.fill);
      expect(a.surfaceHeights, equals(b.surfaceHeights));
      expect(a.droplets.length, b.droplets.length);
      expect(a.bubbles.length, b.bubbles.length);
      expect(a.freedMotes.length, b.freedMotes.length);
      for (var r = 0; r < a.rings.length; r++) {
        expect(a.rings[r].moteAngles, equals(b.rings[r].moteAngles));
      }
    });

    test('reset_clearsAllCarryover_toInitialState', () {
      final sim = StageSimulation(seed: 5);
      final drv = _SimDriver(sim);
      // 前セッションの残滓を作る: 蓄積・注入・崩壊まで一通り
      sim
        ..setTargetFill(0.9)
        ..setIntensity(0.8)
        ..setPouring(true);
      drv.run(seconds: 8);
      sim.shatter(impulse: 1.5);
      drv.run(seconds: 0.5);
      expect(sim.fill, greaterThan(0.1), reason: '前提: 残滓が実在する');
      expect(sim.freedMotes, isNotEmpty, reason: '前提: 飛散粒子が実在する');

      sim.reset();

      expect(sim.fill, 0.0);
      expect(sim.pouring, isFalse);
      expect(sim.intensity, 0.0);
      expect(sim.droplets, isEmpty);
      expect(sim.bubbles, isEmpty);
      expect(sim.freedMotes, isEmpty);
      expect(sim.totalMoteCount, 0);
      expect(_maxAbs(sim.surfaceHeights), 0.0, reason: '水面は完全な静止へ');
    });

    test('reset_rebasesTimeOrigin_freshTickerResumesInOneFrame', () {
      final sim = StageSimulation(seed: 6);
      final drv = _SimDriver(sim);
      sim.setTargetFill(1.0);
      drv.run(seconds: 30); // Ticker 経過が大きい状態を作る

      sim.reset();
      sim.setTargetFill(1.0);

      // 再マウント相当: 新しい Ticker はゼロ近傍から始まる。
      // reset が時間基準を破棄していれば、巨大な負dtに惑わされず
      // 2フレーム目から前進する(1フレーム目=基準点の確立)。
      sim.advance(const Duration(milliseconds: 16));
      final fillAfterBaseline = sim.fill;
      var t = const Duration(milliseconds: 16);
      for (var i = 0; i < 120; i++) {
        t += const Duration(milliseconds: 16);
        sim.advance(t);
      }
      expect(fillAfterBaseline, 0.0, reason: '基準点確立フレームでは進まない');
      expect(sim.fill, greaterThan(0.05), reason: '以降は正常に前進する');
    });
  });
}

// -----------------------------------------------------------------------------
// テスト駆動: 16ms刻みの合成Tick(実時間スリープなし・決定的)
// -----------------------------------------------------------------------------

class _SimDriver {
  _SimDriver(this.sim) {
    sim.advance(Duration.zero); // 基準点
  }

  final StageSimulation sim;
  Duration _t = Duration.zero;

  void run({required double seconds}) {
    final frames = (seconds * 1000 / 16).round();
    for (var i = 0; i < frames; i++) {
      _t += const Duration(milliseconds: 16);
      sim.advance(_t);
    }
  }
}

double _maxAbs(List<double> values) =>
    values.fold(0.0, (m, v) => math.max(m, v.abs()));

/// 角度差を [-π, π) に折り返して返す(2π跨ぎの誤判定防止)。
double _wrappedDelta(double before, double after) {
  var d = (after - before) % (2 * math.pi);
  if (d >= math.pi) d -= 2 * math.pi;
  if (d < -math.pi) d += 2 * math.pi;
  return d;
}
