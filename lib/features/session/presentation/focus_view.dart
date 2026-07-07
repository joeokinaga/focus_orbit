import 'dart:math' as math;

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:focus_orbit/app/presentation/fo_theme.dart';
import 'package:focus_orbit/core/domain/sync_mode.dart';
import 'package:focus_orbit/features/economy/presentation/shop_view.dart';
import 'package:focus_orbit/features/economy/domain/user_settings.dart';
import 'package:focus_orbit/features/motif/application/selected_motif_controller.dart';
import 'package:focus_orbit/features/motif/domain/motif_catalog.dart';
import 'package:focus_orbit/features/motif/domain/motif_skin.dart';
import 'package:focus_orbit/features/motif/domain/motifs/water_motif.dart';
import 'package:focus_orbit/features/motif/domain/render_params.dart';
import 'package:focus_orbit/features/presence/presentation/orbit_view.dart';
import 'package:focus_orbit/features/session/application/session_controller.dart';
import 'package:focus_orbit/features/session/application/view_mode_controller.dart';
import 'package:focus_orbit/features/session/domain/focus_session.dart';
import 'package:focus_orbit/features/session/domain/session_phase.dart';
import 'package:focus_orbit/features/session/domain/view_mode.dart';

/// 画面1: Focus View(メイン集中タイマー)。
///
/// 【層規則】本ファイルはロジックを持たない。フェーズ判定・遷移・報酬付与の
/// 真実は SessionController / SessionTransition にあり、ここは
/// (1) FocusSession を描画する (2) ユーザー操作をイベントとして発火する のみ。
///
/// 【ライフサイクル監査】生成/破棄ペア:
///   WidgetsBinding.addObserver : initState / dispose(removeObserver)
///   _orbitCtrl(常時回転)       : initState / dispose
///   _pulseCtrl(warning点滅)    : initState / dispose
///   _graceCtrl(猶予プログレス)  : initState / dispose
class FocusView extends ConsumerStatefulWidget {
  const FocusView({super.key});

  @override
  ConsumerState<FocusView> createState() => _FocusViewState();
}

class _FocusViewState extends ConsumerState<FocusView>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final AnimationController _orbitCtrl;
  late final AnimationController _pulseCtrl;
  late final AnimationController _graceCtrl;

  /// idle 画面のフォーム値(送信前の一時的なビュー状態。真実は start() 引数)。
  late Duration _pickedDuration;
  SyncMode _pickedSyncMode = SyncMode.solo;

  /// claimReward() の在飛行フラグ(二重タップ抑止。べき等性の真実は台帳側)。
  bool _claiming = false;

  static const List<Duration> _presetDurations = [
    // E2E/動作確認用の最短プリセット(P3-T2)。releaseビルドには現れない。
    if (kDebugMode) Duration(minutes: 1),
    Duration(minutes: 15),
    Duration(minutes: 25),
    Duration(minutes: 45),
    Duration(minutes: 60),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _pickedDuration = UserSettings.defaults().defaultSessionDuration;
    _orbitCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 12))
          ..repeat();
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _graceCtrl = AnimationController(vsync: this, duration: Duration.zero);
  }

  @override
  void dispose() {
    // 生成の逆順で破棄
    _graceCtrl.dispose();
    _pulseCtrl.dispose();
    _orbitCtrl.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// D3: バックグラウンド遷移は systemInterrupted としてフックする。
  /// (inactive は通知シェード等でも発火するため paused のみを中断とみなす)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      ref.read(sessionControllerProvider.notifier).onAppBackgrounded();
    }
  }

  /// フェーズ変化に伴う「表示用アニメーション」の起動/停止。状態は変更しない。
  void _onPhaseChanged(SessionPhase? prev, SessionPhase next) {
    final wasWarning = prev is Warning;
    final isWarning = next is Warning;
    if (isWarning && !wasWarning) {
      _graceCtrl.duration = ref.read(gracePeriodProvider);
      _graceCtrl.forward(from: 0);
      _pulseCtrl.repeat(reverse: true);
    } else if (!isWarning && wasWarning) {
      _graceCtrl.stop();
      _graceCtrl.value = 0;
      _pulseCtrl.stop();
      _pulseCtrl.value = 0;
    }
  }

  // ---- イベント発火(全てコントローラへ委譲) --------------------------------

  void _onStartPressed() {
    ref.read(sessionControllerProvider.notifier).start(
          duration: _pickedDuration,
          motifId: ref.read(selectedMotifProvider),
          syncMode: _pickedSyncMode,
        );
  }

  Future<void> _onCancelPressed() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: FoPalette.surface,
        title: const Text('セッションを中断しますか?',
            style: TextStyle(color: FoPalette.text, fontSize: 18)),
        content: const Text('中断するとこのセッションの報酬は得られません。',
            style: TextStyle(color: FoPalette.textDim)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('続ける', style: TextStyle(color: FoPalette.text)),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child:
                const Text('中断する', style: TextStyle(color: FoPalette.danger)),
          ),
        ],
      ),
    );
    if (!mounted) return; // await後ガード(必須)
    if (confirmed ?? false) {
      ref.read(sessionControllerProvider.notifier).cancel();
    }
  }

  Future<void> _onClaimPressed() async {
    if (_claiming) return;
    setState(() => _claiming = true);
    final outcome =
        await ref.read(sessionControllerProvider.notifier).claimReward();
    if (!mounted) return; // await後ガード(必須)
    setState(() => _claiming = false);
    final message = switch (outcome) {
      ClaimOutcome.granted => 'コインを受け取りました',
      ClaimOutcome.notClaimable => null, // レース吸収済み(D16)。表示不要
      ClaimOutcome.failedRetryable => '保存に失敗しました。もう一度お試しください(コインは失われません)',
    };
    if (message != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  void _onAcknowledgePressed() {
    ref.read(sessionControllerProvider.notifier).acknowledgeAbort();
  }

  void _onToggleViewPressed() {
    final ok = ref.read(viewModeControllerProvider.notifier).toggle();
    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('宇宙ビューはセッション中のみ開けます')),
      );
    }
  }

  // ---- build ---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    ref.listen<SessionPhase>(
      sessionControllerProvider.select((s) => s.phase),
      _onPhaseChanged,
    );

    final session = ref.watch(sessionControllerProvider);
    final viewMode = ref.watch(viewModeControllerProvider);
    final phase = session.phase;

    // D11: 未知ID(データとアプリ版の不整合)は水へフォールバック
    final MotifSkin motif =
        MotifCatalog.byId(session.motifId) ?? const WaterMotif();
    final RenderParams rp = motif.renderParams;

    final isActive = phase is Running || phase is Warning;
    final showOrbit = viewMode == ViewMode.orbit && isActive;

    return Scaffold(
      backgroundColor: FoPalette.ink,
      // P3-T1b: ショップ導線は idle のときだけ表示する(集中中は消える)。
      // ロジックゼロ: 遷移イベントの発火のみ(層規則)。
      appBar: phase is Idle
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                  tooltip: 'ショップ',
                  icon: const Icon(Icons.storefront_outlined,
                      color: FoPalette.textDim),
                  onPressed: () =>
                      Navigator.of(context).pushNamed(ShopView.routeName),
                ),
              ],
            )
          : null,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: showOrbit
            ? const OrbitView(key: ValueKey('orbit'))
            : SafeArea(
                key: const ValueKey('focus'),
                child: switch (phase) {
                  Idle() => _IdleBody(
                      motif: motif,
                      pickedDuration: _pickedDuration,
                      presetDurations: _presetDurations,
                      pickedSyncMode: _pickedSyncMode,
                      onDurationPicked: (d) =>
                          setState(() => _pickedDuration = d),
                      onSyncModePicked: (m) =>
                          setState(() => _pickedSyncMode = m),
                      onStart: _onStartPressed,
                    ),
                  Running() => _ActiveBody(
                      session: session,
                      renderParams: rp,
                      isWarning: false,
                      orbit: _orbitCtrl,
                      pulse: _pulseCtrl,
                      grace: _graceCtrl,
                      onCancel: _onCancelPressed,
                      onToggleView: _onToggleViewPressed,
                    ),
                  Warning() => _ActiveBody(
                      session: session,
                      renderParams: rp,
                      isWarning: true,
                      orbit: _orbitCtrl,
                      pulse: _pulseCtrl,
                      grace: _graceCtrl,
                      onCancel: _onCancelPressed,
                      onToggleView: _onToggleViewPressed,
                    ),
                  Completed(:final rewardCoins) => _CompletedBody(
                      rewardCoins: rewardCoins,
                      renderParams: rp,
                      claiming: _claiming,
                      onClaim: _onClaimPressed,
                    ),
                  Aborted(:final reason) => _AbortedBody(
                      reason: reason,
                      onAcknowledge: _onAcknowledgePressed,
                    ),
                },
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// idle: セッション設計(時間・モード)と開始
// ---------------------------------------------------------------------------

class _IdleBody extends StatelessWidget {
  const _IdleBody({
    required this.motif,
    required this.pickedDuration,
    required this.presetDurations,
    required this.pickedSyncMode,
    required this.onDurationPicked,
    required this.onSyncModePicked,
    required this.onStart,
  });

  final MotifSkin motif;
  final Duration pickedDuration;
  final List<Duration> presetDurations;
  final SyncMode pickedSyncMode;
  final ValueChanged<Duration> onDurationPicked;
  final ValueChanged<SyncMode> onSyncModePicked;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    final rp = motif.renderParams;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FoSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: FoSpace.xl),
          const Text(
            'FOCUS ORBIT',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: FoPalette.textDim,
              fontSize: 12,
              letterSpacing: 6,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          // 装備中モチーフの静かなプレビュー(色はドメイン値そのもの)
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    rp.secondaryColor.withValues(alpha: 0.9),
                    rp.primaryColor,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: rp.primaryColor
                        .withValues(alpha: 0.35 * rp.ambientGlow + 0.15),
                    blurRadius: 48,
                    spreadRadius: 8,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: FoSpace.lg),
          Center(
            child: Text(
              _formatDuration(pickedDuration),
              style: const TextStyle(
                color: FoPalette.text,
                fontSize: 56,
                fontWeight: FontWeight.w200,
                fontFeatures: foTabularFigures,
                letterSpacing: -1,
              ),
            ),
          ),
          const SizedBox(height: FoSpace.md),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: FoSpace.sm,
            children: [
              for (final d in presetDurations)
                _DurationChip(
                  duration: d,
                  selected: d == pickedDuration,
                  accent: rp.primaryColor,
                  onTap: () => onDurationPicked(d),
                ),
            ],
          ),
          const SizedBox(height: FoSpace.lg),
          _SyncModeSelector(
            picked: pickedSyncMode,
            accent: rp.primaryColor,
            onPicked: onSyncModePicked,
          ),
          const Spacer(),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: rp.primaryColor,
              foregroundColor: FoPalette.ink,
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            onPressed: onStart,
            child: const Text(
              '集中をはじめる',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: FoSpace.sm),
          const Text(
            '端末を画面を上にして置くと計測がはじまります',
            textAlign: TextAlign.center,
            style: TextStyle(color: FoPalette.textDim, fontSize: 12),
          ),
          const SizedBox(height: FoSpace.lg),
        ],
      ),
    );
  }
}

class _DurationChip extends StatelessWidget {
  const _DurationChip({
    required this.duration,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final Duration duration;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: FoSpace.md, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? accent.withValues(alpha: 0.18)
              : FoPalette.surfaceHigh,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? accent : FoPalette.hairline,
          ),
        ),
        child: Text(
          '${duration.inMinutes}分',
          style: TextStyle(
            color: selected ? FoPalette.text : FoPalette.textDim,
            fontSize: 14,
            fontFeatures: foTabularFigures,
          ),
        ),
      ),
    );
  }
}

class _SyncModeSelector extends StatelessWidget {
  const _SyncModeSelector({
    required this.picked,
    required this.accent,
    required this.onPicked,
  });

  final SyncMode picked;
  final Color accent;
  final ValueChanged<SyncMode> onPicked;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FoPalette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: FoPalette.hairline),
      ),
      padding: const EdgeInsets.all(FoSpace.xs),
      child: Row(
        children: [
          Expanded(
            child: _SyncModeOption(
              label: 'ひとりで',
              caption: 'この端末だけで完結',
              selected: picked == SyncMode.solo,
              accent: accent,
              onTap: () => onPicked(SyncMode.solo),
            ),
          ),
          Expanded(
            child: _SyncModeOption(
              label: 'みんなで',
              caption: '同じモチーフの部屋に参加',
              selected: picked == SyncMode.multi,
              accent: accent,
              onTap: () => onPicked(SyncMode.multi),
            ),
          ),
        ],
      ),
    );
  }
}

class _SyncModeOption extends StatelessWidget {
  const _SyncModeOption({
    required this.label,
    required this.caption,
    required this.selected,
    required this.accent,
    required this.onTap,
  });

  final String label;
  final String caption;
  final bool selected;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
            vertical: FoSpace.sm + 4, horizontal: FoSpace.sm),
        decoration: BoxDecoration(
          color: selected ? accent.withValues(alpha: 0.14) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(label,
                style: TextStyle(
                  color: selected ? FoPalette.text : FoPalette.textDim,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                )),
            const SizedBox(height: 2),
            Text(caption,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(color: FoPalette.textDim, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// running / warning: 軌道リングタイマー(このアプリのシグネチャ)
// ---------------------------------------------------------------------------

class _ActiveBody extends StatelessWidget {
  const _ActiveBody({
    required this.session,
    required this.renderParams,
    required this.isWarning,
    required this.orbit,
    required this.pulse,
    required this.grace,
    required this.onCancel,
    required this.onToggleView,
  });

  final FocusSession session;
  final RenderParams renderParams;
  final bool isWarning;
  final AnimationController orbit;
  final AnimationController pulse;
  final AnimationController grace;
  final VoidCallback onCancel;
  final VoidCallback onToggleView;

  @override
  Widget build(BuildContext context) {
    final remaining = session.plannedDuration - session.elapsed;
    final clamped = remaining.isNegative ? Duration.zero : remaining;
    final progress = session.plannedDuration == Duration.zero
        ? 0.0
        : (session.elapsed.inSeconds / session.plannedDuration.inSeconds)
            .clamp(0.0, 1.0);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: FoSpace.md, vertical: FoSpace.sm),
          child: Row(
            children: [
              _StatusLabel(isWarning: isWarning, pulse: pulse),
              const Spacer(),
              IconButton(
                tooltip: '宇宙ビューへ',
                onPressed: onToggleView,
                icon: const Icon(Icons.public, color: FoPalette.textDim),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([orbit, pulse]),
              builder: (context, _) => CustomPaint(
                size: const Size.square(300),
                painter: _OrbitRingPainter(
                  progress: progress,
                  t: orbit.value,
                  renderParams: renderParams,
                  warningIntensity: isWarning ? pulse.value : 0.0,
                ),
                child: SizedBox.square(
                  dimension: 300,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatDuration(clamped),
                          style: const TextStyle(
                            color: FoPalette.text,
                            fontSize: 64,
                            fontWeight: FontWeight.w200,
                            fontFeatures: foTabularFigures,
                            letterSpacing: -2,
                          ),
                        ),
                        Text(
                          '目標 ${session.plannedDuration.inMinutes}分',
                          style: const TextStyle(
                              color: FoPalette.textDim, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // warning のときだけ猶予バーが降りてくる
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isWarning
              ? Padding(
                  key: const ValueKey('grace'),
                  padding:
                      const EdgeInsets.symmetric(horizontal: FoSpace.lg),
                  child: Column(
                    children: [
                      const Text(
                        '振動を検知しました。端末を静かに戻してください',
                        style: TextStyle(
                            color: FoPalette.caution, fontSize: 13),
                      ),
                      const SizedBox(height: FoSpace.sm),
                      AnimatedBuilder(
                        animation: grace,
                        builder: (context, _) => ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (1 - grace.value).clamp(0.0, 1.0),
                            minHeight: 6,
                            backgroundColor: FoPalette.surfaceHigh,
                            color: FoPalette.caution,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(key: ValueKey('no-grace'), height: 0),
        ),
        Padding(
          padding: const EdgeInsets.all(FoSpace.lg),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: FoPalette.textDim,
              side: const BorderSide(color: FoPalette.hairline),
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            onPressed: onCancel,
            child: const Text('中断する'),
          ),
        ),
      ],
    );
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.isWarning, required this.pulse});

  final bool isWarning;
  final AnimationController pulse;

  @override
  Widget build(BuildContext context) {
    if (!isWarning) {
      return const Text(
        '集中モード',
        style: TextStyle(
            color: FoPalette.textDim, fontSize: 12, letterSpacing: 2),
      );
    }
    return AnimatedBuilder(
      animation: pulse,
      builder: (context, _) => Opacity(
        opacity: 0.55 + 0.45 * pulse.value,
        child: const Text(
          '警告 — 猶予中',
          style: TextStyle(
              color: FoPalette.caution, fontSize: 12, letterSpacing: 2),
        ),
      ),
    );
  }
}

/// シグネチャ描画: 進捗リングの粒子数・回転速度・光量が
/// domain の RenderParams(particleDensity / flowSpeed / ambientGlow)そのもの。
class _OrbitRingPainter extends CustomPainter {
  const _OrbitRingPainter({
    required this.progress,
    required this.t,
    required this.renderParams,
    required this.warningIntensity,
  });

  final double progress;

  /// 0..1 を繰り返す時間位相
  final double t;
  final RenderParams renderParams;

  /// 0(通常) 〜 1(warning 点滅ピーク)
  final double warningIntensity;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - 14;
    final primary = renderParams.primaryColor;
    final secondary = renderParams.secondaryColor;
    final warned =
        Color.lerp(primary, FoPalette.caution, warningIntensity) ?? primary;

    // 外周のアンビエントグロー
    final glowPaint = Paint()
      ..color = warned.withValues(alpha: 0.25 * renderParams.ambientGlow)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24);
    canvas.drawCircle(center, radius, glowPaint);

    // 下地トラック
    final trackPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = FoPalette.surfaceHigh;
    canvas.drawCircle(center, radius, trackPaint);

    // 進捗アーク(12時起点)
    final arcPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [secondary, warned],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      arcPaint,
    );

    // 軌道粒子: 数 = particleDensity、公転速度 = flowSpeed
    final particleCount = (6 + renderParams.particleDensity * 18).round();
    final baseAngle = 2 * math.pi * t * renderParams.flowSpeed;
    for (var i = 0; i < particleCount; i++) {
      final angle = baseAngle + (2 * math.pi * i / particleCount);
      final wobble =
          math.sin(angle * 3 + t * 2 * math.pi) * 6 * renderParams.flowSpeed;
      final r = radius + 10 + wobble;
      final pos =
          center + Offset(math.cos(angle), math.sin(angle)) * r;
      final particlePaint = Paint()
        ..color = secondary.withValues(
            alpha: 0.25 + 0.5 * ((i % 3) / 2))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.5);
      canvas.drawCircle(pos, 1.6 + (i % 3) * 0.8, particlePaint);
    }
  }

  @override
  bool shouldRepaint(_OrbitRingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.t != t ||
      oldDelegate.warningIntensity != warningIntensity ||
      oldDelegate.renderParams != renderParams;
}

// ---------------------------------------------------------------------------
// completed: 報酬受け取り(D16: 失敗してもコインは失われない)
// ---------------------------------------------------------------------------

class _CompletedBody extends StatelessWidget {
  const _CompletedBody({
    required this.rewardCoins,
    required this.renderParams,
    required this.claiming,
    required this.onClaim,
  });

  final int rewardCoins;
  final RenderParams renderParams;
  final bool claiming;
  final VoidCallback onClaim;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FoSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          const Icon(Icons.check_circle_outline,
              size: 72, color: FoPalette.reward),
          const SizedBox(height: FoSpace.lg),
          const Text(
            '集中を完了しました',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: FoPalette.text,
                fontSize: 22,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: FoSpace.sm),
          Text(
            '報酬 $rewardCoins コイン',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: FoPalette.reward,
              fontSize: 16,
              fontFeatures: foTabularFigures,
            ),
          ),
          const Spacer(),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: renderParams.primaryColor,
              foregroundColor: FoPalette.ink,
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            onPressed: claiming ? null : onClaim,
            child: claiming
                ? const SizedBox.square(
                    dimension: 22,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('コインを受け取る',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: FoSpace.lg),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// aborted: 理由の提示と了承(理由の網羅は enum switch で強制)
// ---------------------------------------------------------------------------

class _AbortedBody extends StatelessWidget {
  const _AbortedBody({required this.reason, required this.onAcknowledge});

  final AbortReason reason;
  final VoidCallback onAcknowledge;

  String get _reasonText => switch (reason) {
        AbortReason.pickedUp => '端末が持ち上げられたため中断しました',
        AbortReason.graceTimeout => '振動がおさまらなかったため中断しました',
        AbortReason.userCancelled => 'セッションを中断しました',
        AbortReason.systemInterrupted => 'アプリが中断されたためセッションを終了しました',
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FoSpace.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          const Icon(Icons.nightlight_outlined,
              size: 64, color: FoPalette.textDim),
          const SizedBox(height: FoSpace.lg),
          Text(
            _reasonText,
            textAlign: TextAlign.center,
            style: const TextStyle(color: FoPalette.text, fontSize: 18),
          ),
          const SizedBox(height: FoSpace.sm),
          const Text(
            '深呼吸して、もう一度はじめましょう',
            textAlign: TextAlign.center,
            style: TextStyle(color: FoPalette.textDim, fontSize: 13),
          ),
          const Spacer(),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: FoPalette.text,
              side: const BorderSide(color: FoPalette.hairline),
              minimumSize: const Size.fromHeight(56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            onPressed: onAcknowledge,
            child: const Text('OK'),
          ),
          const SizedBox(height: FoSpace.lg),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

String _formatDuration(Duration d) {
  final clamped = d.isNegative ? Duration.zero : d;
  final minutes = clamped.inMinutes.toString().padLeft(2, '0');
  final seconds = (clamped.inSeconds % 60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
