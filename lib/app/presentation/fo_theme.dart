import 'package:flutter/material.dart';

import 'package:focus_orbit/features/motif/domain/render_params.dart';

/// Focus Orbit デザイントークン。
/// 方針: ベースは深宇宙の無彩色に近い暗色のみ。アクセント色はここに置かず、
/// 選択中モチーフの [RenderParams] から動的に取る(= モチーフが画面の色を支配する)。
abstract final class FoPalette {
  /// 最深部の背景(深宇宙インク)
  static const Color ink = Color(0xFF070B15);

  /// 一段浮いた面(カード・シート)
  static const Color surface = Color(0xFF10182B);

  /// さらに浮いた面(チップ・入力)
  static const Color surfaceHigh = Color(0xFF182238);

  /// 髪の毛ほどの境界線
  static const Color hairline = Color(0x14FFFFFF);

  /// 主文字色
  static const Color text = Color(0xFFE9EDF5);

  /// 補助文字色
  static const Color textDim = Color(0xFF97A0B5);

  /// 警告(warning フェーズ・猶予)
  static const Color caution = Color(0xFFF0B35C);

  /// 破壊的操作・中断
  static const Color danger = Color(0xFFE2685B);

  /// 成功・報酬
  static const Color reward = Color(0xFFF2C94C);
}

abstract final class FoSpace {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 40;
}

/// D5準拠の橋渡し: domain は ARGB int のみを持ち、Color 化は UI 層のここで行う。
extension RenderParamsColorX on RenderParams {
  Color get primaryColor => Color(primaryColorArgb);
  Color get secondaryColor => Color(secondaryColorArgb);
}

/// タイマー等の数値表示で桁揺れを防ぐ等幅数字。
const List<FontFeature> foTabularFigures = [FontFeature.tabularFigures()];

/// アプリ全体のテーマ(Phase 1 の main 結線時に MaterialApp.theme へ渡す)。
ThemeData buildFocusOrbitTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF2E86C1), // 初期解放モチーフ「水」の primary と同系
    brightness: Brightness.dark,
    surface: FoPalette.ink,
  );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: FoPalette.ink,
    splashFactory: InkSparkle.splashFactory,
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: FoPalette.surfaceHigh,
      contentTextStyle: TextStyle(color: FoPalette.text),
      behavior: SnackBarBehavior.floating,
    ),
    dividerTheme: const DividerThemeData(color: FoPalette.hairline, space: 1),
  );
}
