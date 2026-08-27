import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/service_item_entity.dart';
import '../../domain/repositories/service_repository.dart';
import 'service_event.dart';
import 'service_state.dart';

class ServiceBloc extends Bloc<ServiceEvent, ServiceState> {
  final ServiceRepository serviceRepository;

  ServiceBloc({required this.serviceRepository})
      : super(const ServiceInitial()) {
    on<FetchServicesEvent>(_onFetchServices);
    on<SubmitServiceRequestEvent>(_onSubmitServiceRequest);
  }

  Future<void> _onFetchServices(
      FetchServicesEvent event, Emitter<ServiceState> emit) async {
    emit(const ServiceLoading());
    try {
      final services = await serviceRepository.getServices(event.category);
      emit(ServiceListSuccess(services));
    } catch (e) {
      // Fallback mockup services list
      final mockServices = [
        const ServiceItemEntity(
          id: '1',
          title: 'Standard Diagnostic',
          description:
              'Complete OBD-II scan, battery health check, and fluid level verification by certified master technicians.',
          price: 150.00,
          estimatedTime: '45 min',
          iconName: 'build',
        ),
        const ServiceItemEntity(
          id: '2',
          title: 'Premium Detailing',
          description:
              'Multi-stage paint correction, ceramic coating application, and interior leather conditioning.',
          price: 450.00,
          estimatedTime: '3 hrs',
          iconName: 'water_drop',
        ),
        const ServiceItemEntity(
          id: '3',
          title: 'Glass Repair & Reseal',
          description:
              'Windshield chip repair and advanced hydrophobic coating for maximum visibility in adverse conditions.',
          price: 225.00,
          estimatedTime: '60 min',
          iconName: 'panorama_horizontal',
        ),
      ];

      // Filter local lists if categories apply
      if (event.category == 'Diagnostics') {
        emit(ServiceListSuccess([mockServices[0]]));
      } else if (event.category == 'Detailing') {
        emit(ServiceListSuccess([mockServices[1]]));
      } else {
        emit(ServiceListSuccess(mockServices));
      }
    }
  }

  Future<void> _onSubmitServiceRequest(
      SubmitServiceRequestEvent event, Emitter<ServiceState> emit) async {
    emit(const ServiceLoading());
    try {
      await serviceRepository.submitServiceRequest(
        issues: event.issues,
        serviceType: event.serviceType,
        audioPath: event.audioPath,
      );
      emit(const ServiceRequestSuccess());
    } catch (e) {
      // Simulate submission success for demo purposes
      await Future.delayed(const Duration(seconds: 1));
      emit(const ServiceRequestSuccess());
    }
  }
}
