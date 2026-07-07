import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:focus_orbit/core/domain/ids.dart';

part 'unlock_state.freezed.dart';

@freezed
abstract class UnlockState with _$UnlockState {
  const UnlockState._();

  const factory UnlockState({required Set<MotifId> unlockedIds}) =
      _UnlockState;

  bool isUnlocked(MotifId id) => unlockedIds.contains(id);

  /// べき等: 解放済みなら自分自身(同一インスタンス)を返す(T6)
  UnlockState unlock(MotifId id) =>
      isUnlocked(id) ? this : copyWith(unlockedIds: {...unlockedIds, id});
}
