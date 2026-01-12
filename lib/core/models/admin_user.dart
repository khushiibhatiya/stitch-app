class AdminUser {
  final String email;
  final String password;
  final String restaurantId;
  final String restaurantName;
  final bool isMaster;

  AdminUser({
    required this.email,
    required this.password,
    required this.restaurantId,
    required this.restaurantName,
    this.isMaster = false,
  });
}
