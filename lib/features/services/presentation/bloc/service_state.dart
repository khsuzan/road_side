import '../../domain/entities/service_item_entity.dart';

abstract class ServiceState {
  const ServiceState();
}

class ServiceInitial extends ServiceState {
  const ServiceInitial();
}

class ServiceLoading extends ServiceState {
  const ServiceLoading();
}

class ServiceListSuccess extends ServiceState {
  final List<ServiceItemEntity> services;
  const ServiceListSuccess(this.services);
}

class ServiceRequestSuccess extends ServiceState {
  const ServiceRequestSuccess();
}

class ServiceFailure extends ServiceState {
  final String message;
  const ServiceFailure(this.message);
}
