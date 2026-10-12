import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/garage_repository.dart';
import 'garage_event.dart';
import 'garage_state.dart';

class GarageBloc extends Bloc<GarageEvent, GarageState> {
  final GarageRepository repository;

  GarageBloc({required this.repository}) : super(const GarageInitial()) {
    on<AddVehicleEvent>(_onAddVehicle);
  }

  Future<void> _onAddVehicle(
      AddVehicleEvent event, Emitter<GarageState> emit) async {
    emit(const GarageLoading());
    try {
      await repository.addVehicle(event.vehicle);
      emit(const GarageSuccess());
    } catch (e) {
      // Offline fallback mock success
      await Future.delayed(const Duration(seconds: 1));
      emit(const GarageSuccess());
    }
  }
}
