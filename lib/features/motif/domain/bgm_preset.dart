import 'package:freezed_annotation/freezed_annotation.dart';

part 'bgm_preset.freezed.dart';

/// BGM設定。trackIdはアセットキー。再生実装はPhase 1(T1 RISKS)。
@freezed
abstract class BgmPreset with _$BgmPreset {
  @Assert('volume >= 0 && volume <= 1')
  const factory BgmPreset({
    required String trackId,
    required double volume,
    required Duration fadeIn,
    required bool loops,
  }) = _BgmPreset;
}
