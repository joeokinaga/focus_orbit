import 'dart:ui' show Offset;

/// P4-V3: 共通ルール2(オービット)・3(崩壊)のデータ型。
///
/// 【非依存の理由】StageSimulation(host)と各モチーフの AccumulationBehavior
/// (physics/*_accumulation.dart)の双方から参照される。host→behavior、
/// behavior→hostの循環importを避けるため、依存の無いこのファイルへ
/// 抽出した(P4-V1の stage_simulation.dart から中身は無変更で移設)。
///
/// 【D23継承】オービット・崩壊のロジック自体は全モチーフ共有のまま
/// (StageSimulation host 側に残る)。ここにあるのは「データ」だけで、
/// 「振る舞い」は一切持たない。

/// 光の輪1本。moteAngles の各要素が輪上の光点。
///
/// 【D27(P4-V3)】通常は host の _stepOrbit だけが書き込む。唯一の例外として
/// Hourglass の AccumulationBehavior だけが moteAngles から直接1個を
/// 引き抜く(上ステージ→下ステージの物理的連結。理由は
/// hourglass_accumulation.dart の doc comment を参照)。
class OrbitRing {
  OrbitRing({
    required this.threshold,
    required this.radiusUnit,
    required this.moteTarget,
    required this.speedSign,
  });

  /// この輪が現れる集中度のしきい値
  final double threshold;

  /// 半径(オービットフレーム・1.0=画面短辺)
  final double radiusUnit;

  /// 満員時のモート数
  final int moteTarget;

  /// 回転方向(+1 / -1)
  final int speedSign;

  final List<double> moteAngles = [];
  double respawnTimer = 0;
}

/// 崩壊で解放されたモート(オービットフレーム・中心原点)。
class FreedMote {
  FreedMote(
      {required this.position, required this.velocity, required this.life});
  Offset position;
  Offset velocity;
  double life;
}
