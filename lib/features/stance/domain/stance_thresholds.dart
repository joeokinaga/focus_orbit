import 'package:freezed_annotation/freezed_annotation.dart';

part 'stance_thresholds.freezed.dart';

/// 判定閾値のValue Object。不変条件は@Assertで構築境界に固定。
/// 既定値は実機キャリブレーション必須(T3 RISKS)。注入点はstanceThresholdsProvider。
@freezed
abstract class StanceThresholds with _$StanceThresholds {
  @Assert('stillRmsMax < vibrationRmsMax', 'still上限はvibration上限より小さいこと')
  @Assert('faceUpGravityZMin > 0')
  const factory StanceThresholds({
    /// これ以上のz軸重力成分で「上向き」(例: 8.5)
    required double faceUpGravityZMin,
    /// 移動窓RMSがこれ以下で「完全静止」(例: 0.06)
    required double stillRmsMax,
    /// RMSがこれ以下なら「微小振動」、超えたらlifted扱い(例: 0.9)
    required double vibrationRmsMax,
    /// RMS計算の移動窓幅(例: 400ms)
    required Duration rmsWindow,
    /// 状態確定に必要な持続時間=チャタリング防止(例: 250ms)
    required Duration commitDebounce,
  }) = _StanceThresholds;

  factory StanceThresholds.defaults() => const StanceThresholds(
        faceUpGravityZMin: 8.5,
        stillRmsMax: 0.06,
        vibrationRmsMax: 0.9,
        rmsWindow: Duration(milliseconds: 400),
        commitDebounce: Duration(milliseconds: 250),
      );
}
