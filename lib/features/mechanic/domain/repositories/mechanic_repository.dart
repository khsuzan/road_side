import '../entities/mechanic_application_entity.dart';

abstract class MechanicRepository {
  Future<void> submitApplication(MechanicApplicationEntity application);
  Future<String> getApplicationStatus(String mechanicId);
}
