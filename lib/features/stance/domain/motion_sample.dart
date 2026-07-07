import 'package:freezed_annotation/freezed_annotation.dart';

part 'motion_sample.freezed.dart';

/// フレームワーク非依存の正規化済みセンサー1サンプル(用語集v1.1)。
/// gravity*: 重力込み加速度[m/s^2](上向き静置時 gravityZ ≈ +9.8)
/// user*   : 重力除去加速度[m/s^2](静止時 ≈ 0)
@freezed
abstract class MotionSample with _$MotionSample {
  const factory MotionSample({
    required double gravityX,
    required double gravityY,
    required double gravityZ,
    required double userX,
    required double userY,
    required double userZ,
    required DateTime timestamp,
  }) = _MotionSample;
}
