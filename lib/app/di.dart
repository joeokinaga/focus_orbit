// T13確定: Riverpod 3系で `Override` 型は flutter_riverpod.dart 本体から
// misc.dart ライブラリへ移動した(@publicInMisc)。ここが di.dart で必要な
// 唯一の riverpod シンボルのため、misc.dart から show で最小 import する。
// (overrideWithValue メソッド自体は各 provider の型経由で解決されるので
//  本体ライブラリの import は不要 — 以前の unused_import 警告の正体)
import 'package:flutter_riverpod/misc.dart' show Override;

import 'package:focus_orbit/features/economy/application/economy_providers.dart';
import 'package:focus_orbit/features/economy/domain/local_preferences_repository.dart';
import 'package:focus_orbit/features/presence/application/presence_providers.dart';
import 'package:focus_orbit/features/presence/domain/remote_room_repository.dart';
import 'package:focus_orbit/features/stance/application/stance_providers.dart';
import 'package:focus_orbit/features/stance/domain/sensor_gateway.dart';

/// Composition Root(T2): 全レイヤーの実装を知ってよい唯一の場所。
/// Phase 1: SensorsPlusGateway / DriftPreferencesRepository /
/// AppSyncRoomRepository をここで束縛する。
/// ソロ動作は SoloRoomRepository(presence/data, 実装済み)を渡せば今すぐ結線可能。
List<Override> buildOverrides({
  required SensorGateway sensorGateway,
  required LocalPreferencesRepository preferences,
  required RemoteRoomRepository roomRepository,
}) =>
    [
      sensorGatewayProvider.overrideWithValue(sensorGateway),
      localPreferencesRepositoryProvider.overrideWithValue(preferences),
      remoteRoomRepositoryProvider.overrideWithValue(roomRepository),
    ];
