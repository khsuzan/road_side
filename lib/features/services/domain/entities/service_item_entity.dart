class ServiceItemEntity {
  final String id;
  final String title;
  final String description;
  final double price;
  final String estimatedTime;
  final String iconName;

  const ServiceItemEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.estimatedTime,
    required this.iconName,
  });
}
