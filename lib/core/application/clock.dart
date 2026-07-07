import 'package:flutter_riverpod/flutter_riverpod.dart';

/// D20: 時刻はここからのみ取得(テスト決定性)。
/// domain層は時刻を「受け取る」だけで自ら参照しない(T3のStanceDetectorと同方針)。
final clockProvider = Provider<DateTime Function()>(
  (_) => () => DateTime.now().toUtc(),
);
