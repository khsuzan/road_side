import '../entities/tracking_status_entity.dart';

abstract class TrackingRepository {
  Future<TrackingStatusEntity> getTrackingStatus(String requestId);
}
