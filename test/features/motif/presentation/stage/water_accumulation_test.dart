import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';

import 'package:focus_orbit/features/motif/presentation/stage/physics/accumulation_behavior.dart';
import 'package:focus_orbit/features/motif/presentation/stage/physics/physics_tuning.dart';
import 'package:focus_orbit/features/motif/presentation/stage/physics/stage_types.dart';
import 'package:focus_orbit/features/motif/presentation/stage/physics/water_accumulation.dart';

/// P4-V3: WaterAccumulationBehavior への移行が P4-V1 時点の挙動を
/// 変えていないことのスポットチェック(全17件の正式な移設はP4-V4)。
void main() {
  group('WaterAccumulationBehavior — 移行後の非回帰確認', () {
    test('fillはtargetFillへ単調収束する(P4-V1 test #1と同一性質)', () {
      final behavior = WaterAccumulationBehavior(const WaterTuning());
      final rng = math.Random(1);
      const List<OrbitRing> rings = [];
      const inputs =
          AccumulationInputs(targetFill: 1.0, intensity: 0.5, pouring: false);

      var prev = behavior.state.fill;
      var monotonic = true;
      for (var s = 0; s < 60 * 60; s++) {
        behavior.step(h: 1 / 60, inputs: inputs, rings: rings, rng: rng);
        if (behavior.state.fill < prev - 1e-9) monotonic = false;
        prev = behavior.state.fill;
      }
      expect(monotonic, isTrue);
      expect((behavior.state.fill - 1.0).abs(), lessThan(0.02));
    });

    test('静止入力からはエネルギーが湧かない(P4-V1 test #7と同一性質)', () {
      final behavior = WaterAccumulationBehavior(const WaterTuning());
      final rng = math.Random(2);
      const List<OrbitRing> rings = [];
      const inputs =
          AccumulationInputs(targetFill: 0.0, intensity: 0.0, pouring: false);

      for (var s = 0; s < 60 * 5; s++) {
        behavior.step(h: 1 / 60, inputs: inputs, rings: rings, rng: rng);
      }
      final maxAbs = behavior.state.heights
          .fold(0.0, (m, v) => math.max(m, v.abs()));
      expect(maxAbs, lessThan(1e-6));
    });

    test('reset は fill・水面・粒子を初期状態へ戻す', () {
      final behavior = WaterAccumulationBehavior(const WaterTuning());
      final rng = math.Random(3);
      const List<OrbitRing> rings = [];
      const inputs =
          AccumulationInputs(targetFill: 0.9, intensity: 0.8, pouring: true);

      for (var s = 0; s < 60 * 8; s++) {
        behavior.step(h: 1 / 60, inputs: inputs, rings: rings, rng: rng);
      }
      expect(behavior.state.fill, greaterThan(0.1));

      behavior.reset();

      expect(behavior.state.fill, 0.0);
      expect(behavior.state.droplets, isEmpty);
      expect(behavior.state.bubbles, isEmpty);
    });
  });
}
