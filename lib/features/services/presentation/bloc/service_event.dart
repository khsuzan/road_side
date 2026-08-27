abstract class ServiceEvent {
  const ServiceEvent();
}

class FetchServicesEvent extends ServiceEvent {
  final String category;
  const FetchServicesEvent({this.category = 'All'});
}

class SubmitServiceRequestEvent extends ServiceEvent {
  final List<String> issues;
  final String serviceType;
  final String? audioPath;

  const SubmitServiceRequestEvent({
    required this.issues,
    required this.serviceType,
    this.audioPath,
  });
}
