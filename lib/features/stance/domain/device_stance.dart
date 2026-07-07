import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_stance.freezed.dart';

/// 端末の物理状態。T0-A1の定義が正。
@freezed
sealed class DeviceStance with _$DeviceStance {
  /// 上向き・完全静止(集中継続の条件)
  const factory DeviceStance.faceUpStill() = FaceUpStill;

  /// 微小振動を検知(warning遷移のトリガ、D1)
  const factory DeviceStance.microVibration({required double rms}) =
      MicroVibration;

  /// 持ち上げ・大きな動き・傾き=離脱
  const factory DeviceStance.lifted() = Lifted;
}
