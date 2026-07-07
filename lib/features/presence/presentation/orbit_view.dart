import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:focus_orbit/app/presentation/fo_theme.dart';
import 'package:focus_orbit/core/application/clock.dart';
import 'package:focus_orbit/core/domain/ids.dart';
import 'package:focus_orbit/features/motif/domain/motif_catalog.dart';
import 'package:focus_orbit/features/motif/domain/motifs/water_motif.dart';
import 'package:focus_orbit/features/motif/domain/render_params.dart';
import 'package:focus_orbit/features/presence/application/presence_providers.dart';
import 'package:focus_orbit/features/presence/domain/presence_connection_state.dart';
import 'package:focus_orbit/features/presence/domain/room_presence.dart';
import 'package:focus_orbit/features/session/application/session_controller.dart';
import 'package:focus_orbit/features/session/application/view_mode_controller.dart';

/// 画面2: Orbit View(宇宙 — 同じモチーフの部屋にいる他ユーザーとの同期表示)。
///
/// 【層規則】presence の真実は RemoteRoomRepository(契約 §6)と
/// presence_providers にある。本画面は AsyncValue と 4つの接続状態を
/// 描画するだけで、再接続やハートビートには一切関与しない。
///
/// 【ライフサイクル監査】生成/破棄ペア:
///   _driftCtrl(星と公転のゆっくりした時間位相): initState / dispose
class OrbitView extends ConsumerStatefulWidget {
  const OrbitView({super.key});

  @override
  ConsumerState<OrbitView> createState() => _OrbitViewState();
}

class _OrbitViewState extends ConsumerState<OrbitView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _driftCtrl;

  @override
  void initState() {
    super.initState();
    _driftCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 60))
          ..repeat();
  }

  @override
  void dispose() {
    _driftCtrl.dispose();
    super.dispose();
  }

  void _onBackToFocus() {
    final ok = ref.read(viewModeControllerProvider.notifier).toggle();
    if (!ok) {
      // D2: 非アクティブでは切替不可(FocusView側が自動でフォーカス表示に戻るため
      // 実際にここへ到達するのは競合の一瞬のみ)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('セッションが終了したため集中画面に戻ります')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionControllerProvider);
    // D19: 部屋 = モチーフ。roomId は UI が motifId から導出して渡す。
    final roomId = RoomId(session.motifId.value);
    final motif = MotifCatalog.byId(session.motifId) ?? const WaterMotif();
    final rp = motif.renderParams;

    final connectionAsync = ref.watch(presenceConnectionProvider);
    final presenceAsync = ref.watch(roomPresenceProvider(roomId));

    final remaining = session.plannedDuration - session.elapsed;

    return ColoredBox(
      color: FoPalette.ink,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: FoSpace.md, vertical: FoSpace.sm),
              child: Row(
                children: [
                  IconButton(
                    tooltip: '集中画面へ戻る',
                    onPressed: _onBackToFocus,
                    icon: const Icon(Icons.arrow_back,
                        color: FoPalette.textDim),
                  ),
                  const Spacer(),
                  Text(
                    _formatDuration(remaining),
                    style: const TextStyle(
                      color: FoPalette.text,
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      fontFeatures: foTabularFigures,
                    ),
                  ),
                  const SizedBox(width: FoSpace.md),
                ],
              ),
            ),
            _ConnectionBanner(connection: connectionAsync),
            Expanded(
              child: switch (presenceAsync) {
                AsyncData(:final value) => _GalaxyBody(
                    presence: value,
                    renderParams: rp,
                    drift: _driftCtrl,
                    now: ref.read(clockProvider)(),
                  ),
                AsyncError() => _PresenceErrorBody(
                    onRetry: () =>
                        ref.invalidate(roomPresenceProvider(roomId)),
                  ),
                AsyncLoading() => const _PresenceLoadingBody(),
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 接続状態バナー(4状態を exhaustive switch で網羅 — default なし)
// ---------------------------------------------------------------------------

class _ConnectionBanner extends StatelessWidget {
  const _ConnectionBanner({required this.connection});

  final AsyncValue<PresenceConnectionState> connection;

  @override
  Widget build(BuildContext context) {
    final (String? label, Color color) = switch (connection) {
      AsyncData(:final value) => switch (value) {
          Connected() => (null, Colors.transparent), // 正常時は沈黙
          Reconnecting() => ('再接続しています…', FoPalette.caution),
          SoloFallback() => ('オフラインのためひとりモードで継続中', FoPalette.textDim),
          Disconnected() => ('部屋との接続が切れています', FoPalette.danger),
        },
      AsyncError() => ('接続状態を取得できません', FoPalette.danger),
      AsyncLoading() => ('接続しています…', FoPalette.textDim),
    };

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: label == null
          ? const SizedBox(key: ValueKey('banner-none'), height: 0)
          : Container(
              key: ValueKey('banner-$label'),
              width: double.infinity,
              margin:
                  const EdgeInsets.symmetric(horizontal: FoSpace.md),
              padding: const EdgeInsets.symmetric(
                  horizontal: FoSpace.md, vertical: FoSpace.sm),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: color.withValues(alpha: 0.4)),
              ),
              child: Text(
                label,
                style: TextStyle(color: color, fontSize: 12),
              ),
            ),
    );
  }
}

// ---------------------------------------------------------------------------
// presence データ本体: 星空 + 公転する滞在者
// ---------------------------------------------------------------------------

class _GalaxyBody extends StatelessWidget {
  const _GalaxyBody({
    required this.presence,
    required this.renderParams,
    required this.drift,
    required this.now,
  });

  final RoomPresence presence;
  final RenderParams renderParams;
  final AnimationController drift;
  final DateTime now;

  bool get _alone => presence.occupantCount <= 1;

  String get _freshnessText {
    final age = now.difference(presence.asOf);
    if (age.inSeconds < 10) return 'たった今';
    if (age.inMinutes < 1) return '${age.inSeconds}秒前';
    return '${age.inMinutes}分前';
  }

  @override
  Widget build(BuildContext context) {
    final others = presence.occupantCount - 1;
    final othersClamped = others < 0 ? 0 : others;

    return Column(
      children: [
        Expanded(
          child: AnimatedBuilder(
            animation: drift,
            builder: (context, _) => CustomPaint(
              size: Size.infinite,
              painter: _GalaxyPainter(
                t: drift.value,
                renderParams: renderParams,
                occupantCount: presence.occupantCount,
                activeCount: presence.activeCount,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(FoSpace.lg),
          child: Column(
            children: [
              if (_alone)
                const Text(
                  'いまはあなただけの宇宙です',
                  style: TextStyle(color: FoPalette.text, fontSize: 16),
                )
              else
                Text(
                  'あなたのほかに $othersClamped 人がこの部屋にいます',
                  style:
                      const TextStyle(color: FoPalette.text, fontSize: 16),
                ),
              const SizedBox(height: FoSpace.xs),
              Text(
                _alone
                    ? '静かな集中もまた良いものです'
                    : 'いま集中しているのは ${presence.activeCount} 人',
                style:
                    const TextStyle(color: FoPalette.textDim, fontSize: 13),
              ),
              const SizedBox(height: FoSpace.sm),
              Text(
                '更新: $_freshnessText',
                style:
                    const TextStyle(color: FoPalette.textDim, fontSize: 11),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 星空と滞在者の公転。輝いている軌道体 = activeCount、
/// 淡い軌道体 = 在室しているが非アクティブな人数。色はモチーフの支配下。
class _GalaxyPainter extends CustomPainter {
  const _GalaxyPainter({
    required this.t,
    required this.renderParams,
    required this.occupantCount,
    required this.activeCount,
  });

  /// 0..1 を繰り返す時間位相(60秒周期)
  final double t;
  final RenderParams renderParams;
  final int occupantCount;
  final int activeCount;

  static const int _starCount = 90;

  /// 描画上限(混雑した部屋でも破綻しない)。数字表示は上に任せる。
  static const int _maxDrawnOrbiters = 24;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final primary = renderParams.primaryColor;
    final secondary = renderParams.secondaryColor;

    // 星空(シード固定でフレーム間ちらつきなし。明滅は位相 t で表現)
    final rng = math.Random(7);
    for (var i = 0; i < _starCount; i++) {
      final pos = Offset(
        rng.nextDouble() * size.width,
        rng.nextDouble() * size.height,
      );
      final phase = rng.nextDouble();
      final twinkle =
          0.35 + 0.65 * (0.5 + 0.5 * math.sin(2 * math.pi * (t + phase)));
      final starPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.12 * twinkle + 0.03);
      canvas.drawCircle(pos, rng.nextDouble() * 1.2 + 0.4, starPaint);
    }

    // 中心 = あなた。アンビエントグローで存在感を出す。
    final selfGlow = Paint()
      ..color =
          primary.withValues(alpha: 0.3 * renderParams.ambientGlow + 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawCircle(center, 26, selfGlow);
    final selfPaint = Paint()
      ..shader = RadialGradient(colors: [secondary, primary]).createShader(
        Rect.fromCircle(center: center, radius: 12),
      );
    canvas.drawCircle(center, 12, selfPaint);

    // 他の滞在者を3本の軌道に配置。先頭 activeCount 人が「輝く」。
    final others = (occupantCount - 1).clamp(0, _maxDrawnOrbiters);
    final activeOthers = (activeCount - 1).clamp(0, others);
    final minSide = size.shortestSide;
    const ringRatios = [0.28, 0.38, 0.48];

    for (var i = 0; i < others; i++) {
      final ring = i % ringRatios.length;
      final radius = minSide * ringRatios[ring];
      // 軌道ごとに向きと速さを変える。速さはモチーフの flowSpeed に従う。
      final direction = ring.isEven ? 1 : -1;
      final speed = renderParams.flowSpeed * (1 + ring * 0.35);
      final angle = 2 * math.pi * (t * speed * direction) +
          (2 * math.pi * i / math.max(1, others)) +
          ring * 0.9;
      final pos =
          center + Offset(math.cos(angle), math.sin(angle)) * radius;

      final isActive = i < activeOthers;
      if (isActive) {
        final glow = Paint()
          ..color = secondary.withValues(alpha: 0.5)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
        canvas.drawCircle(pos, 7, glow);
        canvas.drawCircle(pos, 4.5, Paint()..color = secondary);
      } else {
        canvas.drawCircle(
          pos,
          3.5,
          Paint()..color = FoPalette.textDim.withValues(alpha: 0.5),
        );
      }
    }

    // 軌道線(薄く)
    final orbitPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.05);
    for (final ratio in ringRatios) {
      canvas.drawCircle(center, minSide * ratio, orbitPaint);
    }
  }

  @override
  bool shouldRepaint(_GalaxyPainter oldDelegate) =>
      oldDelegate.t != t ||
      oldDelegate.occupantCount != occupantCount ||
      oldDelegate.activeCount != activeCount ||
      oldDelegate.renderParams != renderParams;
}

// ---------------------------------------------------------------------------
// loading / error(4状態UIの残り2つ)
// ---------------------------------------------------------------------------

class _PresenceLoadingBody extends StatelessWidget {
  const _PresenceLoadingBody();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: 28,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: FoPalette.textDim),
          ),
          SizedBox(height: FoSpace.md),
          Text('部屋の様子を確かめています…',
              style: TextStyle(color: FoPalette.textDim, fontSize: 13)),
        ],
      ),
    );
  }
}

class _PresenceErrorBody extends StatelessWidget {
  const _PresenceErrorBody({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off_outlined,
              size: 48, color: FoPalette.textDim),
          const SizedBox(height: FoSpace.md),
          const Text(
            '部屋の情報を取得できませんでした',
            style: TextStyle(color: FoPalette.text, fontSize: 15),
          ),
          const SizedBox(height: FoSpace.xs),
          const Text(
            'セッションはこのまま続いています。ご安心ください',
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

String _formatDuration(Duration d) {
  final clamped = d.isNegative ? Duration.zero : d;
  final minutes = clamped.inMinutes.toString().padLeft(2, '0');
  final seconds = (clamped.inSeconds % 60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}
