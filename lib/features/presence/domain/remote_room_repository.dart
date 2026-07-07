import 'package:focus_orbit/core/domain/ids.dart';
import 'package:focus_orbit/core/domain/result.dart';
import 'package:focus_orbit/features/presence/domain/presence_connection_state.dart';
import 'package:focus_orbit/features/presence/domain/room_presence.dart';

/// リアルタイムpresenceの契約(T8)。実装: AppSync GraphQL Subscription(Phase 1) /
/// SoloRoomRepository(実装済み)。
/// 【契約】
/// - watch(): (1)listen直後に最新スナップショットを必ず1件流す
///            (2)再接続成功時もスナップショットを再取得して流す(AD-5条項:
///               オフライン中のsubscriptionメッセージは失われるため)
///            (3)エラーをStreamエラーとして流さない(障害はconnectionState側のデータ)
/// - 実装はjoin中の生存(ハートビート)を自動維持する
/// - joinはべき等(再joinは自メンバー行のupsert・二重カウントなし)
/// - 呼び出し側はPresenceFailureの型で分岐し、プロバイダ固有コードに依存しない
abstract interface class RemoteRoomRepository {
  Future<Result<void, PresenceFailure>> join(RoomId roomId);

  /// べき等・best-effort(T8エッジ#4: 不達はサーバ側TTLが後ろ盾)
  Future<void> leave();

  Stream<RoomPresence> watch(RoomId roomId);

  Stream<PresenceConnectionState> connectionState();

  /// join前はno-op
  Future<void> reportActive(bool isActive);

  Future<void> dispose();
}
