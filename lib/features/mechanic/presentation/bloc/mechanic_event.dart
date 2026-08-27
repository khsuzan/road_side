import '../../domain/entities/mechanic_application_entity.dart';

abstract class MechanicEvent {
  const MechanicEvent();
}

class SubmitApplicationEvent extends MechanicEvent {
  final MechanicApplicationEntity application;
  const SubmitApplicationEvent(this.application);
}

class GetApplicationStatusEvent extends MechanicEvent {
  final String mechanicId;
  const GetApplicationStatusEvent(this.mechanicId);
}
