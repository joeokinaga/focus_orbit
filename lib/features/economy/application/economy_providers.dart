import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:focus_orbit/features/economy/domain/economy_ledger.dart';
import 'package:focus_orbit/features/economy/domain/local_preferences_repository.dart';

/// data実装(Phase 1: DriftPreferencesRepository)をapp/di.dartで束縛する。
final localPreferencesRepositoryProvider = Provider<LocalPreferencesRepository>(
  (_) => throw UnimplementedError('app/di.dart の buildOverrides で束縛してください'),
);

/// ショップ/残高表示のリアクティブ購読(AD-3のdrift watchに委譲)。
/// AsyncValueがloading/errorを、dataが本体を表す。
/// 「空」はEconomyState.initial()(残高0・水のみ解放)としてdata内で表現される。
final economyStateProvider = StreamProvider<EconomyState>(
  (ref) => ref.watch(localPreferencesRepositoryProvider).watchEconomyState(),
);
