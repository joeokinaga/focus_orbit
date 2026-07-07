import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:focus_orbit/app/presentation/fo_theme.dart';
import 'package:focus_orbit/core/domain/ids.dart';
import 'package:focus_orbit/features/economy/application/economy_providers.dart';
import 'package:focus_orbit/features/economy/application/shop_controller.dart';
import 'package:focus_orbit/features/economy/domain/economy_ledger.dart';
import 'package:focus_orbit/features/motif/application/selected_motif_controller.dart';
import 'package:focus_orbit/features/motif/domain/motif_catalog.dart';
import 'package:focus_orbit/features/motif/domain/motif_skin.dart';

/// 画面3: Shop / Motif Selection(スキン解放・装備)。
///
/// 【層規則】残高・解放の真実は EconomyLedger と drift 台帳(Phase 1)にあり、
/// 本画面は economyStateProvider の射影を描画するのみ。購入判定は
/// ShopController.purchase() に完全委譲し、UI は PurchaseOutcome の
/// 5値を表示に変換するだけ(D11: カタログ検証もコントローラの責務)。
///
/// 【ライフサイクル監査】AnimationController 等の生成なし。
/// 破棄対象は在飛行フラグ(_purchasing)のみで、これは State と共に消える。
///
/// 【非同期ハザード】purchase() の await 後に必ず `if (!mounted) return;`。
/// 二重タップは _purchasing(在飛行Set)で遮断するが、真のべき等性は
/// 台帳の UNIQUE(idempotency_key) が保証する(UIガードは体験向上のみ)。
class ShopView extends ConsumerStatefulWidget {
  const ShopView({super.key});

  /// app 層(FocusOrbitApp)が登録するルート名。定数の所有者は本ビュー。
  static const String routeName = '/shop';

  @override
  ConsumerState<ShopView> createState() => _ShopViewState();
}

class _ShopViewState extends ConsumerState<ShopView> {
  /// 購入リクエスト在飛行中の MotifId(ボタン無効化と二重タップ抑止)。
  final Set<MotifId> _purchasing = <MotifId>{};

  Future<void> _onPurchasePressed(MotifSkin motif) async {
    if (_purchasing.contains(motif.id)) return;
    setState(() => _purchasing.add(motif.id));

    final outcome =
        await ref.read(shopControllerProvider).purchase(motif.id);
    if (!mounted) return; // await後ガード(必須)

    setState(() => _purchasing.remove(motif.id));

    // PurchaseOutcome 5値の完全分岐(default なし — 値追加時はコンパイルエラー)
    final message = switch (outcome) {
      PurchaseOutcome.unlocked => '「${_motifDisplayName(motif.id)}」を解放しました',
      PurchaseOutcome.alreadyOwned => 'このモチーフはすでに解放済みです',
      PurchaseOutcome.insufficientBalance => 'コインが足りません。集中セッションで貯めましょう',
      PurchaseOutcome.unknownMotif => 'このモチーフは現在利用できません。アプリを最新版に更新してください',
      PurchaseOutcome.storageError => '保存に失敗しました。時間をおいてもう一度お試しください',
    };
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _onEquipPressed(MotifId id) {
    ref.read(selectedMotifProvider.notifier).select(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('「${_motifDisplayName(id)}」を装備しました')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final economyAsync = ref.watch(economyStateProvider);
    final equippedId = ref.watch(selectedMotifProvider);

    return Scaffold(
      backgroundColor: FoPalette.ink,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  FoSpace.lg, FoSpace.lg, FoSpace.lg, FoSpace.sm),
              child: Row(
                children: [
                  const Text(
                    'モチーフ',
                    style: TextStyle(
                      color: FoPalette.text,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  const Spacer(),
                  _WalletBadge(economy: economyAsync),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: FoSpace.lg),
              child: Text(
                '集中で得たコインで、新しい世界を解放できます',
                style: TextStyle(color: FoPalette.textDim, fontSize: 13),
              ),
            ),
            const SizedBox(height: FoSpace.md),
            Expanded(
              // AsyncValue の網羅(loading / error / data)。
              // 「空」は EconomyState.initial()(残高0・水のみ解放)として
              // data に内包される設計のため、専用の空画面は存在しない。
              child: switch (economyAsync) {
                AsyncData(:final value) => _MotifList(
                    economy: value,
                    equippedId: equippedId,
                    purchasing: _purchasing,
                    onPurchase: _onPurchasePressed,
                    onEquip: _onEquipPressed,
                  ),
                AsyncError() => _EconomyErrorBody(
                    onRetry: () => ref.invalidate(economyStateProvider),
                  ),
                AsyncLoading() => const Center(
                    child: SizedBox.square(
                      dimension: 28,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: FoPalette.textDim),
                    ),
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 残高バッジ(ヘッダー右上。ロード中・エラー時は静かにプレースホルダ)
// ---------------------------------------------------------------------------

class _WalletBadge extends StatelessWidget {
  const _WalletBadge({required this.economy});

  final AsyncValue<EconomyState> economy;

  @override
  Widget build(BuildContext context) {
    final String text = switch (economy) {
      AsyncData(:final value) => '${value.wallet.balance}',
      AsyncError() => '—',
      AsyncLoading() => '…',
    };
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: FoSpace.md, vertical: FoSpace.sm),
      decoration: BoxDecoration(
        color: FoPalette.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: FoPalette.hairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.brightness_7,
              size: 16, color: FoPalette.reward),
          const SizedBox(width: FoSpace.xs + 2),
          Text(
            text,
            style: const TextStyle(
              color: FoPalette.text,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              fontFeatures: foTabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// カタログ一覧(MotifCatalog.all が唯一の登録点 — UI は具象型を知らない)
// ---------------------------------------------------------------------------

class _MotifList extends StatelessWidget {
  const _MotifList({
    required this.economy,
    required this.equippedId,
    required this.purchasing,
    required this.onPurchase,
    required this.onEquip,
  });

  final EconomyState economy;
  final MotifId equippedId;
  final Set<MotifId> purchasing;
  final void Function(MotifSkin) onPurchase;
  final void Function(MotifId) onEquip;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
          FoSpace.lg, FoSpace.sm, FoSpace.lg, FoSpace.xl),
      itemCount: MotifCatalog.all.length,
      separatorBuilder: (_, __) => const SizedBox(height: FoSpace.md),
      itemBuilder: (context, index) {
        final motif = MotifCatalog.all[index];
        return _MotifCard(
          motif: motif,
          unlocked: economy.unlocks.isUnlocked(motif.id),
          equipped: motif.id == equippedId,
          canAfford: economy.wallet.canAfford(motif.priceCoins),
          inFlight: purchasing.contains(motif.id),
          onPurchase: () => onPurchase(motif),
          onEquip: () => onEquip(motif.id),
        );
      },
    );
  }
}

class _MotifCard extends StatelessWidget {
  const _MotifCard({
    required this.motif,
    required this.unlocked,
    required this.equipped,
    required this.canAfford,
    required this.inFlight,
    required this.onPurchase,
    required this.onEquip,
  });

  final MotifSkin motif;
  final bool unlocked;
  final bool equipped;
  final bool canAfford;
  final bool inFlight;
  final VoidCallback onPurchase;
  final VoidCallback onEquip;

  @override
  Widget build(BuildContext context) {
    final rp = motif.renderParams;
    return Container(
      padding: const EdgeInsets.all(FoSpace.md),
      decoration: BoxDecoration(
        color: FoPalette.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: equipped ? rp.primaryColor : FoPalette.hairline,
          width: equipped ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // モチーフの世界を映すスウォッチ(色はドメイン値そのもの)
          Container(
            width: 64,
            height: 64,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [rp.secondaryColor, rp.primaryColor],
              ),
              boxShadow: [
                BoxShadow(
                  color: rp.primaryColor
                      .withValues(alpha: 0.3 * rp.ambientGlow + 0.1),
                  blurRadius: 16,
                ),
              ],
            ),
            child: unlocked
                ? null
                : const Icon(Icons.lock_outline,
                    color: Colors.white70, size: 22),
          ),
          const SizedBox(width: FoSpace.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _motifDisplayName(motif.id),
                  style: const TextStyle(
                    color: FoPalette.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _motifTagline(motif.id),
                  style: const TextStyle(
                      color: FoPalette.textDim, fontSize: 12),
                ),
                const SizedBox(height: FoSpace.xs),
                if (!unlocked)
                  Row(
                    children: [
                      const Icon(Icons.brightness_7,
                          size: 13, color: FoPalette.reward),
                      const SizedBox(width: 4),
                      Text(
                        '${motif.priceCoins}',
                        style: TextStyle(
                          color: canAfford
                              ? FoPalette.reward
                              : FoPalette.textDim,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          fontFeatures: foTabularFigures,
                        ),
                      ),
                      if (!canAfford) ...[
                        const SizedBox(width: FoSpace.xs),
                        const Text(
                          'コイン不足',
                          style: TextStyle(
                              color: FoPalette.textDim, fontSize: 11),
                        ),
                      ],
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(width: FoSpace.sm),
          _MotifAction(
            unlocked: unlocked,
            equipped: equipped,
            canAfford: canAfford,
            inFlight: inFlight,
            accent: rp.primaryColor,
            onPurchase: onPurchase,
            onEquip: onEquip,
          ),
        ],
      ),
    );
  }
}

/// カードの右端アクション。状態は4通り:
/// 装備中(バッジ) / 解放済み(装備ボタン) / 未解放(購入ボタン) / 購入中(スピナー)。
class _MotifAction extends StatelessWidget {
  const _MotifAction({
    required this.unlocked,
    required this.equipped,
    required this.canAfford,
    required this.inFlight,
    required this.accent,
    required this.onPurchase,
    required this.onEquip,
  });

  final bool unlocked;
  final bool equipped;
  final bool canAfford;
  final bool inFlight;
  final Color accent;
  final VoidCallback onPurchase;
  final VoidCallback onEquip;

  @override
  Widget build(BuildContext context) {
    if (inFlight) {
      return const SizedBox.square(
        dimension: 24,
        child: CircularProgressIndicator(
            strokeWidth: 2, color: FoPalette.textDim),
      );
    }
    if (equipped) {
      return Container(
        padding: const EdgeInsets.symmetric(
            horizontal: FoSpace.md, vertical: FoSpace.sm),
        decoration: BoxDecoration(
          color: accent.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, size: 14, color: accent),
            const SizedBox(width: 4),
            const Text('装備中',
                style: TextStyle(color: FoPalette.text, fontSize: 12)),
          ],
        ),
      );
    }
    if (unlocked) {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: FoPalette.text,
          side: BorderSide(color: accent.withValues(alpha: 0.6)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onEquip,
        child: const Text('装備する', style: TextStyle(fontSize: 13)),
      );
    }
    // 未解放: コイン不足なら無効化(視覚的な事前案内)。
    // 最終判定は台帳(LedgerRejected→insufficientBalance)が真実。
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: FoPalette.ink,
        disabledBackgroundColor: FoPalette.surfaceHigh,
        disabledForegroundColor: FoPalette.textDim,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: canAfford ? onPurchase : null,
      child: const Text('解放する',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }
}

// ---------------------------------------------------------------------------
// error 状態(data の「空」は EconomyState.initial() に内包されるため専用画面なし)
// ---------------------------------------------------------------------------

class _EconomyErrorBody extends StatelessWidget {
  const _EconomyErrorBody({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.savings_outlined,
              size: 48, color: FoPalette.textDim),
          const SizedBox(height: FoSpace.md),
          const Text(
            '残高を読み込めませんでした',
            style: TextStyle(color: FoPalette.text, fontSize: 15),
          ),
          const SizedBox(height: FoSpace.xs),
          const Text(
            'コインと解放状況は端末内に安全に保存されています',
            style: TextStyle(color: FoPalette.textDim, fontSize: 12),
          ),
          const SizedBox(height: FoSpace.md),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: FoPalette.text,
              side: const BorderSide(color: FoPalette.hairline),
            ),
            onPressed: onRetry,
            child: const Text('もう一度試す'),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 表示名(プレゼンテーション層の翻訳。ドメインは id のみを持つ設計 — T5)
// ---------------------------------------------------------------------------

String _motifDisplayName(MotifId id) => switch (id.value) {
      'water' => '水',
      'hourglass' => '砂時計',
      'bonsai' => '盆栽',
      _ => id.value, // 未知IDフォールバック(D11と同思想)
    };

String _motifTagline(MotifId id) => switch (id.value) {
      'water' => '静かな流れに身をあずける',
      'hourglass' => '落ちる砂と、積もる時間',
      'bonsai' => 'ゆっくりと、しかし確かに育つ',
      _ => '',
    };
