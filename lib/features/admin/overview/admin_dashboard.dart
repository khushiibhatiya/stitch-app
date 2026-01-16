import 'package:flutter/material.dart';
import 'package:stitch/core/services/data_manager.dart';
import 'package:stitch/core/models/admin_user.dart';
import 'package:stitch/core/models/booking.dart';
import 'package:stitch/features/auth/screens/login.dart';

class AdminDashboardScreen extends StatefulWidget {
  final AdminUser admin;

  const AdminDashboardScreen({super.key, required this.admin});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Listen to DataManager changes
    DataManager().addListener(_onDataChanged);
  }

  @override
  void dispose() {
    DataManager().removeListener(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    setState(() {}); // Rebuild when data changes
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _updateBookingStatus(String bookingId, String newStatus) {
    DataManager().updateBookingStatus(bookingId, newStatus);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF1E60F7);
    final backgroundColor =
        isDark ? const Color(0xFF111621) : const Color(0xFFF6F8F7);
    final cardColor = isDark ? const Color(0xFF1E2330) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111318);
    final secondaryTextColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF636F88);

    final bookings =
        DataManager().getBookingsForRestaurant(widget.admin.restaurantId);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: backgroundColor.withOpacity(0.95),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.admin.restaurantName,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Admin Dashboard',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.logout, color: textColor),
                    onPressed: _logout,
                  ),
                ],
              ),
            ),

            // Stats
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Total',
                      bookings.length.toString(),
                      Icons.event_note,
                      primaryColor,
                      cardColor,
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Pending',
                      bookings
                          .where((b) => b.status == 'Pending')
                          .length
                          .toString(),
                      Icons.schedule,
                      const Color(0xFFF59E0B),
                      cardColor,
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      'Confirmed',
                      bookings
                          .where((b) =>
                              b.status == 'Confirmed' || b.status == 'Accepted')
                          .length
                          .toString(),
                      Icons.check_circle,
                      const Color(0xFF10B981),
                      cardColor,
                      isDark,
                    ),
                  ),
                ],
              ),
            ),

            // Bookings List
            Expanded(
              child: bookings.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 64,
                            color: secondaryTextColor.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No bookings yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: bookings.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final booking = bookings[index];
                        return _buildBookingCard(
                          booking: booking,
                          cardColor: cardColor,
                          textColor: textColor,
                          secondaryTextColor: secondaryTextColor,
                          primaryColor: primaryColor,
                          isDark: isDark,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    Color cardColor,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? color.withOpacity(0.2) : color.withOpacity(0.1),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard({
    required Booking booking,
    required Color cardColor,
    required Color textColor,
    required Color secondaryTextColor,
    required Color primaryColor,
    required bool isDark,
  }) {
    Color statusColor;
    switch (booking.status) {
      case 'Accepted':
      case 'Confirmed':
        statusColor = const Color(0xFF10B981);
        break;
      case 'Rejected':
        statusColor = const Color(0xFFEF4444);
        break;
      default:
        statusColor = const Color(0xFFF59E0B);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.userName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${booking.date.day}/${booking.date.month}/${booking.date.year} • ${booking.time}',
                      style: TextStyle(
                        fontSize: 14,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  booking.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Details
          Row(
            children: [
              Icon(Icons.people, size: 16, color: secondaryTextColor),
              const SizedBox(width: 4),
              Text(
                '${booking.guests} Guests',
                style: TextStyle(fontSize: 14, color: textColor),
              ),
              const SizedBox(width: 16),
              Icon(Icons.table_restaurant, size: 16, color: secondaryTextColor),
              const SizedBox(width: 4),
              Text(
                booking.tableName,
                style: TextStyle(fontSize: 14, color: textColor),
              ),
            ],
          ),

          // Action Buttons (only for pending bookings)
          if (booking.status == 'Pending') ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        _updateBookingStatus(booking.id, 'Rejected'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEF4444),
                      side: const BorderSide(color: Color(0xFFEF4444)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _updateBookingStatus(booking.id, 'Confirmed'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
