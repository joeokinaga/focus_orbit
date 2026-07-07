import 'package:focus_orbit/core/domain/ids.dart';
import 'package:focus_orbit/features/motif/domain/bgm_preset.dart';
import 'package:focus_orbit/features/motif/domain/motif_skin.dart';
import 'package:focus_orbit/features/motif/domain/render_params.dart';

final class HourglassMotif extends MotifSkin {
  const HourglassMotif();

  @override
  MotifId get id => const MotifId('hourglass');

  @override
  int get priceCoins => 120;

  @override
  RenderParams get renderParams => const RenderParams(
      primaryColorArgb: 0xFFB9770E,
      secondaryColorArgb: 0xFFF8C471,
      particleDensity: 0.9,
      flowSpeed: 0.6,
      ambientGlow: 0.25);

  @override
  BgmPreset get bgmPreset => const BgmPreset(
      trackId: 'bgm_sand_loop',
      volume: 0.6,
      fadeIn: Duration(seconds: 2),
      loops: true);
}
