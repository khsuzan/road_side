import '../entities/service_item_entity.dart';

abstract class ServiceRepository {
  Future<List<ServiceItemEntity>> getServices(String category);
  Future<void> submitServiceRequest({
    required List<String> issues,
    required String serviceType,
    String? audioPath,
  });
}
