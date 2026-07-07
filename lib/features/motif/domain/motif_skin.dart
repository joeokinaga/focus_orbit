import 'package:focus_orbit/core/domain/ids.dart';
import 'package:focus_orbit/features/motif/domain/bgm_preset.dart';
import 'package:focus_orbit/features/motif/domain/render_params.dart';

/// モチーフの抽象。sealedにしない=拡張に開く(OCP)。
/// 消費側(shop/描画/BGM)はこの抽象とMotifCatalogのみに依存し、
/// 具象型へのswitch分岐を書いてはならない(T5)。
abstract class MotifSkin {
  const MotifSkin();

  MotifId get id;

  /// 0 = 初期解放(D10)
  int get priceCoins;

  RenderParams get renderParams;
  BgmPreset get bgmPreset;
}
