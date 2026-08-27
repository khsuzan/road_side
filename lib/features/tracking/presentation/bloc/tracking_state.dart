import '../../domain/entities/tracking_status_entity.dart';

abstract class TrackingState {
  const TrackingState();
}

class TrackingInitial extends TrackingState {
  const TrackingInitial();
}

class TrackingLoading extends TrackingState {
  const TrackingLoading();
}

class TrackingSuccess extends TrackingState {
  final TrackingStatusEntity status;
  const TrackingSuccess(this.status);
}

class TrackingFailure extends TrackingState {
  final String message;
  const TrackingFailure(this.message);
}
