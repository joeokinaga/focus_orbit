import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

/// 本番用の接続ファクトリ。economy_database.dart から分離しているのは、
/// テスト(NativeDatabase.memory)が drift_flutter / Flutter バインディングを
/// 一切importせずに EconomyDatabase を構築できるようにするため。
///
/// drift_flutter の driftDatabase() は各プラットフォームの標準
/// アプリデータディレクトリ配下に '<name>.sqlite' を作成し、
/// バックグラウンドisolate実行・WALモードを既定で有効化する。
QueryExecutor openEconomyDatabaseConnection() =>
    driftDatabase(name: 'focus_orbit_economy');
