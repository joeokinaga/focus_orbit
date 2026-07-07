import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:focus_orbit/core/domain/app_failure.dart';

part 'presence_connection_state.freezed.dart';

/// T0の4状態が正。
@freezed
sealed class PresenceConnectionState with _$PresenceConnectionState {
  const factory PresenceConnectionState.connected() = Connected;
  const factory PresenceConnectionState.reconnecting() = Reconnecting;

  /// D4改: 選択的ソロとデグレードの両方を表す「ローカル完結動作中」。
  /// どちらであるかの区別はSyncModeで行う。
  const factory PresenceConnectionState.soloFallback() = SoloFallback;
  const factory PresenceConnectionState.disconnected() = Disconnected;
}

sealed class PresenceFailure implements AppFailure {
  const PresenceFailure();
}

final class PresenceNetworkUnavailable extends PresenceFailure {
  const PresenceNetworkUnavailable();
}

final class PresenceUnauthorized extends PresenceFailure {
  const PresenceUnauthorized();
}

final class PresenceServiceError extends PresenceFailure {
  /// SKILL-14: 障害追跡のためproviderのrequest-idを保持(トークン等は保持しない)
  const PresenceServiceError(this.requestId);
  final String? requestId;
}
