import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// LANDMINE ⑨: Override型はmisc.dartが正。
import 'package:flutter_riverpod/misc.dart' show Override;

import 'package:focus_orbit/app/di.dart';
import 'package:focus_orbit/app/presentation/focus_orbit_app.dart';
import 'package:focus_orbit/features/economy/data/drift/drift_preferences_repository.dart';
import 'package:focus_orbit/features/economy/data/drift/economy_database.dart';
import 'package:focus_orbit/features/economy/data/drift/economy_database_connection.dart';
import 'package:focus_orbit/features/presence/data/solo_room_repository.dart';
import 'package:focus_orbit/features/stance/data/sensors_plus_gateway.dart';

/// Composition Root 実行部(ARCHITECTURE.md §13 の起動シーケンスが正)。
/// 実装型(Drift* / SensorsPlus* / Solo*)へのコード参照が許される
/// 本番コードは本ファイルのみ(疎結合ゲート)。
///
/// 【寿命について(§13 所有権規則)】ここで生成する4オブジェクトは
/// アプリ寿命であり、意図的に dispose しない。プロセス終了時の
/// クローズは OS 委譲で足りる — drift はバックグラウンド isolate +
/// WAL で kill 安全、台帳のべき等性(§5/§7)が二重付与・消失を防ぐ。
/// LANDMINE ④: economyStateProvider は keepAlive 前提のため、
/// ここを autoDispose 構成に変えてはならない。
/// [extraOverrides] はデバッグ/E2E用エントリポイント(main_e2e.dart等)が
/// ポリシー系providerを差し替えるための注入口。本番main.dartは常に空。
Future<void> bootstrap({List<Override> extraOverrides = const []}) async {
  // §13 手順1: プラットフォームチャネル(drift_flutter のパス解決・
  // sensors_plus)使用前にバインディングを確立する。
  WidgetsFlutterBinding.ensureInitialized();

  // §13 手順2-3: DB open(遅延・バックグラウンド isolate 接続)→
  // リポジトリ構築。openEconomyDatabaseConnection() はファイル
  // 'focus_orbit_economy.sqlite' を標準アプリデータ配下に作成する。
  final database = EconomyDatabase(openEconomyDatabaseConnection());
  final preferences = DriftPreferencesRepository(database);

  // §13 手順4: センサー実装(重力込み/除去の2系統合成は data 層内部)。
  final sensorGateway = SensorsPlusGateway();

  // §13 手順5: Phase 4 で AppSync 実装に差し替わる唯一の行。
  final roomRepository = SoloRoomRepository();

  // §13 手順6: 束縛は app/di.dart の buildOverrides に一本化。
  // provider 側のスタブ(UnimplementedError)は束縛漏れ検出器として
  // 生きているため、ここで3つ全てを渡し損ねると起動時に即死する(仕様)。
  runApp(
    ProviderScope(
      overrides: [
        ...buildOverrides(
          sensorGateway: sensorGateway,
          preferences: preferences,
          roomRepository: roomRepository,
        ),
        ...extraOverrides,
      ],
      child: const FocusOrbitApp(),
    ),
  );
}
