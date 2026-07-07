import 'dart:async';

import 'package:focus_orbit/core/domain/ids.dart';
import 'package:focus_orbit/core/domain/result.dart';
import 'package:focus_orbit/features/presence/domain/presence_connection_state.dart';
import 'package:focus_orbit/features/presence/domain/remote_room_repository.dart';
import 'package:focus_orbit/features/presence/domain/room_presence.dart';

/// ソロ時のスタンドアロン動作(要件4)= Null実装。
/// アプリと同寿命のシングルトンとして束縛する(dispose()は主にテスト用)。
final class SoloRoomRepository implements RemoteRoomRepository {
  final _changes = StreamController<RoomPresence>.broadcast();
  RoomId? _roomId;
  bool _active = false;

  RoomPresence _current(RoomId id) => RoomPresence(
        roomId: id,
        occupantCount: 1,
        activeCount: _active ? 1 : 0,
        asOf: DateTime.now().toUtc(),
      );

  @override
  Future<Result<void, PresenceFailure>> join(RoomId roomId) async {
    _roomId = roomId;
    return const Success(null);
  }

  @override
  Future<void> leave() async => _roomId = null;

  @override
  Stream<RoomPresence> watch(RoomId roomId) async* {
    yield _current(roomId); // 契約(1): listen直後にスナップショット
    yield* _changes.stream.where((p) => p.roomId == roomId);
  }

  @override
  Stream<PresenceConnectionState> connectionState() =>
      Stream.value(const PresenceConnectionState.soloFallback());

  @override
  Future<void> reportActive(bool isActive) async {
    _active = isActive;
    final id = _roomId;
    if (id != null) _changes.add(_current(id)); // join前はno-op(契約)
  }

  @override
  Future<void> dispose() async => _changes.close(); // 生成/破棄ペア
}
