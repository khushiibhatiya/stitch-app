import 'package:flutter/material.dart';

class RestaurantTable {
  final String id;
  final String restaurantId;
  final String tableName;
  final String section;
  final int seats;
  String status; // 'Available', 'Booked', 'Maintenance'
  final IconData icon;

  RestaurantTable({
    required this.id,
    required this.restaurantId,
    required this.tableName,
    required this.section,
    required this.seats,
    required this.status,
    required this.icon,
  });

  bool get isAvailable => status == 'Available';
  bool get isBooked => status == 'Booked';
  bool get isUnderMaintenance => status == 'Maintenance';

  void markAsBooked() {
    status = 'Booked';
  }

  void markAsAvailable() {
    status = 'Available';
  }

  void markAsUnderMaintenance() {
    status = 'Maintenance';
  }
}
