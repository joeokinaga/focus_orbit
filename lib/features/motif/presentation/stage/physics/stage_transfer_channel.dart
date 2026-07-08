import 'dart:collection';

/// P4-V3: 上ステージ(共有オービット)から引き抜かれたモート1個の「種」。
/// 引き抜いた瞬間の角度と輪半径だけを運ぶ — 落下後の振る舞い(重力・着地・
/// 堆積)は完全に受け取り側(AccumulationBehavior)の責務。
class TransferGrainSeed {
  const TransferGrainSeed({
    required this.originAngle,
    required this.ringRadiusUnit,
  });

  final double originAngle;
  final double ringRadiusUnit;
}

/// 上ステージ→下ステージの一方向メールボックス。
///
/// 【検討依頼2への回答】専用の「ステージ間接続」サブシステムは作らない。
/// 共有オービット(StageSimulation host が持つ List<OrbitRing>)は
/// Rule2の生成ロジックのまま一切変更しない。Hourglass の
/// AccumulationBehavior だけが rings から直接1モートを引き抜き
/// (accumulation_behavior.dart の D27 参照)、この極小のFIFOキューへ
/// 積む。「移送」というドメイン知識はこのキュー1つとHourglass側の
/// 実装だけに閉じ込められ、host 本体も他モチーフも一切関知しない。
///
/// 汎用のQueueを薄くラップしただけであり、それ自体は「何が積まれるか」
/// にすら関心を持たない(TransferGrainSeed という値を右から左へ流すだけ)。
class StageTransferChannel {
  final Queue<TransferGrainSeed> _pending = Queue<TransferGrainSeed>();

  void deposit(TransferGrainSeed seed) => _pending.add(seed);

  /// 先入れ先出しで1件取り出す。空ならnull。
  TransferGrainSeed? withdraw() =>
      _pending.isEmpty ? null : _pending.removeFirst();

  bool get isEmpty => _pending.isEmpty;

  void clear() => _pending.clear();
}
