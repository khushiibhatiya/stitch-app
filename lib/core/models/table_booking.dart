class TableBooking {
  final String id;
  final String tableId;
  final String restaurantId;
  final String tableName;
  final DateTime date;
  final String time;
  final String bookingId;
  String status; // 'Confirmed', 'Pending', 'Cancelled'

  TableBooking({
    required this.id,
    required this.tableId,
    required this.restaurantId,
    required this.tableName,
    required this.date,
    required this.time,
    required this.bookingId,
    required this.status,
  });

  // Check if this table booking is for a specific date and time
  bool isForDateTime(DateTime checkDate, String checkTime) {
    return date.year == checkDate.year &&
        date.month == checkDate.month &&
        date.day == checkDate.day &&
        time == checkTime;
  }

  // Check if this table booking is active (confirmed)
  bool get isActive => status == 'Confirmed';
}
