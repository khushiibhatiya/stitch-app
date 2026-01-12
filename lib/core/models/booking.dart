class Booking {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final String userName;
  final DateTime date;
  final String time;
  final int guests;
  final String tableName;
  String status; // 'Pending', 'Accepted', 'Rejected'

  Booking({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.userName,
    required this.date,
    required this.time,
    required this.guests,
    required this.tableName,
    this.status = 'Pending',
  });
}
