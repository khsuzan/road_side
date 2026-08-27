import '../../domain/entities/tracking_status_entity.dart';
import '../../domain/repositories/tracking_repository.dart';
import '../datasources/tracking_remote_data_source.dart';
import '../../../../core/network/error_handler.dart';

class TrackingRepositoryImpl implements TrackingRepository {
  final TrackingRemoteDataSource remoteDataSource;

  TrackingRepositoryImpl({required this.remoteDataSource});

  @override
  Future<TrackingStatusEntity> getTrackingStatus(String requestId) async {
    try {
      return await remoteDataSource.getTrackingStatus(requestId);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
