import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:focus_orbit/core/domain/ids.dart';
import 'package:focus_orbit/features/motif/domain/motifs/water_motif.dart';

part 'user_settings.freezed.dart';

/// D13: stance featureへのdomain間importを避けるためcore/motif型のみで構成。
/// 閾値キャリブレーションの永続化はキャリブレーションフロー設計時(Phase 1)に追加。
@freezed
abstract class UserSettings with _$UserSettings {
  const factory UserSettings({
    required MotifId selectedMotifId,
    required Duration defaultSessionDuration,
    required bool bgmEnabled,
  }) = _UserSettings;

  factory UserSettings.defaults() => UserSettings(
        selectedMotifId: const WaterMotif().id, // D10と整合
        defaultSessionDuration: const Duration(minutes: 25),
        bgmEnabled: true,
      );
}
