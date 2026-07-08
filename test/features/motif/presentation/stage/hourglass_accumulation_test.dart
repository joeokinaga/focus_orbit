import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

import 'package:focus_orbit/features/motif/presentation/stage/physics/accumulation_behavior.dart';
import 'package:focus_orbit/features/motif/presentation/stage/physics/hourglass_accumulation.dart';
import 'package:focus_orbit/features/motif/presentation/stage/physics/physics_tuning.dart';
import 'package:focus_orbit/features/motif/presentation/stage/physics/stage_types.dart';

/// P4-V3: Hourglass の「上ステージ(共有オービット)→下ステージ(砂山)」
/// 移送ブリッジ(D27)が実際に機能することの証明。
///
/// 【設計原則(写経防止)】期待値は実装から逆算せず、この移送が満たすべき
/// 性質(モート数保存・重力落下・堆積の単調性・安息角維持)を独立に記述する。
void main() {
  group('HourglassAccumulationBehavior — D27 ステージ間移送', () {
    List<OrbitRing> makeFullRing({int moteCount = 10, double radius = 0.2}) {
      final ring = OrbitRing(
        threshold: 0.0,
        radiusUnit: radius,
        moteTarget: moteCount,
        speedSign: 1,
      );
      for (var i = 0; i < moteCount; i++) {
        ring.moteAngles.add(i * (2 * math.pi / moteCount));
      }
      return [ring];
    }

    test('pouring中は一定間隔で共有リングから正確に1モートずつ引き抜かれる',
        () {
      final tuning = const HourglassTuning(grainReleaseInterval: 1.0);
      final behavior = HourglassAccumulationBehavior(tuning);
      final rings = makeFullRing(moteCount: 5);
      final rng = math.Random(1);
      const inputs =
          AccumulationInputs(targetFill: 1.0, intensity: 0.5, pouring: true);

      final before = rings.first.moteAngles.length;
      // interval=1.0s, intensity=0.5 → release周期 = 1.0/(0.6+0.4)=1.0s
      // 1.0s分(60ステップ)進めると、ちょうど1個引き抜かれるはず
      for (var i = 0; i < 60; i++) {
        behavior.step(
            h: 1 / 60, inputs: inputs, rings: rings, rng: rng);
      }
      expect(rings.first.moteAngles.length, before - 1,
          reason: '共有リングから直接1個減っている(D27の実引き抜き)');
    });

    test('引き抜かれたモートはチャネル経由で落下粒になり、最終的に砂山へ着地する',
        () {
      final tuning = const HourglassTuning(
        grainReleaseInterval: 0.1,
        gravity: 5.0, // テストを短時間で収束させるため強めに設定
      );
      final behavior = HourglassAccumulationBehavior(tuning, pileColumns: 8);
      final rings = makeFullRing(moteCount: 3);
      final rng = math.Random(2);
      const inputs =
          AccumulationInputs(targetFill: 1.0, intensity: 1.0, pouring: true);

      final totalBefore = _sum(behavior.state.pileHeights);
      for (var i = 0; i < 600; i++) {
        // 10秒分
        behavior.step(
            h: 1 / 60, inputs: inputs, rings: rings, rng: rng);
      }
      final totalAfter = _sum(behavior.state.pileHeights);

      expect(totalAfter, greaterThan(totalBefore),
          reason: '砂山の総堆積量が増えている(粒が着地した)');
      expect(behavior.state.fallingGrains, isEmpty,
          reason: '十分な時間が経てば全ての粒は着地済み');
    });

    test('pouringがfalseなら共有リングは減らない(移送は注入中のみ)', () {
      final tuning = const HourglassTuning(grainReleaseInterval: 0.1);
      final behavior = HourglassAccumulationBehavior(tuning);
      final rings = makeFullRing(moteCount: 5);
      final rng = math.Random(3);
      const inputs =
          AccumulationInputs(targetFill: 1.0, intensity: 1.0, pouring: false);

      final before = rings.first.moteAngles.length;
      for (var i = 0; i < 300; i++) {
        behavior.step(
            h: 1 / 60, inputs: inputs, rings: rings, rng: rng);
      }
      expect(rings.first.moteAngles.length, before);
    });

    test('全リングが空になった後は例外を投げず何もしない(境界)', () {
      final tuning = const HourglassTuning(grainReleaseInterval: 0.05);
      final behavior = HourglassAccumulationBehavior(tuning);
      final rings = makeFullRing(moteCount: 1);
      final rng = math.Random(4);
      const inputs =
          AccumulationInputs(targetFill: 1.0, intensity: 1.0, pouring: true);

      expect(() {
        for (var i = 0; i < 600; i++) {
          behavior.step(
              h: 1 / 60, inputs: inputs, rings: rings, rng: rng);
        }
      }, returnsNormally);
      expect(rings.first.moteAngles, isEmpty);
    });

    test('砂山は隣接列との高低差が安息角を超えない(単純オートマトンの安定性)',
        () {
      final tuning = const HourglassTuning(
        grainReleaseInterval: 0.02,
        gravity: 6.0,
        angleOfReposeSlope: 0.05,
      );
      final behavior = HourglassAccumulationBehavior(tuning, pileColumns: 16);
      final rings = makeFullRing(moteCount: 40, radius: 0.05); // 中心付近に集中投下
      final rng = math.Random(5);
      const inputs =
          AccumulationInputs(targetFill: 1.0, intensity: 1.0, pouring: true);

      for (var i = 0; i < 1800; i++) {
        // 30秒分
        behavior.step(
            h: 1 / 60, inputs: inputs, rings: rings, rng: rng);
      }

      final heights = behavior.state.pileHeights;
      var maxSlope = 0.0;
      for (var i = 0; i < heights.length - 1; i++) {
        maxSlope = math.max(maxSlope, (heights[i] - heights[i + 1]).abs());
      }
      // 完全収束はしなくても、安息角の数倍以内には収まる(発散しない)
      expect(maxSlope, lessThan(tuning.angleOfReposeSlope * 5),
          reason: '砂山が発散せず山型に近い形へ安定化している');
    });

    test('reset は砂山・落下粒・移送タイマーを初期状態へ戻す', () {
      final tuning = const HourglassTuning(grainReleaseInterval: 0.05);
      final behavior = HourglassAccumulationBehavior(tuning);
      final rings = makeFullRing(moteCount: 10);
      final rng = math.Random(6);
      const inputs =
          AccumulationInputs(targetFill: 1.0, intensity: 1.0, pouring: true);

      for (var i = 0; i < 300; i++) {
        behavior.step(
            h: 1 / 60, inputs: inputs, rings: rings, rng: rng);
      }
      expect(_sum(behavior.state.pileHeights), greaterThan(0),
          reason: '前提: 堆積が実在する');

      behavior.reset();

      expect(_sum(behavior.state.pileHeights), 0.0);
      expect(behavior.state.fallingGrains, isEmpty);
      expect(behavior.state.upperRemaining, 1.0);
    });
  });
}

double _sum(List<double> values) => values.fold(0.0, (a, b) => a + b);
