import 'package:flutter_test/flutter_test.dart';

import 'package:focus_orbit/core/domain/ids.dart';
import 'package:focus_orbit/features/economy/domain/coin_transaction.dart';
import 'package:focus_orbit/features/economy/domain/economy_ledger.dart';
import 'package:focus_orbit/features/economy/domain/unlock_state.dart';
import 'package:focus_orbit/features/economy/domain/wallet.dart';
import 'package:focus_orbit/features/motif/domain/motifs/bonsai_motif.dart';
import 'package:focus_orbit/features/motif/domain/motifs/hourglass_motif.dart';
import 'package:focus_orbit/features/motif/domain/motifs/water_motif.dart';

/// P1-T8: 経済圏の不変条件テスト。
///
/// 防衛線は三層: (1) EconomyLedger.apply の残高検査(業務規則)
/// (2) Wallet の @Assert(構築境界の最終防衛線)
/// (3) 永続層の UNIQUE 制約(T7, ここでは対象外 — インメモリ射影 appliedKeys を検証)。
/// 本テストは (1)(2) と、べき等キーの生成規約(session:/unlock:)を固定する。
void main() {
  final t0 = DateTime.utc(2026, 1, 1);

  CoinTransaction earn(String key, int amount) =>
      CoinTransaction.earn(idempotencyKey: key, amount: amount, occurredAt: t0);

  Applied mustApply(EconomyState s, CoinTransaction tx) {
    final r = EconomyLedger.apply(s, tx);
    expect(r, isA<Applied>(), reason: '$tx は Applied であるべき');
    return r as Applied;
  }

  group('初期状態(D10)', () {
    test('残高0・水のみ解放・適用済みキーなし', () {
      final s = EconomyState.initial();
      expect(s.wallet.balance, 0);
      expect(s.unlocks.isUnlocked(const WaterMotif().id), isTrue);
      expect(s.unlocks.isUnlocked(const HourglassMotif().id), isFalse);
      expect(s.unlocks.isUnlocked(const BonsaiMotif().id), isFalse);
      expect(s.appliedKeys, isEmpty);
    });
  });

  group('Earn(獲得)', () {
    test('残高が正確に増加し、キーが記録される', () {
      final r = mustApply(EconomyState.initial(), earn('k1', 30));
      expect(r.state.wallet.balance, 30);
      expect(r.state.appliedKeys, {'k1'});
    });

    test('異なるキーの獲得は累積する', () {
      var s = EconomyState.initial();
      s = mustApply(s, earn('k1', 30)).state;
      s = mustApply(s, earn('k2', 12)).state;
      expect(s.wallet.balance, 42);
      expect(s.appliedKeys, {'k1', 'k2'});
    });
  });

  group('べき等性(二重適用の吸収)', () {
    test('同一キーの再適用は AlreadyApplied、状態は同一インスタンス', () {
      final s1 = mustApply(EconomyState.initial(), earn('k1', 30)).state;
      final r2 = EconomyLedger.apply(s1, earn('k1', 30));
      expect(r2, isA<AlreadyApplied>());
      expect((r2 as AlreadyApplied).state, same(s1), reason: '状態は不変(同一参照)');
      expect(r2.state.wallet.balance, 30, reason: '二重加算されない');
    });

    test('D16シナリオ: 同一セッション報酬(GrantReward)の二重発火は1回分だけ加算', () {
      const sid = SessionId('s-777');
      final tx1 = CoinTransaction.sessionReward(
          sessionId: sid, coins: 30, occurredAt: t0);
      final tx2 = CoinTransaction.sessionReward(
          sessionId: sid, coins: 30, occurredAt: t0.add(const Duration(seconds: 1)));
      var s = EconomyState.initial();
      s = mustApply(s, tx1).state;
      final r = EconomyLedger.apply(s, tx2);
      expect(r, isA<AlreadyApplied>(),
          reason: 'occurredAtが違ってもキー(session:{id})が同じなら吸収');
      expect((r as AlreadyApplied).state.wallet.balance, 30);
    });

    test('sessionReward のキー規約は session:{id}(T4のGrantRewardと1:1)', () {
      final tx = CoinTransaction.sessionReward(
          sessionId: const SessionId('abc'), coins: 5, occurredAt: t0);
      expect(tx.idempotencyKey, 'session:abc');
    });

    test('解放のべき等: 同一モチーフの二重購入は AlreadyApplied で残高も減らない', () {
      const hourglass = HourglassMotif();
      var s = mustApply(EconomyState.initial(), earn('k1', 300)).state;
      s = mustApply(
              s, CoinTransaction.motifUnlock(motif: hourglass, occurredAt: t0))
          .state;
      expect(s.wallet.balance, 300 - hourglass.priceCoins);
      final r = EconomyLedger.apply(
          s, CoinTransaction.motifUnlock(motif: hourglass, occurredAt: t0));
      expect(r, isA<AlreadyApplied>());
      expect((r as AlreadyApplied).state.wallet.balance,
          300 - hourglass.priceCoins);
    });
  });

  group('SpendUnlock(購入)と残高境界', () {
    const hourglass = HourglassMotif(); // 120コイン

    test('残高 = 価格ちょうど → 購入成立、残高0(canAfford は >= )', () {
      var s = mustApply(
              EconomyState.initial(), earn('k1', hourglass.priceCoins))
          .state;
      final r = mustApply(
          s, CoinTransaction.motifUnlock(motif: hourglass, occurredAt: t0));
      expect(r.state.wallet.balance, 0);
      expect(r.state.unlocks.isUnlocked(hourglass.id), isTrue);
    });

    test('残高 = 価格 - 1 → LedgerRejected(InsufficientBalance)、必要額と保有額を運搬', () {
      final s = mustApply(
              EconomyState.initial(), earn('k1', hourglass.priceCoins - 1))
          .state;
      final r = EconomyLedger.apply(
          s, CoinTransaction.motifUnlock(motif: hourglass, occurredAt: t0));
      expect(r, isA<LedgerRejected>());
      final failure = (r as LedgerRejected).failure;
      expect(
        failure,
        isA<InsufficientBalance>()
            .having((f) => f.required, 'required', hourglass.priceCoins)
            .having((f) => f.available, 'available', hourglass.priceCoins - 1),
      );
    });

    test('拒否は状態を変更せず、キーも消費しない(貯めてから同キーで再試行できる)', () {
      const hourglass = HourglassMotif();
      var s = mustApply(EconomyState.initial(), earn('k1', 100)).state;
      final rejected = EconomyLedger.apply(
          s, CoinTransaction.motifUnlock(motif: hourglass, occurredAt: t0));
      expect(rejected, isA<LedgerRejected>());
      expect(s.wallet.balance, 100, reason: '拒否後も残高不変');
      expect(s.appliedKeys, {'k1'}, reason: 'unlock:キーは未消費');
      expect(s.unlocks.isUnlocked(hourglass.id), isFalse);
      // 貯める → 同一キーで再試行 → 今度は成立
      s = mustApply(s, earn('k2', 50)).state;
      final retry = mustApply(
          s, CoinTransaction.motifUnlock(motif: hourglass, occurredAt: t0));
      expect(retry.state.wallet.balance, 150 - hourglass.priceCoins);
      expect(retry.state.unlocks.isUnlocked(hourglass.id), isTrue);
    });

    test('連続購入の旅程: 320稼ぎ、砂時計(120)→盆栽(200)で残高0・3種解放', () {
      var s = EconomyState.initial();
      s = mustApply(s, earn('k1', 320)).state;
      s = mustApply(s,
              CoinTransaction.motifUnlock(motif: const HourglassMotif(), occurredAt: t0))
          .state;
      s = mustApply(s,
              CoinTransaction.motifUnlock(motif: const BonsaiMotif(), occurredAt: t0))
          .state;
      expect(s.wallet.balance, 0);
      expect(s.unlocks.unlockedIds, {
        const WaterMotif().id,
        const HourglassMotif().id,
        const BonsaiMotif().id,
      });
      expect(s.appliedKeys,
          {'k1', 'unlock:hourglass', 'unlock:bonsai'});
    });
  });

  group('純粋性(applyは入力を変異させない)', () {
    test('Applied 後も入力状態の残高・キー集合・解放集合は不変', () {
      // 注: freezedのコレクションゲッターは EqualUnmodifiableSetView を
      // アクセスごとに生成して返すため、参照同一性(same)は検証に使えない。
      // 値の等価と「変異が物理的に不可能」であることを検証する。
      final s0 = EconomyState.initial();
      mustApply(s0, earn('k1', 30));
      expect(s0.wallet.balance, 0);
      expect(s0.appliedKeys, isEmpty);
      expect(s0.unlocks.unlockedIds, {const WaterMotif().id});
    });

    test('公開されるコレクションは不変ビュー: 外部からの変異は UnsupportedError', () {
      final s0 = EconomyState.initial();
      expect(() => s0.appliedKeys.add('injected'),
          throwsA(isA<UnsupportedError>()));
      expect(() => s0.unlocks.unlockedIds.add(const HourglassMotif().id),
          throwsA(isA<UnsupportedError>()));
      // 変異の試み後も状態は無傷
      expect(s0.appliedKeys, isEmpty);
      expect(s0.unlocks.unlockedIds, {const WaterMotif().id});
    });
  });

  group('構築境界の最終防衛線(@Assert)', () {
    test('Wallet(balance: -1) は構築不可能(負残高の物理的禁止)', () {
      expect(() => Wallet(balance: -1), throwsA(isA<AssertionError>()));
    });

    test('Earn(amount: 0) は構築不可能(ゼロ・負の獲得禁止)', () {
      expect(() => earn('k', 0), throwsA(isA<AssertionError>()));
      expect(() => earn('k', -5), throwsA(isA<AssertionError>()));
    });

    test('SpendUnlock(amount: 0) は構築不可能', () {
      expect(
        () => CoinTransaction.spendUnlock(
          idempotencyKey: 'k',
          amount: 0,
          motifId: const HourglassMotif().id,
          occurredAt: t0,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('価格0の初期解放品(水)は購入トランザクション自体が生成禁止(D10)', () {
      expect(
        () => CoinTransaction.motifUnlock(
            motif: const WaterMotif(), occurredAt: t0),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('UnlockState 単体', () {
    test('unlock はべき等: 解放済みIDには同一インスタンスを返す', () {
      const water = WaterMotif();
      final u = UnlockState(unlockedIds: {water.id});
      expect(u.unlock(water.id), same(u));
    });

    test('未解放IDの unlock は新インスタンスで、元は不変', () {
      const water = WaterMotif();
      const hourglass = HourglassMotif();
      final u = UnlockState(unlockedIds: {water.id});
      final u2 = u.unlock(hourglass.id);
      expect(u2, isNot(same(u)));
      expect(u2.isUnlocked(hourglass.id), isTrue);
      expect(u.isUnlocked(hourglass.id), isFalse, reason: '元インスタンスは不変');
    });
  });
}
