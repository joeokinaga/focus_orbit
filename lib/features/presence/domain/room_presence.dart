import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:focus_orbit/core/domain/ids.dart';

part 'room_presence.freezed.dart';

/// 部屋の滞在人数・アクティブ数のスナップショット(要件4)。個人情報は含まない。
@freezed
abstract class RoomPresence with _$RoomPresence {
  @Assert('occupantCount >= 0 && activeCount >= 0 && activeCount <= occupantCount')
  const factory RoomPresence({
    required RoomId roomId,
    required int occupantCount,
    required int activeCount,
    /// T8エッジ#6: TTL結果整合下での鮮度提示に使う
    required DateTime asOf,
  }) = _RoomPresence;
}
