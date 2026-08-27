abstract class TrackingEvent {
  const TrackingEvent();
}

class FetchTrackingStatusEvent extends TrackingEvent {
  final String requestId;
  const FetchTrackingStatusEvent(this.requestId);
}
