import 'dart:math' as math;

import 'stage_types.dart';

/// P4-V3: 共通ルール1(蓄積)への入力。
///
/// 【D25継承】StageSimulation host は SessionPhase 等アプリの真実を知らない
/// (P4-V0で確定済み)。この契約も同じ規律を継ぐ — 戦略実装(各モチーフの
/// AccumulationBehavior)へは、翻訳済みの数値だけが渡る。
class AccumulationInputs {
  const AccumulationInputs({
    required this.targetFill,
    required this.intensity,
    required this.pouring,
  });

  /// セッション進捗 0..1(蓄積の目標値)。
  final double targetFill;

  /// 集中度 0..1。
  final double intensity;

  /// running 中 true(蓄積が進む)。
  final bool pouring;
}

/// モチーフ毎の蓄積表現。レンダラ(MotifStageRenderer)が読む契約。
///
/// 【OCP方針】PhysicsTuning / MotifSkin と同じ理由で sealed にしない。
/// レンダラは StageRendererRegistry(D24)で自分の担当モチーフに固定される
/// ため、実行時に他モチーフの State を見ることはない — 具象型への
/// ダウンキャストは「登録簿の配線ミスがあれば即死する契約」として許容する
/// (renderer 側の doc comment に明記する。§qa: レビュー観点に追加)。
abstract class AccumulationState {
  const AccumulationState();
}

/// 共通ルール1(蓄積)の戦略契約。モチーフごとに1つの具象実装を持つ
/// (D24と同型 — MotifPhysicsCatalog が唯一の登録点。消費側の具象switch禁止)。
///
/// 【共通ルール2/3との関係】オービット(rings)・崩壊(freedMotes)の
/// 生成ロジック自体は StageSimulation host に残ったまま、全モチーフで
/// 共有される(D23)。蓄積だけがモチーフごとに構造すら異なりうる
/// (水=流体面、盆栽=成長グラフ、砂時計=二段構成、焚き火=燃焼、
/// 天球儀=構造組み上げ)ため、ここだけを Strategy として切り出す。
///
/// 【D27: 唯一の例外】[rings] は共有オービットへの読み書き参照として
/// 全実装に渡されるが、通常は無視してよい(読みも書きもしない)。
/// Hourglass の実装だけが、ここから直接モートを引き抜いて下段への
/// 移送元とする(hourglass_accumulation.dart 参照)。この例外を許すことで、
/// 専用の「ステージ間接続」サブシステムを新設せずに済む —
/// 「移送」というドメイン知識は完全に Hourglass 側にカプセル化され、
/// 共有オービットの生成ロジックそのものは一切変更しない。
abstract class AccumulationBehavior {
  AccumulationState get state;

  /// 1物理ステップ(1/60s固定・host が呼ぶ)を進める。
  void step({
    required double h,
    required AccumulationInputs inputs,
    required List<OrbitRing> rings,
    required math.Random rng,
  });

  /// 新セッション開始時にホストから呼ばれる(P4-V2の reset() と同じ契機)。
  void reset();
}
