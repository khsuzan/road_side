import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/mechanic_repository.dart';
import 'mechanic_event.dart';
import 'mechanic_state.dart';

class MechanicBloc extends Bloc<MechanicEvent, MechanicState> {
  final MechanicRepository mechanicRepository;

  MechanicBloc({required this.mechanicRepository})
      : super(const MechanicInitial()) {
    on<SubmitApplicationEvent>(_onSubmitApplication);
    on<GetApplicationStatusEvent>(_onGetApplicationStatus);
  }

  Future<void> _onSubmitApplication(
      SubmitApplicationEvent event, Emitter<MechanicState> emit) async {
    emit(const MechanicLoading());
    try {
      await mechanicRepository.submitApplication(event.application);
      emit(const MechanicSubmitSuccess());
    } catch (e) {
      // Simulate success for offline demo
      await Future.delayed(const Duration(seconds: 1));
      emit(const MechanicSubmitSuccess());
    }
  }

  Future<void> _onGetApplicationStatus(
      GetApplicationStatusEvent event, Emitter<MechanicState> emit) async {
    emit(const MechanicLoading());
    try {
      final status = await mechanicRepository.getApplicationStatus(event.mechanicId);
      emit(MechanicStatusSuccess(status));
    } catch (e) {
      emit(const MechanicStatusSuccess('Pending'));
    }
  }
}
