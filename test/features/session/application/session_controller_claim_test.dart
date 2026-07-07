// P3-T3b: 請求リトライ経路の回帰テスト。
//
// 固定する仕様(§5シーケンス図・D16・T6):
//   (1) apply失敗 → failedRetryable を返し、phaseはcompletedに留まる(コイン非消失)
//   (2) 再試行は「同一idempotencyKey」で行われる(二重付与防止の鍵)
//   (3) 再試行成功 → granted を返し idle へ遷移
//   (4) AlreadyApplied応答(過去コミット済みの再送)も granted 扱いで idle へ
//   (5) 非completedでの請求は notClaimable(apply呼び出し自体が発生しない)
//
// テスト戦術: fakeAsync で1秒セッションを完走させ Completed へ到達。
// リポジトリは「N回失敗してから成功する」フェイクで、渡された
// CoinTransaction を全記録し、キーの同一性を直接検証する。

import 'package:fake_async/fake_async.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:focus_orbit/core/application/clock.dart';
import 'package:focus_orbit/core/domain/ids.dart';
import 'package:focus_orbit/core/domain/result.dart';
import 'package:focus_orbit/core/domain/sync_mode.dart';
import 'package:focus_orbit/features/economy/application/economy_providers.dart';
import 'package:focus_orbit/features/economy/domain/coin_transaction.dart';
import 'package:focus_orbit/features/economy/domain/economy_ledger.dart';
import 'package:focus_orbit/features/economy/domain/local_preferences_repository.dart';
import 'package:focus_orbit/features/economy/domain/user_settings.dart';
import 'package:focus_orbit/features/presence/application/presence_providers.dart';
import 'package:focus_orbit/features/presence/data/solo_room_repository.dart';
import 'package:focus_orbit/features/session/application/session_controller.dart';
import 'package:focus_orbit/features/session/domain/session_phase.dart';
import 'package:focus_orbit/features/stance/application/stance_providers.dart';
import 'package:focus_orbit/features/stance/domain/motion_sample.dart';
import 'package:focus_orbit/features/stance/domain/sensor_gateway.dart';

/// サンプルを流さない無音センサー(claim経路にstance入力は不要)。
final class _SilentSensorGateway implements SensorGateway {
  @override
  Stream<MotionSample> motionSamples({required Duration samplingPeriod}) =>
      const Stream<MotionSample>.empty();
}

/// N回失敗してから成功するフェイクリポジトリ。
/// 渡されたトランザクションを全記録し、コミット済みキーで
/// AlreadyApplied を返す(本物のUNIQUE制約の写像)。
final class _FlakyPreferencesRepository implements LocalPreferencesRepository {
  _FlakyPreferencesRepository({
    this.failuresRemaining = 0,
    this.alwaysAlreadyApplied = false,
  });

  int failuresRemaining;
  final bool alwaysAlreadyApplied;
  final List<CoinTransaction> attempts = [];
  final Set<String> committedKeys = {};

  @override
  Future<Result<LedgerResult, StorageFailure>> apply(CoinTransaction tx) {
    attempts.add(tx);
    if (failuresRemaining > 0) {
      failuresRemaining--;
      return Future.value(const Failure(StorageIoFailure('simulated io')));
    }
    if (alwaysAlreadyApplied || committedKeys.contains(tx.idempotencyKey)) {
      return Future.value(Success(AlreadyApplied(EconomyState.initial())));
    }
    committedKeys.add(tx.idempotencyKey);
    return Future.value(Success(Applied(EconomyState.initial())));
  }

  @override
  Future<Result<EconomyState, StorageFailure>> loadEconomyState() =>
      Future.value(Success(EconomyState.initial()));

  @override
  Stream<EconomyState> watchEconomyState() => const Stream.empty();

  // claim経路では呼ばれない。呼ばれたらテスト設計の破れなので即死させる。
  @override
  Future<Result<UserSettings, StorageFailure>> loadSettings() =>
      throw UnimplementedError('claim経路でloadSettingsは呼ばれない想定');

  @override
  Future<Result<void, StorageFailure>> saveSettings(UserSettings settings) =>
      throw UnimplementedError('claim経路でsaveSettingsは呼ばれない想定');
}

ProviderContainer _makeContainer(_FlakyPreferencesRepository repo) {
  final container = ProviderContainer(
    overrides: [
      sensorGatewayProvider.overrideWithValue(_SilentSensorGateway()),
      localPreferencesRepositoryProvider.overrideWithValue(repo),
      remoteRoomRepositoryProvider.overrideWithValue(SoloRoomRepository()),
      clockProvider.overrideWithValue(
        () => DateTime.utc(2026, 7, 7, 12), // 決定的な時刻(D20)
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

/// 1分セッションを完走させ Completed に到達させる(fakeAsync前提)。
/// 1分=D18の報酬最小単位(1コイン)。これ未満だと報酬0の非現実入力になり、
/// 実リポジトリでは台帳検証(amount>0)に弾かれる経路をテストしてしまう。
SessionController _driveToCompleted(
  FakeAsync async,
  ProviderContainer container,
) {
  final controller = container.read(sessionControllerProvider.notifier);
  controller.start(
    duration: const Duration(minutes: 1),
    motifId: const MotifId('water'),
    syncMode: SyncMode.solo,
  );
  async.elapse(const Duration(minutes: 1)); // 60 tick → timerCompleted
  expect(container.read(sessionControllerProvider).phase, isA<Completed>(),
      reason: '前提: 1分経過でcompletedに到達しているはず');
  return controller;
}

void main() {
  group('claimReward リトライ経路(D16×T6)', () {
    test('apply失敗: failedRetryableを返しcompletedに留まる(コイン非消失)', () {
      fakeAsync((async) {
        final repo = _FlakyPreferencesRepository(failuresRemaining: 1);
        final container = _makeContainer(repo);
        final controller = _driveToCompleted(async, container);

        ClaimOutcome? outcome;
        controller.claimReward().then((o) => outcome = o);
        async.flushMicrotasks();

        expect(outcome, ClaimOutcome.failedRetryable);
        expect(container.read(sessionControllerProvider).phase,
            isA<Completed>(),
            reason: 'D16: 失敗時はcompletedに留まる=報酬請求権が保存される');
        expect(repo.attempts, hasLength(1));
        expect(repo.committedKeys, isEmpty);
      });
    });

    test('再試行: 同一idempotencyKeyで成功しidleへ遷移する', () {
      fakeAsync((async) {
        final repo = _FlakyPreferencesRepository(failuresRemaining: 1);
        final container = _makeContainer(repo);
        final controller = _driveToCompleted(async, container);

        ClaimOutcome? first;
        controller.claimReward().then((o) => first = o);
        async.flushMicrotasks();
        expect(first, ClaimOutcome.failedRetryable);

        ClaimOutcome? second;
        controller.claimReward().then((o) => second = o);
        async.flushMicrotasks();

        expect(second, ClaimOutcome.granted);
        expect(container.read(sessionControllerProvider).phase, isA<Idle>(),
            reason: '成功後にのみidleへ(効果先行コミット)');
        expect(repo.attempts, hasLength(2));
        expect(repo.attempts[0].idempotencyKey, repo.attempts[1].idempotencyKey,
            reason: 'T6: 再試行は同一キー。これが二重付与防止の根拠');
        expect(repo.committedKeys, hasLength(1));
      });
    });

    test('AlreadyApplied応答: granted扱いでidleへ(過去コミット済みの再送)', () {
      fakeAsync((async) {
        final repo = _FlakyPreferencesRepository(alwaysAlreadyApplied: true);
        final container = _makeContainer(repo);
        final controller = _driveToCompleted(async, container);

        ClaimOutcome? outcome;
        controller.claimReward().then((o) => outcome = o);
        async.flushMicrotasks();

        expect(outcome, ClaimOutcome.granted,
            reason: 'AlreadyApplied=付与済みの証拠であり失敗ではない(§5)');
        expect(container.read(sessionControllerProvider).phase, isA<Idle>());
      });
    });

    test('非completedでの請求: notClaimableでapply自体が呼ばれない', () async {
      final repo = _FlakyPreferencesRepository();
      final container = _makeContainer(repo);
      // idleのまま請求
      final outcome = await container
          .read(sessionControllerProvider.notifier)
          .claimReward();

      expect(outcome, ClaimOutcome.notClaimable);
      expect(repo.attempts, isEmpty,
          reason: 'ガードはリポジトリ到達前(無駄なI/Oと誤記録の防止)');
    });
  });
}
