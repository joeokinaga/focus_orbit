import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:focus_orbit/core/domain/ids.dart';
import 'package:focus_orbit/features/motif/domain/motifs/water_motif.dart';

final selectedMotifProvider =
    NotifierProvider<SelectedMotifController, MotifId>(
        SelectedMotifController.new);

/// 装備中モチーフ(UI横断の選択状態)。
/// 既定は初期解放の「水」(D10 / UserSettings.defaults() と同値)。
///
/// 【Phase 1 残作業】LocalPreferencesRepository.loadSettings/saveSettings と
/// 結線して UserSettings.selectedMotifId へ永続化する。本クラスは
/// その読み書きの前面に立つ想定で、公開APIは変えない。
class SelectedMotifController extends Notifier<MotifId> {
  @override
  MotifId build() => const WaterMotif().id;

  /// 解放済みかの検証は呼び出し側(ShopView)が UnlockState で行い、
  /// ここは値の保持のみを担う(台帳=真実の原則を侵さない)。
  void select(MotifId id) => state = id;
}
