import 'package:flutter/material.dart';

import 'package:focus_orbit/app/presentation/fo_theme.dart';
import 'package:focus_orbit/features/economy/presentation/shop_view.dart';
import 'package:focus_orbit/features/session/presentation/focus_view.dart';

/// ルートウィジェット(§13 DI図の終端ノード)。
/// 実装型を一切知らない — 依存は provider ツリー経由でのみ解決される。
/// ロジックゼロ(mobile-frontend-core: widgets only read state and dispatch)。
class FocusOrbitApp extends StatelessWidget {
  const FocusOrbitApp({super.key});

  /// ShopView への app 内ルート名。
  /// 導線UI(idle 画面からの遷移ボタン)は P3-T1b で
  /// `Navigator.pushNamed(context, FocusOrbitApp.shopRoute)` を呼ぶ。
  static const String shopRoute = ShopView.routeName;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focus Orbit',
      theme: buildFocusOrbitTheme(),
      debugShowCheckedModeBanner: false,
      home: const FocusView(),
      routes: <String, WidgetBuilder>{
        shopRoute: (_) => const ShopView(),
      },
    );
  }
}
