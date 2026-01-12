import 'package:flutter/foundation.dart';
import 'package:stitch/core/models/admin_user.dart';
import 'package:stitch/core/models/booking.dart';
import 'package:stitch/core/models/user.dart';

class DataManager extends ChangeNotifier {
  static final DataManager _instance = DataManager._internal();

  factory DataManager() {
    return _instance;
  }

  DataManager._internal();

  final List<Booking> _bookings = [];
  String _currentUserName = 'Guest User'; // Track current logged-in user
  
  // Demo users
  final List<User> _users = [
    User(
      name: 'John Doe',
      email: 'john@example.com',
      password: '123',
    ),
    User(
      name: 'Sarah Smith',
      email: 'sarah@example.com',
      password: '123',
    ),
    User(
      name: 'Guest User',
      email: 'guest@example.com',
      password: '123',
    ),
  ];
  
  final List<AdminUser> _admins = [
    AdminUser(
      email: 'a1',
      password: '123',
      restaurantId: '1',
      restaurantName: 'The Gourmet Kitchen',
    ),
    AdminUser(
      email: 'a2',
      password: '123',
      restaurantId: '2',
      restaurantName: 'Sushi Master',
    ),
    AdminUser(
      email: 'a3',
      password: '123',
      restaurantId: '3',
      restaurantName: 'Urban Grill House',
    ),
    AdminUser(
      email: 'master',
      password: '123',
      restaurantId: '0',
      restaurantName: 'Master Control',
      isMaster: true,
    ),
  ];

  List<AdminUser> get admins => _admins;
  String get currentUserName => _currentUserName;

  void setCurrentUser(String userName) {
    _currentUserName = userName;
    notifyListeners();
  }

  void addAdmin(AdminUser admin) {
    _admins.add(admin);
    notifyListeners();
  }

  void updateAdmin(String originalEmail, AdminUser newAdmin) {
    final index = _admins.indexWhere((a) => a.email == originalEmail);
    if (index != -1) {
      _admins[index] = newAdmin;
      notifyListeners();
    }
  }

  void deleteAdmin(String email) {
    _admins.removeWhere((a) => a.email == email);
    notifyListeners();
  }

  List<Booking> getBookingsForRestaurant(String restaurantId) {
    return _bookings.where((b) => b.restaurantId == restaurantId).toList();
  }

  List<Booking> getBookingsForUser(String userName) {
    return _bookings.where((b) => b.userName == userName).toList();
  }

  void addBooking(Booking booking) {
    _bookings.add(booking);
    notifyListeners();
  }

  void updateBookingStatus(String bookingId, String newStatus) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index].status = newStatus;
      notifyListeners();
    }
  }

  AdminUser? authenticate(String email, String password) {
    try {
      return _admins.firstWhere(
        (admin) => admin.email == email && admin.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  User? authenticateUser(String email, String password) {
    try {
      return _users.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }
}
