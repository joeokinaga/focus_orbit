import 'dart:math' as math;
import 'dart:typed_data';

import 'accumulation_behavior.dart';
import 'physics_tuning.dart';
import 'stage_types.dart';

/// 注がれる滴(容器フレーム)。水モチーフ専有 — P4-V1では stage_simulation.dart
/// 直下にあったが、モチーフ固有の粒子になったためこちらへ移設。
class StageDroplet {
  StageDroplet(
      {required this.x, required this.y, required this.vx, required this.vy});
  double x, y, vx, vy;
}

/// 水中の泡(容器フレーム)。
class StageBubble {
  StageBubble({
    required this.x,
    required this.y,
    required this.radius,
    required this.wobblePhase,
    required this.speed,
  });
  double x, y;
  final double radius;
  final double wobblePhase;
  double speed;
}

/// 水モチーフの蓄積表現。フィールド名・意味はP4-V1のStageSimulationと同一。
final class WaterAccumulationState extends AccumulationState {
  WaterAccumulationState(int columnCount)
      : heights = Float64List(columnCount),
        velocities = Float64List(columnCount);

  final Float64List heights;
  final Float64List velocities;
  final List<StageDroplet> droplets = [];
  final List<StageBubble> bubbles = [];
  double fill = 0;

  /// 静止水面の y 位置(容器フレーム・上端=0)。
  double get surfaceLevelY => 1.0 - (0.06 + 0.86 * fill);
}

/// 水モチーフの Rule1 実装。P4-V1 の StageSimulation 内ロジック
/// (_stepFill/_stepSurface/_stepDroplets/_splashAt/_stepBubbles/_spawnBubble)
/// を1:1移設したもの — 数式・定数の意味は一切変更していない。
///
/// 【移行計画メモ(P4-V4向け)】P4-V1/V2 の stage_simulation_test.dart に
/// ある17件は、現状 StageSimulation の具象フィールド(sim.fill / sim.droplets
/// 等)を直接読んでいる。本クラスへ委譲するP4-V4の配線時、それらのテストは
/// 「本クラスを直接構築して同じアサーションを行う」形へ移設する
/// (アサーション内容そのものは変えない — 呼び出し経路が変わるだけ)。
final class WaterAccumulationBehavior implements AccumulationBehavior {
  WaterAccumulationBehavior(this._tuning, {int columnCount = 48})
      : state = WaterAccumulationState(columnCount);

  final WaterTuning _tuning;

  @override
  final WaterAccumulationState state;

  static const int maxDroplets = 40;
  static const int maxBubbles = 60;

  double _targetFill = 0;
  double _dropletTimer = 0;
  double _bubbleTimer = 0;
  double _simTime = 0;

  @override
  void step({
    required double h,
    required AccumulationInputs inputs,
    required List<OrbitRing> rings, // 水は無関係(D27の例外はHourglassのみ)
    required math.Random rng,
  }) {
    _simTime += h;
    _targetFill = inputs.targetFill;
    _stepFill(h);
    _stepSurface(h);
    _stepDroplets(h, inputs, rng);
    _stepBubbles(h, rng);
  }

  // ---- 蓄積: 進捗へゆっくり追従(「注がれて満ちていく」重量感) -----------
  void _stepFill(double h) {
    final rate = (_tuning.fillEaseRate * h).clamp(0.0, 1.0).toDouble();
    state.fill += (_targetFill - state.fill) * rate;
    if ((_targetFill - state.fill).abs() < 1e-4) state.fill = _targetFill;
  }

  // ---- 表面: 半陰的オイラーのバネ格子 ------------------------------------
  void _stepSurface(double h) {
    final heights = state.heights;
    final velocities = state.velocities;
    final n = heights.length;
    for (var i = 0; i < n; i++) {
      final left = heights[i > 0 ? i - 1 : i];
      final right = heights[i < n - 1 ? i + 1 : i];
      final laplacian = left + right - 2 * heights[i];
      final accel = -_tuning.springK * heights[i] +
          _tuning.surfaceSpread * laplacian -
          _tuning.viscosity * velocities[i];
      velocities[i] += accel * h;
    }
    for (var i = 0; i < n; i++) {
      heights[i] += velocities[i] * h;
    }
  }

  // ---- 滴: 上から注がれ、着水で表面を叩く ---------------------------------
  void _stepDroplets(double h, AccumulationInputs inputs, math.Random rng) {
    if (inputs.pouring && state.fill < 0.999) {
      _dropletTimer -= h;
      if (_dropletTimer <= 0 && state.droplets.length < maxDroplets) {
        _dropletTimer =
            _tuning.dropletBaseInterval / (0.6 + 0.8 * inputs.intensity);
        state.droplets.add(StageDroplet(
          x: 0.5 + (rng.nextDouble() - 0.5) * 0.36,
          y: -0.06,
          vx: 0,
          vy: 0.15,
        ));
      }
    }

    final surfaceY = state.surfaceLevelY;
    for (var i = state.droplets.length - 1; i >= 0; i--) {
      final d = state.droplets[i];
      d.vy += _tuning.gravity * h;
      d.x += d.vx * h;
      d.y += d.vy * h;

      final outOfBounds = d.x < -0.2 || d.x > 1.2 || d.y > 1.2;
      if (d.y >= surfaceY && !outOfBounds) {
        _splashAt(d.x, d.vy, rng);
        state.droplets.removeAt(i);
      } else if (outOfBounds) {
        state.droplets.removeAt(i);
      }
    }
  }

  /// 着水: 最寄り列を叩き下げ、隣列に半分伝える。
  void _splashAt(double x, double impactSpeed, math.Random rng) {
    final velocities = state.velocities;
    final n = velocities.length;
    final idx = (x.clamp(0.0, 1.0) * (n - 1)).round();
    final kick = _tuning.splashKick * impactSpeed;
    velocities[idx] -= kick;
    if (idx > 0) velocities[idx - 1] -= kick * 0.5;
    if (idx < n - 1) velocities[idx + 1] -= kick * 0.5;

    if (state.bubbles.length < maxBubbles && rng.nextDouble() < 0.35) {
      _spawnBubble(x: x, rng: rng);
    }
  }

  // ---- 泡: 浮力で立ち上り、水面で弾ける -----------------------------------
  void _stepBubbles(double h, math.Random rng) {
    if (_tuning.buoyancy > 0 && state.fill > 0.12) {
      _bubbleTimer -= h;
      if (_bubbleTimer <= 0 && state.bubbles.length < maxBubbles) {
        _bubbleTimer = 0.9 / (0.3 + state.fill);
        _spawnBubble(x: rng.nextDouble(), rng: rng);
      }
    }

    final surfaceY = state.surfaceLevelY;
    for (var i = state.bubbles.length - 1; i >= 0; i--) {
      final b = state.bubbles[i];
      b.y -= b.speed * h;
      b.x += math.sin(b.wobblePhase + _simTime * 3.0) * 0.02 * h;

      if (b.y <= surfaceY + 0.01) {
        final velocities = state.velocities;
        final n = velocities.length;
        final idx = (b.x.clamp(0.0, 1.0) * (n - 1)).round();
        velocities[idx] += _tuning.bubblePopKick;
        state.bubbles.removeAt(i);
      }
    }
  }

  void _spawnBubble({required double x, required math.Random rng}) {
    state.bubbles.add(StageBubble(
      x: x.clamp(0.02, 0.98).toDouble(),
      y: 0.97,
      radius: 0.006 + rng.nextDouble() * 0.010,
      wobblePhase: rng.nextDouble() * math.pi * 2,
      speed: _tuning.buoyancy * (0.6 + 0.8 * rng.nextDouble()),
    ));
  }

  @override
  void reset() {
    state.fill = 0;
    _targetFill = 0;
    _dropletTimer = 0;
    _bubbleTimer = 0;
    _simTime = 0;
    for (var i = 0; i < state.heights.length; i++) {
      state.heights[i] = 0;
      state.velocities[i] = 0;
    }
    state.droplets.clear();
    state.bubbles.clear();
  }
}
