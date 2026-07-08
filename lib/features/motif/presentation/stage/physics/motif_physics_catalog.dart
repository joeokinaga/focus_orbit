import 'package:focus_orbit/core/domain/ids.dart';

import 'physics_tuning.dart';

/// MotifId → PhysicsTuning の唯一の登録点(MotifCatalog / StageRendererRegistry
/// と同じパターン)。新モチーフの物理特性追加 = physics_tuning.dart に
/// 具象クラス1件 + ここに1行(T5基準)。消費側コードの変更はゼロ。
///
/// 【D11フォールバック】未登録IDは水へフォールバックする
/// (永続化データとアプリ版の不整合、および未実装モチーフの吸収)。
class MotifPhysicsCatalog {
  const MotifPhysicsCatalog._();

  static const PhysicsTuning _fallback = WaterTuning();

  static const Map<MotifId, PhysicsTuning> _byId = {
    MotifId('water'): WaterTuning(),
    MotifId('bonsai'): BonsaiTuning(),
    MotifId('hourglass'): HourglassTuning(),
    MotifId('bonfire'): BonfireTuning(),
    MotifId('celestial'): CelestialTuning(),
  };

  static PhysicsTuning byId(MotifId id) => _byId[id] ?? _fallback;
}
