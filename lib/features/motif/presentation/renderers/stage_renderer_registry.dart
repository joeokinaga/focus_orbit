import 'package:focus_orbit/core/domain/ids.dart';
import 'package:focus_orbit/features/motif/presentation/renderers/motif_stage_renderer.dart';
import 'package:focus_orbit/features/motif/presentation/renderers/water_stage_renderer.dart';

/// MotifId → レンダラの唯一の登録点(MotifCatalog と同じパターン)。
///
/// 【T5/OCP】消費側は本登録簿だけを見る。新モチーフの描画追加 =
/// レンダラ具象1ファイル + ここに1行。具象型への switch は書かない。
///
/// 【D11 フォールバック】未登録IDは水へフォールバックする
/// (永続化データとアプリ版の不整合、および P4-V1 時点の未実装モチーフを吸収)。
class StageRendererRegistry {
  const StageRendererRegistry._();

  static const MotifStageRenderer _fallback = WaterStageRenderer();

  static const Map<MotifId, MotifStageRenderer> _byId = {
    MotifId('water'): WaterStageRenderer(),
    // P4-V4 で追加予定: magma / cauldron / gridcube、および
    // hourglass / bonsai の専用レンダラ(それまでは水フォールバック)
  };

  static MotifStageRenderer byId(MotifId id) => _byId[id] ?? _fallback;
}
