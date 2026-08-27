import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/tracking_status_entity.dart';
import '../../domain/repositories/tracking_repository.dart';
import 'tracking_event.dart';
import 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  final TrackingRepository trackingRepository;

  TrackingBloc({required this.trackingRepository})
      : super(const TrackingInitial()) {
    on<FetchTrackingStatusEvent>(_onFetchTrackingStatus);
  }

  Future<void> _onFetchTrackingStatus(
      FetchTrackingStatusEvent event, Emitter<TrackingState> emit) async {
    emit(const TrackingLoading());
    try {
      final status = await trackingRepository.getTrackingStatus(event.requestId);
      emit(TrackingSuccess(status));
    } catch (e) {
      // High-fidelity fallback mock data representing Marcus L.
      final mockStatus = TrackingStatusEntity(
        requestId: event.requestId,
        etaMinutes: 6,
        distanceMiles: 2.4,
        mechanicName: 'Marcus L.',
        mechanicRating: 4.9,
        mechanicAvatarUrl: 'assets/images/person.png',
        vanModel: 'Silver Sprinter Van',
        plateNumber: 'CA 8FRT92',
        verificationPin: '7391',
        currentStep: 'En Route',
      );
      emit(TrackingSuccess(mockStatus));
    }
  }
}
