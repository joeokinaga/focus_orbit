import 'package:freezed_annotation/freezed_annotation.dart';

part 'render_params.freezed.dart';

/// D5準拠: Flutter Color非依存。色はARGB intで表現しUI層で変換する。
/// 各値はPhase 1の描画実装で再調整前提(T5 RISKS)。
@freezed
abstract class RenderParams with _$RenderParams {
  @Assert('particleDensity >= 0 && particleDensity <= 1')
  @Assert('flowSpeed > 0')
  @Assert('ambientGlow >= 0 && ambientGlow <= 1')
  const factory RenderParams({
    required int primaryColorArgb,
    required int secondaryColorArgb,
    required double particleDensity,
    required double flowSpeed,
    required double ambientGlow,
  }) = _RenderParams;
}
