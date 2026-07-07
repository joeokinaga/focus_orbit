import 'package:focus_orbit/core/domain/ids.dart';
import 'package:focus_orbit/features/motif/domain/bgm_preset.dart';
import 'package:focus_orbit/features/motif/domain/motif_skin.dart';
import 'package:focus_orbit/features/motif/domain/render_params.dart';

final class BonsaiMotif extends MotifSkin {
  const BonsaiMotif();

  @override
  MotifId get id => const MotifId('bonsai');

  @override
  int get priceCoins => 200;

  @override
  RenderParams get renderParams => const RenderParams(
      primaryColorArgb: 0xFF1E8449,
      secondaryColorArgb: 0xFFA9DFBF,
      particleDensity: 0.3,
      flowSpeed: 0.35,
      ambientGlow: 0.5);

  @override
  BgmPreset get bgmPreset => const BgmPreset(
      trackId: 'bgm_forest_loop',
      volume: 0.65,
      fadeIn: Duration(seconds: 4),
      loops: true);
}
