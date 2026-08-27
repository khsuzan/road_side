import '../../domain/entities/mechanic_application_entity.dart';
import '../../domain/repositories/mechanic_repository.dart';
import '../datasources/mechanic_remote_data_source.dart';
import '../models/mechanic_application_model.dart';
import '../../../../core/network/error_handler.dart';

class MechanicRepositoryImpl implements MechanicRepository {
  final MechanicRemoteDataSource remoteDataSource;

  MechanicRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> submitApplication(MechanicApplicationEntity application) async {
    try {
      final model = MechanicApplicationModel(
        id: application.id,
        idPhotoPath: application.idPhotoPath,
        expertise: application.expertise,
        businessType: application.businessType,
        latitude: application.latitude,
        longitude: application.longitude,
        status: application.status,
      );
      await remoteDataSource.submitApplication(model);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  @override
  Future<String> getApplicationStatus(String mechanicId) async {
    try {
      return await remoteDataSource.getApplicationStatus(mechanicId);
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
