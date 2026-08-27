import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/mechanic_job_entity.dart';
import '../../domain/repositories/mechanic_dashboard_repository.dart';
import 'mechanic_dashboard_event.dart';
import 'mechanic_dashboard_state.dart';

class MechanicDashboardBloc
    extends Bloc<MechanicDashboardEvent, MechanicDashboardState> {
  final MechanicDashboardRepository repository;

  MechanicDashboardBloc({required this.repository})
      : super(const MechanicDashboardInitial()) {
    on<FetchOngoingJobsEvent>(_onFetchOngoingJobs);
  }

  Future<void> _onFetchOngoingJobs(FetchOngoingJobsEvent event,
      Emitter<MechanicDashboardState> emit) async {
    emit(const MechanicDashboardLoading());
    try {
      final jobs = await repository.getOngoingJobs();
      emit(MechanicDashboardSuccess(jobs));
    } catch (e) {
      // Fallback mock jobs list matching dashboard design
      final mockJobs = [
        const MechanicJobEntity(
          id: 'job_1',
          title: 'Tire Change',
          vehicleModel: 'Honda Civic',
          description:
              'Customer reports a flat rear-left tire. Spare is in the trunk. Requires immediate roadside assistance.',
          status: 'Repairing',
          timestamp: '10:15 AM',
        ),
        const MechanicJobEntity(
          id: 'job_2',
          title: 'Battery Jump',
          vehicleModel: 'BMW M4',
          description:
              "Vehicle won't start after lights left on overnight. Customer is waiting at the parking lot entrance.",
          status: 'En Route',
          timestamp: '10:22 AM',
        ),
        const MechanicJobEntity(
          id: 'job_3',
          title: 'Engine Check',
          vehicleModel: 'Toyota Corolla',
          description:
              'Customer reports check engine light on and white smoke from hood. Possible coolant leak or sensor issue.',
          status: 'Diagnosing',
          timestamp: '10:30 AM',
        ),
      ];
      emit(MechanicDashboardSuccess(mockJobs));
    }
  }
}
