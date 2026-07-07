import 'package:focus_orbit/core/domain/ids.dart';
import 'package:focus_orbit/features/motif/domain/motif_skin.dart';
import 'package:focus_orbit/features/motif/domain/motifs/bonsai_motif.dart';
import 'package:focus_orbit/features/motif/domain/motifs/hourglass_motif.dart';
import 'package:focus_orbit/features/motif/domain/motifs/water_motif.dart';

/// 唯一の登録点。新モチーフ = 具象1ファイル追加 + この配列に1行(T5基準)。
/// 消費側コードの変更はゼロ。
class MotifCatalog {
  const MotifCatalog._();

  static const List<MotifSkin> all = [
    WaterMotif(),
    HourglassMotif(),
    BonsaiMotif(),
  ];

  static MotifSkin? byId(MotifId id) {
    assert(all.map((m) => m.id).toSet().length == all.length, 'MotifId重複');
    for (final m in all) {
      if (m.id == id) return m;
    }
    return null; // 未知ID(永続化データとアプリ版の不整合): 呼び出し側でフォールバック(D11)
  }
}
