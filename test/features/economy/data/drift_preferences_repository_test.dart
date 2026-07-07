import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:focus_orbit/core/domain/ids.dart';
import 'package:focus_orbit/core/domain/result.dart';
import 'package:focus_orbit/features/economy/data/drift/drift_preferences_repository.dart';
import 'package:focus_orbit/features/economy/data/drift/economy_database.dart';
import 'package:focus_orbit/features/economy/domain/coin_transaction.dart';
import 'package:focus_orbit/features/economy/domain/economy_ledger.dart';
import 'package:focus_orbit/features/economy/domain/local_preferences_repository.dart';
import 'package:focus_orbit/features/economy/domain/user_settings.dart';
import 'package:focus_orbit/features/motif/domain/motifs/hourglass_motif.dart';
import 'package:focus_orbit/features/motif/domain/motifs/water_motif.dart';

/// P2-T1: DriftPreferencesRepository の契約テスト(§7)。
///
/// 検証対象は二層:
/// (A) LocalPreferencesRepository 契約 — 初回起動 / apply原子性 /
///     べき等 / 射影(D14) / watch / settings往復。
/// (B) 第3層防御(T7) — リポジトリを迂回した生SQLに対して
///     UNIQUE / CHECK 制約がDB層で書込みを拒否すること。
///
/// 全テストはインメモリSQLite(NativeDatabase.memory)で決定的に実行される。
/// 実行環境要件: ホストにSQLite3ネイティブライブラリ(flutter test既定で可)。
void main() {
  final t0 = DateTime.utc(2026, 7, 7, 12);

  late EconomyDatabase db;
  late DriftPreferencesRepository repo;

  setUp(() {
    db = EconomyDatabase(NativeDatabase.memory());
    repo = DriftPreferencesRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  CoinTransaction earn(String key, int amount) =>
      CoinTransaction.earn(idempotencyKey: key, amount: amount, occurredAt: t0);

  Future<EconomyState> mustLoad() async {
    final r = await repo.loadEconomyState();
    expect(r, isA<Success<EconomyState, StorageFailure>>());
    return (r as Success<EconomyState, StorageFailure>).value;
  }

  Future<LedgerResult> mustApply(CoinTransaction tx) async {
    final r = await repo.apply(tx);
    expect(r, isA<Success<LedgerResult, StorageFailure>>(),
        reason: '$tx の永続適用はStorage層では成功すべき');
    return (r as Success<LedgerResult, StorageFailure>).value;
  }

  Future<int> ledgerRowCount() async {
    final row = await db
        .customSelect('SELECT COUNT(*) AS c FROM coin_transactions')
        .getSingle();
    return row.read<int>('c');
  }

  group('初回起動(空DB)', () {
    test('loadEconomyStateはinitial()を返す(失敗ではない)', () async {
      final s = await mustLoad();
      expect(s.wallet.balance, 0);
      expect(s.unlocks.isUnlocked(const WaterMotif().id), isTrue, reason: 'D10');
      expect(s.appliedKeys, isEmpty);
    });

    test('loadSettingsはdefaults()を返し、行は書き込まない', () async {
      final r = await repo.loadSettings();
      final settings = (r as Success<UserSettings, StorageFailure>).value;
      expect(settings, UserSettings.defaults());
      final count = await db
          .customSelect('SELECT COUNT(*) AS c FROM user_settings')
          .getSingle();
      expect(count.read<int>('c'), 0, reason: '既定値の遅延書込は禁止');
    });
  });

  group('apply: earn(§5シーケンスの永続化境界)', () {
    test('Applied: 残高加算・台帳1行・snapshot同期', () async {
      final result = await mustApply(earn('session:s1', 25));
      expect(result, isA<Applied>());
      expect((result as Applied).state.wallet.balance, 25);
      expect(await ledgerRowCount(), 1);
      final snap = await db
          .customSelect('SELECT balance FROM wallet_snapshot WHERE id = 1')
          .getSingle();
      expect(snap.read<int>('balance'), 25,
          reason: '台帳INSERTと同一トランザクションでsnapshot更新(§7)');
    });

    test('同一キー再適用はAlreadyApplied・行は増えず残高不変', () async {
      await mustApply(earn('session:s1', 25));
      final second = await mustApply(earn('session:s1', 25));
      expect(second, isA<AlreadyApplied>());
      expect((second as AlreadyApplied).state.wallet.balance, 25);
      expect(await ledgerRowCount(), 1, reason: '二重付与なし(T6/T7)');
    });

    test('別キーは加算される(session:{id}規約の直交性)', () async {
      await mustApply(earn('session:s1', 25));
      final r = await mustApply(earn('session:s2', 30));
      expect((r as Applied).state.wallet.balance, 55);
      expect(await ledgerRowCount(), 2);
    });
  });

  group('apply: spendUnlock', () {
    test('残高不足はLedgerRejected(InsufficientBalance)・書込みゼロ', () async {
      await mustApply(earn('session:s1', 100));
      final r = await mustApply(CoinTransaction.motifUnlock(
          motif: const HourglassMotif(), occurredAt: t0)); // 価格120 > 100
      expect(r, isA<LedgerRejected>());
      final failure = (r as LedgerRejected).failure;
      expect(failure, isA<InsufficientBalance>());
      final insufficient = failure as InsufficientBalance;
      expect(insufficient.required, 120);
      expect(insufficient.available, 100);
      expect(await ledgerRowCount(), 1, reason: '拒否は台帳に痕跡を残さない');
    });

    test('十分な残高で解放され、射影unlocksに反映される', () async {
      await mustApply(earn('session:s1', 150));
      final r = await mustApply(CoinTransaction.motifUnlock(
          motif: const HourglassMotif(), occurredAt: t0));
      final state = (r as Applied).state;
      expect(state.wallet.balance, 30);
      expect(state.unlocks.isUnlocked(const HourglassMotif().id), isTrue);
      expect(state.appliedKeys, contains('unlock:hourglass'),
          reason: 'べき等キー書式の回帰(T6)');
    });

    test('解放の二重購入はAlreadyApplied(残高は1回分のみ減る)', () async {
      await mustApply(earn('session:s1', 300));
      await mustApply(CoinTransaction.motifUnlock(
          motif: const HourglassMotif(), occurredAt: t0));
      final again = await mustApply(CoinTransaction.motifUnlock(
          motif: const HourglassMotif(), occurredAt: t0));
      expect(again, isA<AlreadyApplied>());
      expect((again as AlreadyApplied).state.wallet.balance, 180);
    });
  });

  group('射影の永続性(D14)', () {
    test('別リポジトリインスタンスでも台帳リプレイで同一状態', () async {
      await mustApply(earn('session:s1', 150));
      await mustApply(CoinTransaction.motifUnlock(
          motif: const HourglassMotif(), occurredAt: t0));

      final repo2 = DriftPreferencesRepository(db); // 同一DB・新インスタンス
      final r = await repo2.loadEconomyState();
      final s = (r as Success<EconomyState, StorageFailure>).value;
      expect(s.wallet.balance, 30);
      expect(s.unlocks.isUnlocked(const HourglassMotif().id), isTrue);
      expect(s.appliedKeys,
          containsAll(<String>{'session:s1', 'unlock:hourglass'}));
    });

    test('snapshotと台帳射影の不一致はStorageCorrupted', () async {
      await mustApply(earn('session:s1', 25));
      await db.customStatement(
          'UPDATE wallet_snapshot SET balance = 999 WHERE id = 1');
      final r = await repo.loadEconomyState();
      expect(r, isA<Failure<EconomyState, StorageFailure>>());
      expect((r as Failure<EconomyState, StorageFailure>).error,
          isA<StorageCorrupted>());
    });
  });

  group('watchEconomyState', () {
    test('listen直後に現在値、apply成功で新状態が流れる', () async {
      final stream = repo.watchEconomyState().asBroadcastStream();
      final first = await stream.first;
      expect(first.wallet.balance, 0);

      final updated =
          stream.firstWhere((s) => s.wallet.balance == 25);
      await mustApply(earn('session:s1', 25));
      final got = await updated;
      expect(got.appliedKeys, contains('session:s1'));
    });
  });

  group('第3層防御: DB制約はリポジトリ迂回の書込みも拒否する(T7)', () {
    test('UNIQUE(idempotency_key): 生SQLの重複INSERTは失敗', () async {
      await mustApply(earn('session:s1', 25));
      expect(
        () => db.customStatement(
            "INSERT INTO coin_transactions "
            "(idempotency_key, type, amount, occurred_at_utc_ms) "
            "VALUES ('session:s1', 'earn', 10, 0)"),
        throwsA(anything),
      );
    });

    test('CHECK(amount > 0): 0円・負額トランザクションはINSERT不能', () async {
      for (final bad in [0, -5]) {
        expect(
          () => db.customStatement(
              "INSERT INTO coin_transactions "
              "(idempotency_key, type, amount, occurred_at_utc_ms) "
              "VALUES ('k$bad', 'earn', $bad, 0)"),
          throwsA(anything),
          reason: 'amount=$bad はCHECK違反であるべき',
        );
      }
    });

    test('CHECK(balance >= 0): 負残高snapshotはUPDATE不能', () async {
      await mustApply(earn('session:s1', 25));
      expect(
        () => db.customStatement(
            'UPDATE wallet_snapshot SET balance = -1 WHERE id = 1'),
        throwsA(anything),
      );
    });

    test('単一行規約: wallet_snapshotにid=2は挿入不能', () async {
      await mustApply(earn('session:s1', 25));
      expect(
        () => db.customStatement(
            'INSERT INTO wallet_snapshot (id, balance) VALUES (2, 0)'),
        throwsA(anything),
      );
    });

    test('type↔motif_id整合CHECK: earnにmotif_idは持たせられない', () async {
      expect(
        () => db.customStatement(
            "INSERT INTO coin_transactions "
            "(idempotency_key, type, amount, motif_id, occurred_at_utc_ms) "
            "VALUES ('kx', 'earn', 10, 'water', 0)"),
        throwsA(anything),
      );
      expect(
        () => db.customStatement(
            "INSERT INTO coin_transactions "
            "(idempotency_key, type, amount, occurred_at_utc_ms) "
            "VALUES ('ky', 'spend_unlock', 10, 0)"),
        throwsA(anything),
        reason: 'spend_unlockはmotif_id必須',
      );
    });
  });

  group('UserSettings往復(明示マッパー, LANDMINE ②)', () {
    test('save→loadで等価・Durationはms往復で欠損なし', () async {
      final custom = UserSettings(
        selectedMotifId: const MotifId('hourglass'),
        defaultSessionDuration: const Duration(minutes: 50),
        bgmEnabled: false,
      );
      final saved = await repo.saveSettings(custom);
      expect(saved, isA<Success<void, StorageFailure>>());
      final r = await repo.loadSettings();
      expect((r as Success<UserSettings, StorageFailure>).value, custom);
    });

    test('上書き保存(upsert)は単一行のまま最新値になる', () async {
      await repo.saveSettings(UserSettings.defaults());
      await repo.saveSettings(UserSettings.defaults()
          .copyWith(bgmEnabled: false));
      final count = await db
          .customSelect('SELECT COUNT(*) AS c FROM user_settings')
          .getSingle();
      expect(count.read<int>('c'), 1);
      final r = await repo.loadSettings();
      expect(
          (r as Success<UserSettings, StorageFailure>).value.bgmEnabled, false);
    });
  });
}
