import 'dart:math' as math;
import 'dart:typed_data';

import 'accumulation_behavior.dart';
import 'physics_tuning.dart';
import 'stage_transfer_channel.dart';
import 'stage_types.dart';

/// 移送中の落下粒(容器フレーム)。StageTransferChannel から生まれ、
/// 着地して pileHeights に吸収されると消える。
class TransferGrain {
  TransferGrain({required this.x, required this.y, required this.vy});
  double x, y, vy;
}

/// 砂時計モチーフの蓄積表現。
///
/// 【検討依頼2への回答(データ構造)】「上ステージ」は本クラスが保持しない —
/// 共有オービット(List<OrbitRing>、StageSimulation host所有)がそのまま
/// 上ステージを兼ねる。本クラスが持つのは「下ステージ」(pileHeights /
/// fallingGrains)と、上ステージの残量を表示するための派生値
/// (upperRemaining)だけ。
final class HourglassAccumulationState extends AccumulationState {
  HourglassAccumulationState(int pileColumns)
      : pileHeights = Float64List(pileColumns);

  /// 下段の砂山(列ごとの堆積高。水と違い基本は単調増加 — 崩壊時のみ乱れる)。
  final Float64List pileHeights;

  /// 上段(共有オービット)から移送中の落下粒。
  final List<TransferGrain> fallingGrains = [];

  /// 上段の残量 0..1(全リング目標数に対する現存モート比。
  /// 「あと少しで空になる」表示用の派生値 — 真実は rings 自体)。
  double upperRemaining = 1.0;
}

/// 砂時計モチーフの Rule1 実装。検討依頼2「ステージ間接続」の実体。
///
/// 【設計要旨】
/// 1. 上ステージ = 共有オービット(rings)をそのまま流用。専用の
///    「上段データ構造」は作らない(D23の恩恵をそのまま受け取る)。
/// 2. pouring 中、一定間隔(tuning.grainReleaseInterval・集中度で短縮)ごとに
///    [_detachOneGrain] が rings から直接モートを1個引き抜き、
///    StageTransferChannel へ種(角度・輪半径)として積む
///    (accumulation_behavior.dart の D27 参照)。
/// 3. 毎ステップ [_drainChannel] がチャネルを空にし、種を実際の
///    TransferGrain(落下粒)へ変換する。
/// 4. 落下粒は tuning.gravity で落下し、下段の砂山へ着地して吸収される。
/// 5. [_stabilizePile] が隣接列の高低差を安息角(tuning.angleOfReposeSlope)
///    まで均す単純な1次元オートマトンで、山型に近い見た目を安価に作る
///    (厳密な粒状体シミュレーションではない — P4-V0方針「論理的美しさより
///    触った時の心地よさ」を踏襲)。
final class HourglassAccumulationBehavior implements AccumulationBehavior {
  HourglassAccumulationBehavior(this._tuning, {int pileColumns = 32})
      : state = HourglassAccumulationState(pileColumns);

  final HourglassTuning _tuning;

  @override
  final HourglassAccumulationState state;

  final StageTransferChannel _channel = StageTransferChannel();
  double _releaseTimer = 0;

  @override
  void step({
    required double h,
    required AccumulationInputs inputs,
    required List<OrbitRing> rings,
    required math.Random rng,
  }) {
    if (inputs.pouring) {
      _releaseTimer -= h;
      if (_releaseTimer <= 0) {
        _releaseTimer =
            _tuning.grainReleaseInterval / (0.6 + 0.8 * inputs.intensity);
        _detachOneGrain(rings);
      }
    }
    _drainChannel();
    _stepFallingGrains(h);
    _stabilizePile(h);
    _updateUpperRemaining(rings);
  }

  /// 【D27: 唯一の例外】共有オービットから直接モートを1つ引き抜く。
  /// 最も古いモート(角度リストの先頭)から移送する — どの輪からでもよいが、
  /// 内側の輪から優先的に空になっていく方が「中心から尽きていく」自然な
  /// 見た目になるため内側から走査する。
  void _detachOneGrain(List<OrbitRing> rings) {
    for (final ring in rings) {
      if (ring.moteAngles.isNotEmpty) {
        final angle = ring.moteAngles.removeAt(0);
        _channel.deposit(TransferGrainSeed(
          originAngle: angle,
          ringRadiusUnit: ring.radiusUnit,
        ));
        return; // 1ステップ1粒(D23の「逐次進行」原則を踏襲)
      }
    }
  }

  /// チャネルに積まれた種を実体化する(オービットフレームの角度→
  /// 容器フレームのx位置へ写像。首=容器上端の中心付近に集める)。
  void _drainChannel() {
    TransferGrainSeed? seed;
    while ((seed = _channel.withdraw()) != null) {
      final x =
          (0.5 + seed!.ringRadiusUnit * math.cos(seed.originAngle) * 0.9)
              .clamp(0.05, 0.95)
              .toDouble();
      state.fallingGrains.add(TransferGrain(x: x, y: -0.05, vy: 0.1));
    }
  }

  void _stepFallingGrains(double h) {
    final n = state.pileHeights.length;
    final surfaceY = 1.0 - _averagePileHeight();
    for (var i = state.fallingGrains.length - 1; i >= 0; i--) {
      final g = state.fallingGrains[i];
      g.vy += _tuning.gravity * h;
      g.y += g.vy * h;
      if (g.y >= surfaceY) {
        final col = (g.x.clamp(0.0, 1.0) * (n - 1)).round();
        state.pileHeights[col] += _tuning.grainDepositHeight;
        state.fallingGrains.removeAt(i);
      }
    }
  }

  /// 隣接列より高すぎる列から低い列へ高さを分配する単純な1次元オートマトン
  /// (安息角を模す — 厳密な物理でなく見た目優先)。
  void _stabilizePile(double h) {
    final heights = state.pileHeights;
    final n = heights.length;
    final relax = (_tuning.springK * h).clamp(0.0, 0.5).toDouble();
    for (var i = 0; i < n - 1; i++) {
      final diff = heights[i] - heights[i + 1];
      if (diff.abs() > _tuning.angleOfReposeSlope) {
        final excess = diff.abs() - _tuning.angleOfReposeSlope;
        final move = excess * relax * diff.sign;
        heights[i] -= move / 2;
        heights[i + 1] += move / 2;
      }
    }
  }

  double _averagePileHeight() {
    var sum = 0.0;
    for (final v in state.pileHeights) {
      sum += v;
    }
    return sum / state.pileHeights.length;
  }

  void _updateUpperRemaining(List<OrbitRing> rings) {
    var total = 0;
    var current = 0;
    for (final ring in rings) {
      total += ring.moteTarget;
      current += ring.moteAngles.length;
    }
    state.upperRemaining = total == 0 ? 0 : current / total;
  }

  @override
  void reset() {
    for (var i = 0; i < state.pileHeights.length; i++) {
      state.pileHeights[i] = 0;
    }
    state.fallingGrains.clear();
    state.upperRemaining = 1.0;
    _releaseTimer = 0;
    _channel.clear();
  }
}
