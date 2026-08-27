class UserEntity {
  final String phoneNumber;
  final String? token;

  const UserEntity({
    required this.phoneNumber,
    this.token,
  });
}
