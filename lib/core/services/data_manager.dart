import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stitch/core/models/admin_user.dart';
import 'package:stitch/core/models/booking.dart';
import 'package:stitch/core/models/user.dart';
import 'package:stitch/core/models/table.dart';
import 'package:stitch/core/models/table_booking.dart';
import 'package:stitch/core/models/restaurant.dart';

class DataManager extends ChangeNotifier {
  static final DataManager _instance = DataManager._internal();

  factory DataManager() {
    return _instance;
  }

  DataManager._internal() {
    _initializeTables();
    _initializeRestaurants();
  }

  final List<Booking> _bookings = [];
  final List<RestaurantTable> _tables = [];
  final List<TableBooking> _tableBookings = [];
  final List<Restaurant> _restaurants = [];
  String _currentUserName = 'Guest User'; // Track current logged-in user

  // Demo users
  final List<User> _users = [
    User(
      name: 'John Doe',
      email: 'john',
      password: '123',
    ),
    User(
      name: 'Sarah Smith',
      email: 'sarah',
      password: '123',
    ),
    User(
      name: 'Guest User',
      email: 'guest',
      password: '123',
    ),
  ];

  final List<AdminUser> _admins = [
    AdminUser(
      email: 'a1',
      password: '123',
      restaurantId: '1',
      restaurantName: 'Dimple Restaurant',
    ),
    AdminUser(
      email: 'a2',
      password: '123',
      restaurantId: '2',
      restaurantName: 'Mango',
    ),
    AdminUser(
      email: 'a3',
      password: '123',
      restaurantId: '3',
      restaurantName: 'The City Point',
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
  List<Booking> get allBookings => _bookings; // For debugging
  int get bookingsCount => _bookings.length; // For debugging

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
    print('📋 DataManager: Getting bookings for user: $userName');
    print('📋 DataManager: Total bookings in system: ${_bookings.length}');
    final userBookings =
        _bookings.where((b) => b.userName == userName).toList();
    print(
        '📋 DataManager: Found ${userBookings.length} bookings for $userName');
    return userBookings;
  }

  void addBooking(Booking booking) {
    print(
        '✅ DataManager: Adding booking for ${booking.userName} at ${booking.restaurantName}');
    _bookings.add(booking);
    print('✅ DataManager: Total bookings now: ${_bookings.length}');
    notifyListeners();
  }

  void updateBookingStatus(String bookingId, String newStatus) {
    final index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      _bookings[index].status = newStatus;

      final booking = _bookings[index];

      if (newStatus == 'Confirmed' || newStatus == 'Accepted') {
        // Create a time-specific table booking
        createTableBooking(booking);
      } else if (newStatus == 'Rejected' || newStatus == 'Cancelled') {
        // Cancel the table booking if it exists
        cancelTableBooking(bookingId);
      }

      notifyListeners();
    }
  }

  // Table Management Methods
  void _initializeTables() {
    // Initialize tables for each restaurant
    // Restaurant 1: The Gourmet Kitchen
    _tables.addAll([
      RestaurantTable(
        id: 't1_1',
        restaurantId: '1',
        tableName: 'Table 01',
        section: 'VIP Section',
        seats: 4,
        status: 'Available',
        icon: Icons.table_restaurant,
      ),
      RestaurantTable(
        id: 't1_2',
        restaurantId: '1',
        tableName: 'Table 02',
        section: 'Main Hall',
        seats: 2,
        status: 'Available',
        icon: Icons.table_bar,
      ),
      RestaurantTable(
        id: 't1_3',
        restaurantId: '1',
        tableName: 'Table 03',
        section: 'Window View',
        seats: 6,
        status: 'Available',
        icon: Icons.deck,
      ),
      RestaurantTable(
        id: 't1_4',
        restaurantId: '1',
        tableName: 'Table 04',
        section: 'Outdoor Terrace',
        seats: 8,
        status: 'Available',
        icon: Icons.umbrella,
      ),
      RestaurantTable(
        id: 't1_5',
        restaurantId: '1',
        tableName: 'Table 05',
        section: 'Bar Area',
        seats: 2,
        status: 'Maintenance',
        icon: Icons.construction,
      ),
    ]);

    // Restaurant 2: Sushi Master
    _tables.addAll([
      RestaurantTable(
        id: 't2_1',
        restaurantId: '2',
        tableName: 'Table 01',
        section: 'VIP Section',
        seats: 4,
        status: 'Available',
        icon: Icons.table_restaurant,
      ),
      RestaurantTable(
        id: 't2_2',
        restaurantId: '2',
        tableName: 'Table 02',
        section: 'Main Hall',
        seats: 2,
        status: 'Available',
        icon: Icons.table_bar,
      ),
      RestaurantTable(
        id: 't2_3',
        restaurantId: '2',
        tableName: 'Table 03',
        section: 'Window View',
        seats: 6,
        status: 'Available',
        icon: Icons.deck,
      ),
    ]);

    // Restaurant 3: Urban Grill House
    _tables.addAll([
      RestaurantTable(
        id: 't3_1',
        restaurantId: '3',
        tableName: 'Table 01',
        section: 'VIP Section',
        seats: 4,
        status: 'Available',
        icon: Icons.table_restaurant,
      ),
      RestaurantTable(
        id: 't3_2',
        restaurantId: '3',
        tableName: 'Table 02',
        section: 'Main Hall',
        seats: 2,
        status: 'Available',
        icon: Icons.table_bar,
      ),
      RestaurantTable(
        id: 't3_3',
        restaurantId: '3',
        tableName: 'Table 03',
        section: 'Window View',
        seats: 6,
        status: 'Available',
        icon: Icons.deck,
      ),
    ]);
  }

  List<RestaurantTable> getTablesForRestaurant(String restaurantId) {
    return _tables.where((t) => t.restaurantId == restaurantId).toList();
  }

  RestaurantTable? getTableById(String restaurantId, String tableName) {
    try {
      return _tables.firstWhere(
        (t) => t.restaurantId == restaurantId && t.tableName == tableName,
      );
    } catch (e) {
      return null;
    }
  }

  void addTable(RestaurantTable table) {
    _tables.add(table);
    print(
        '✅ Table added: ${table.tableName} for restaurant ${table.restaurantId}');
    notifyListeners();
  }

  void updateTable(String tableId, RestaurantTable updatedTable) {
    final index = _tables.indexWhere((t) => t.id == tableId);
    if (index != -1) {
      _tables[index] = updatedTable;
      print('✏️ Table updated: ${updatedTable.tableName}');
      notifyListeners();
    }
  }

  void deleteTable(String restaurantId, String tableName) {
    final index = _tables.indexWhere(
      (t) => t.restaurantId == restaurantId && t.tableName == tableName,
    );
    if (index != -1) {
      final table = _tables[index];
      _tables.removeAt(index);
      print('🗑️ Table deleted: ${table.tableName}');
      notifyListeners();
    }
  }

  RestaurantTable? getTableByName(String restaurantId, String tableName) {
    try {
      return _tables.firstWhere(
        (t) => t.restaurantId == restaurantId && t.tableName == tableName,
      );
    } catch (e) {
      return null;
    }
  }

  void updateTableStatus(String tableId, String newStatus) {
    final index = _tables.indexWhere((t) => t.id == tableId);
    if (index != -1) {
      _tables[index].status = newStatus;
      notifyListeners();
    }
  }

  // Time-Based Booking Management

  /// Check if a table is available for a specific date and time
  bool isTableAvailable(
      String restaurantId, String tableName, DateTime date, String time) {
    // Check if there's already a confirmed booking for this table at this time
    final existingBooking = _tableBookings.firstWhere(
      (tb) =>
          tb.restaurantId == restaurantId &&
          tb.tableName == tableName &&
          tb.isForDateTime(date, time) &&
          tb.isActive,
      orElse: () => TableBooking(
        id: '',
        tableId: '',
        restaurantId: '',
        tableName: '',
        date: DateTime.now(),
        time: '',
        bookingId: '',
        status: 'Cancelled',
      ),
    );

    return existingBooking.id.isEmpty;
  }

  /// Create a time-specific table booking
  void createTableBooking(Booking booking) {
    final table = getTableByName(booking.restaurantId, booking.tableName);
    if (table == null) return;

    // Check if table booking already exists for this booking ID
    final existingIndex =
        _tableBookings.indexWhere((tb) => tb.bookingId == booking.id);

    if (existingIndex != -1) {
      // Update existing table booking status
      _tableBookings[existingIndex].status = 'Confirmed';
    } else {
      // Create new table booking
      final tableBooking = TableBooking(
        id: 'tb_${booking.id}',
        tableId: table.id,
        restaurantId: booking.restaurantId,
        tableName: booking.tableName,
        date: booking.date,
        time: booking.time,
        bookingId: booking.id,
        status: 'Confirmed',
      );
      _tableBookings.add(tableBooking);
    }

    print(
        '✅ TableBooking created: ${booking.tableName} at ${booking.time} on ${booking.date}');
    notifyListeners();
  }

  /// Cancel a time-specific table booking
  void cancelTableBooking(String bookingId) {
    final index = _tableBookings.indexWhere((tb) => tb.bookingId == bookingId);
    if (index != -1) {
      _tableBookings[index].status = 'Cancelled';
      print('❌ TableBooking cancelled for booking: $bookingId');
      notifyListeners();
    }
  }

  /// Get all table bookings for a specific table on a specific date
  List<TableBooking> getTableBookingsForTable(String tableId, DateTime date) {
    return _tableBookings.where((tb) {
      return tb.tableId == tableId &&
          tb.date.year == date.year &&
          tb.date.month == date.month &&
          tb.date.day == date.day &&
          tb.isActive;
    }).toList();
  }

  /// Get all active table bookings for a restaurant
  List<TableBooking> getTableBookingsForRestaurant(String restaurantId) {
    return _tableBookings
        .where((tb) => tb.restaurantId == restaurantId && tb.isActive)
        .toList();
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

  // Restaurant Management Methods

  void _initializeRestaurants() {
    _restaurants.addAll([
      Restaurant(
        id: '1',
        name: 'Dimple Restaurant',
        cuisine: 'Italian • Fine Dining',
        image:
            'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?auto=format&fit=crop&w=800&q=60',
        rating: 4.8,
      ),
      Restaurant(
        id: '2',
        name: 'Mango',
        cuisine: 'Japanese • Sushi',
        image:
            'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?auto=format&fit=crop&w=800&q=60',
        rating: 4.9,
      ),
      Restaurant(
        id: '3',
        name: 'The City Point',
        cuisine: 'American • Steakhouse',
        image:
            'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=800&q=60',
        rating: 4.5,
      ),
    ]);
  }

  List<Restaurant> getAllRestaurants() {
    return List.unmodifiable(_restaurants);
  }

  Restaurant? getRestaurantById(String id) {
    try {
      return _restaurants.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  void addRestaurant(Restaurant restaurant) {
    _restaurants.add(restaurant);
    print('✅ Restaurant added: ${restaurant.name}');
    notifyListeners();
  }

  void updateRestaurant(String id, Restaurant updatedRestaurant) {
    final index = _restaurants.indexWhere((r) => r.id == id);
    if (index != -1) {
      _restaurants[index] = updatedRestaurant;
      print('✏️ Restaurant updated: ${updatedRestaurant.name}');
      notifyListeners();
    }
  }

  void deleteRestaurant(String id) {
    final index = _restaurants.indexWhere((r) => r.id == id);
    if (index != -1) {
      final name = _restaurants[index].name;
      _restaurants.removeAt(index);
      print('🗑️ Restaurant deleted: $name');
      notifyListeners();
    }
  }

  /// Delete restaurant and its associated admin together
  void deleteRestaurantAndAdmin(String restaurantId) {
    // Delete the restaurant
    final restaurantIndex =
        _restaurants.indexWhere((r) => r.id == restaurantId);
    if (restaurantIndex != -1) {
      final restaurantName = _restaurants[restaurantIndex].name;
      _restaurants.removeAt(restaurantIndex);
      print('🗑️ Restaurant deleted: $restaurantName');
    }

    // Delete the associated admin
    final adminIndex =
        _admins.indexWhere((a) => a.restaurantId == restaurantId);
    if (adminIndex != -1) {
      final adminEmail = _admins[adminIndex].email;
      _admins.removeAt(adminIndex);
      print('🗑️ Admin deleted: $adminEmail');
    }

    notifyListeners();
  }
}
