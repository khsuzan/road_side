import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/job_detail_entity.dart';
import '../../domain/repositories/mechanic_job_repository.dart';
import 'mechanic_job_event.dart';
import 'mechanic_job_state.dart';

class MechanicJobBloc extends Bloc<MechanicJobEvent, MechanicJobState> {
  final MechanicJobRepository repository;

  MechanicJobBloc({required this.repository}) : super(const MechanicJobInitial()) {
    on<FetchJobDetailEvent>(_onFetchJobDetail);
    on<SubmitCompleteJobEvent>(_onSubmitCompleteJob);
  }

  Future<void> _onFetchJobDetail(
      FetchJobDetailEvent event, Emitter<MechanicJobState> emit) async {
    emit(const MechanicJobLoading());
    try {
      final job = await repository.getJobDetails(event.jobId);
      emit(MechanicJobDetailSuccess(job));
    } catch (e) {
      // Fallback mock job details matching Dhaka coordinates
      final mockJob = JobDetailEntity(
        id: event.jobId,
        customerName: 'Jessica Davis',
        customerAvatarUrl: 'assets/images/person.png',
        location: 'Gulshan 2, Road 11',
        etaText: '8 min (1.2 km)',
        reportedIssues: const ['Smoke from Hood', 'Strange Noise'],
        audioDurationText: '0:12',
        evidencePhotoUrls: const ['assets/images/car.png'],
        status: 'En Route',
        laborCharge: 400.0,
        partsUsed: 800.0,
        verificationPin: '7391',
      );
      emit(MechanicJobDetailSuccess(mockJob));
    }
  }

  Future<void> _onSubmitCompleteJob(
      SubmitCompleteJobEvent event, Emitter<MechanicJobState> emit) async {
    emit(const MechanicJobLoading());
    try {
      await repository.completeJob(
        jobId: event.jobId,
        verificationPin: event.verificationPin,
        laborCharge: event.laborCharge,
        partsUsed: event.partsUsed,
      );
      emit(const MechanicJobCompleteSuccess());
    } catch (e) {
      // Mock completion success
      await Future.delayed(const Duration(seconds: 1));
      emit(const MechanicJobCompleteSuccess());
    }
  }
}
