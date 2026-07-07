import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:focus_orbit/core/domain/ids.dart';
import 'package:focus_orbit/features/presence/domain/presence_connection_state.dart';
import 'package:focus_orbit/features/presence/domain/remote_room_repository.dart';
import 'package:focus_orbit/features/presence/domain/room_presence.dart';

/// 実装(AppSync / Solo)はapp/di.dartで束縛する。
final remoteRoomRepositoryProvider = Provider<RemoteRoomRepository>(
  (_) => throw UnimplementedError('app/di.dart の buildOverrides で束縛してください'),
);

/// 接続状態(connected / reconnecting / soloFallback / disconnected)。
/// AsyncValueのloading/errorに加え、契約(3)によりエラーはデータとして流れる。
final presenceConnectionProvider =
    StreamProvider.autoDispose<PresenceConnectionState>(
  (ref) => ref.watch(remoteRoomRepositoryProvider).connectionState(),
);

/// D19: roomIdはUI側が現在セッションのmotifIdから導出して渡す
/// (session application層へのimportを避け、循環依存を構造的に排除)。
final roomPresenceProvider =
    StreamProvider.autoDispose.family<RoomPresence, RoomId>(
  (ref, roomId) => ref.watch(remoteRoomRepositoryProvider).watch(roomId),
);
