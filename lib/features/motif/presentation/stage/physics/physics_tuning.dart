/// P4-V3: モチーフ横断の物理チューニング。
///
/// 【検討依頼1への回答】「粘性」「重力」「バネ定数」の3つを全モチーフ共通の
/// 汎用パラメータとして基底クラスに持たせ、各モチーフの具象クラスが
/// 意味を再解釈する(水=波の減衰/落下/水面張力、盆栽=揺れの減衰/垂れ下がり/
/// 枝の硬さ、砂時計=摩擦/落下/安息角維持力、焚き火=揺らめきの減衰/浮力との
/// 拮抗/薪の沈み込み抵抗、天球儀=回転減衰/中心への収束/組み上がり剛性)。
/// 具象クラスは自分だけの追加パラメータを自由に持てる(データ構造として管理
/// ・ハードコード回避 = 検討依頼「拡張性のための設計指針」に対応)。
///
/// 共通ルール2(オービット)・3(崩壊)は全モチーフでロジック自体を共有する
/// ため(D23)、その「効き方」の係数もここに共通で持たせる。
///
/// 【OCP方針】motif_skin.dart の MotifSkin と同じ理由で sealed にしない。
/// 新モチーフの追加は具象1クラス + MotifPhysicsCatalog(motif_physics_catalog.dart)
/// への1行で完結させる(D24と同型のレジストリ分岐。具象型への switch は
/// 書かない = T5)。
abstract class PhysicsTuning {
  const PhysicsTuning({
    required this.viscosity,
    required this.gravity,
    required this.springK,
    this.orbitBaseRevPerSec = 0.10,
    this.orbitIntensityGain = 2.4,
    this.moteRespawnInterval = 0.35,
    this.shatterImpulseScale = 0.45,
    this.freedGravity = 0.5,
    this.freedDrag = 0.6,
  });

  /// 粘性(汎用の減衰係数)。
  final double viscosity;

  /// 重力(汎用の下方加速度)。
  final double gravity;

  /// バネ定数(汎用の復元力)。
  final double springK;

  // ---- 共通ルール2(オービット)・3(崩壊) — 全モチーフ共有ロジックの係数 ----
  final double orbitBaseRevPerSec;
  final double orbitIntensityGain;
  final double moteRespawnInterval;
  final double shatterImpulseScale;
  final double freedGravity;
  final double freedDrag;
}

/// 水(フラスコ)。P4-V1 の StagePhysicsTuning 実測値をそのまま踏襲。
/// viscosity→旧surfaceDamping / gravity→旧dropletGravity / springK→旧surfaceSpringK。
final class WaterTuning extends PhysicsTuning {
  const WaterTuning({
    super.viscosity = 3.0,
    super.gravity = 1.6,
    super.springK = 30,
    super.orbitBaseRevPerSec,
    super.orbitIntensityGain,
    super.moteRespawnInterval,
    super.shatterImpulseScale,
    super.freedGravity,
    super.freedDrag,
    this.surfaceSpread = 30,
    this.fillEaseRate = 0.6,
    this.dropletBaseInterval = 1.1,
    this.splashKick = 0.28,
    this.buoyancy = 0.10,
    this.bubblePopKick = 0.05,
  });

  final double surfaceSpread; // 隣接列への伝播(波の速さ)
  final double fillEaseRate; // 進捗への追従率(/s)
  final double dropletBaseInterval; // 滴の基本生成間隔(s)
  final double splashKick; // 着水の突き下げ係数
  final double buoyancy; // 泡の上昇速度基準
  final double bubblePopKick; // 泡が弾ける突き上げ
}

/// 盆栽(成長・植物)。P4-V4で実装予定 — 初期値は暫定(実機調整前提)。
final class BonsaiTuning extends PhysicsTuning {
  const BonsaiTuning({
    super.viscosity = 4.0, // 水より早く揺れが収まる(重厚な質感)
    super.gravity = 0.5, // 葉が緩やかに垂れる程度
    super.springK = 18, // 枝の硬さ(水面より硬く波立たない)
    super.orbitBaseRevPerSec,
    super.orbitIntensityGain,
    super.moteRespawnInterval,
    super.shatterImpulseScale,
    super.freedGravity,
    super.freedDrag,
    this.growthEaseRate = 0.35, // 進捗→成長度の追従率(水のfillEaseRate相当)
    this.windSwayAmplitude = 0.04, // 常時ゆらぎの振幅
    this.leafSpawnInterval = 2.4, // 新葉が生える基本間隔(集中で短縮)
  });

  final double growthEaseRate;
  final double windSwayAmplitude;
  final double leafSpawnInterval;
}

/// 砂時計(移送・重力)。検討依頼2の中心。initial値は暫定。
final class HourglassTuning extends PhysicsTuning {
  const HourglassTuning({
    super.viscosity = 8.0, // 砂は水よりずっと早く落ち着く(波打たない)
    super.gravity = 2.0, // 砂粒の落下は水滴よりやや速い
    super.springK = 40, // 砂山が安息角を保とうとする力
    super.orbitBaseRevPerSec,
    super.orbitIntensityGain,
    super.moteRespawnInterval,
    super.shatterImpulseScale,
    super.freedGravity,
    super.freedDrag,
    this.grainReleaseInterval = 0.9, // 上ステージから1粒引き抜く基本間隔(s)
    this.grainDepositHeight = 0.006, // 1粒が積もる高さ量子
    this.angleOfReposeSlope = 0.03, // これを超える隣接列高低差は崩れる
  });

  final double grainReleaseInterval;
  final double grainDepositHeight;
  final double angleOfReposeSlope;
}

/// 焚き火(燃焼・火の粉)。P4-V4で実装予定 — 初期値は暫定。
final class BonfireTuning extends PhysicsTuning {
  const BonfireTuning({
    super.viscosity = 2.0, // 炎の揺らめきは水よりダンピングが弱い
    super.gravity = -0.8, // 負=火の粉は上昇気流で「昇る」
    super.springK = 22, // 薪の沈み込み抵抗
    super.orbitBaseRevPerSec,
    super.orbitIntensityGain,
    super.moteRespawnInterval,
    super.shatterImpulseScale,
    super.freedGravity,
    super.freedDrag,
    this.emberLifetime = 1.4, // 火の粉1個の寿命(s)
    this.flickerFrequency = 5.0, // 炎のちらつき周波数
    this.logStackEaseRate = 0.5, // 進捗→薪の積み上がり追従率
  });

  final double emberLifetime;
  final double flickerFrequency;
  final double logStackEaseRate;
}

/// 天球儀(オービット・構造)。P4-V4で実装予定 — 初期値は暫定。
final class CelestialTuning extends PhysicsTuning {
  const CelestialTuning({
    super.viscosity = 1.5, // 環の回転はほぼ減衰しない(慣性で回り続ける)
    super.gravity = 0.0, // 天球儀に「落下」はない
    super.springK = 60, // 環がカチッと組み上がる剛性
    super.orbitBaseRevPerSec,
    super.orbitIntensityGain,
    super.moteRespawnInterval,
    super.shatterImpulseScale,
    super.freedGravity,
    super.freedDrag,
    this.ringAssemblyEaseRate = 0.4, // 進捗→組み上がり度の追従率
    this.precessionSpeed = 0.05, // 環同士の歳差運動速度
  });

  final double ringAssemblyEaseRate;
  final double precessionSpeed;
}
