import 'package:focus_orbit/core/domain/ids.dart';
import 'package:focus_orbit/features/motif/domain/bgm_preset.dart';
import 'package:focus_orbit/features/motif/domain/motif_skin.dart';
import 'package:focus_orbit/features/motif/domain/render_params.dart';

final class WaterMotif extends MotifSkin {
  const WaterMotif();

  @override
  MotifId get id => const MotifId('water');

  @override
  int get priceCoins => 0; // 初期解放(D10)

  @override
  RenderParams get renderParams => const RenderParams(
      primaryColorArgb: 0xFF2E86C1,
      secondaryColorArgb: 0xFFAED6F1,
      particleDensity: 0.6,
      flowSpeed: 1.0,
      ambientGlow: 0.4);

  @override
  BgmPreset get bgmPreset => const BgmPreset(
      trackId: 'bgm_water_loop',
      volume: 0.7,
      fadeIn: Duration(seconds: 3),
      loops: true);
}
