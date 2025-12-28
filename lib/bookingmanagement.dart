import 'package:flutter/material.dart';

// Booking data model
class BookingData {
  final String customerName;
  final String phoneNumber;
  final String? imageUrl;
  final String? initials;
  final Color? initialsColor;
  final String time;
  final int guests;
  final String tableNumber;
  final String status;
  final Color statusColor;
  final Color statusBgColor;
  final double opacity;

  BookingData({
    required this.customerName,
    required this.phoneNumber,
    this.imageUrl,
    this.initials,
    this.initialsColor,
    required this.time,
    required this.guests,
    required this.tableNumber,
    required this.status,
    required this.statusColor,
    required this.statusBgColor,
    this.opacity = 1.0,
  });
}

class BookingManagementScreen extends StatefulWidget {
  const BookingManagementScreen({super.key});

  @override
  State<BookingManagementScreen> createState() =>
      _BookingManagementScreenState();
}

class _BookingManagementScreenState extends State<BookingManagementScreen> {
  int _selectedFilterIndex = 0;
  int _selectedNavIndex = 1; // Bookings is selected
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<BookingData> _getAllBookings() {
    return [
      BookingData(
        customerName: 'Johnathan Doe',
        phoneNumber: '+1 (555) 012-3456',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuDAa7n_ikB5cEAml_4ld00SAUUyK7kGYJXLFSUfitq3KZjdSKUa6XQxYNx8w66fbsIFmQdmEUR3oDOTgYQkQcxebTA7q_yoxMUDP0-1ktKlFUiOsIwO646Ua4PPtp8wzGzziha4cHx7ytdovOVxBzn5d-Zi2aTmxh0pI7lznBUPDATQv8awlBh09DzzakmrUwYrzrdD4quGWWZ1eHmjPvv_A37F6cVNGE3rm0--HjBa3aGyHgPI7hZE-zD4sSCkF1Hzvr0dMdcPA6o',
        time: '7:00 PM',
        guests: 4,
        tableNumber: 'T-04',
        status: 'Confirmed',
        statusColor: const Color(0xFF10B981),
        statusBgColor: const Color(0xFFD1FAE5),
      ),
      BookingData(
        customerName: 'Sarah Smith',
        phoneNumber: '+1 (555) 987-6543',
        initials: 'SS',
        initialsColor: const Color(0xFFFBBF24),
        time: '7:30 PM',
        guests: 2,
        tableNumber: 'T-12',
        status: 'Pending',
        statusColor: const Color(0xFFF59E0B),
        statusBgColor: const Color(0xFFFEF3C7),
      ),
      BookingData(
        customerName: 'Michael Brown',
        phoneNumber: '+1 (555) 456-7890',
        imageUrl:
            'https://lh3.googleusercontent.com/aida-public/AB6AXuC5lG-NY8tLAp5j7T5WSPkimgDmngqagyMgjN3y1rkZVoZc9ywAp-otOY0t1XR0QfQi_TByGS14l62acj0qUU3ld9SGGDwXXYX2qTmmo1IwZQc5scNjk5mdbJWpSNYPgtKfB3XtoyTJcQsbXRCk30PRWx0q7c94hSxwwbxqOPu2BXhJZ1EpOuH6HvsJ4psS94bAsE6YRp5nnfv6wRT4oZeZBaMozQQGtoOf5HZVYQb4oXCcQW79M0gI7r2x_mPgXTrZ-zk5y258_Mo',
        time: '8:00 PM',
        guests: 6,
        tableNumber: 'T-08',
        status: 'Cancelled',
        statusColor: const Color(0xFFEF4444),
        statusBgColor: const Color(0xFFFEE2E2),
        opacity: 0.7,
      ),
    ];
  }

  List<BookingData> _getFilteredBookings() {
    List<BookingData> allBookings = _getAllBookings();

    // Apply status filter based on selected filter
    List<BookingData> filtered = allBookings;
    if (_selectedFilterIndex == 1) {
      // Today - for demo, show all
      filtered = allBookings;
    } else if (_selectedFilterIndex == 2) {
      // Upcoming
      filtered = allBookings
          .where((booking) => booking.status != 'Cancelled')
          .toList();
    } else if (_selectedFilterIndex == 3) {
      // Pending
      filtered =
          allBookings.where((booking) => booking.status == 'Pending').toList();
    } else if (_selectedFilterIndex == 4) {
      // Cancelled
      filtered = allBookings
          .where((booking) => booking.status == 'Cancelled')
          .toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((booking) {
        return booking.customerName.toLowerCase().contains(_searchQuery) ||
            booking.phoneNumber.toLowerCase().contains(_searchQuery) ||
            booking.tableNumber.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF39E079);
    final backgroundColor =
        isDark ? const Color(0xFF122017) : const Color(0xFFF6F8F7);
    final cardColor = isDark ? const Color(0xFF1E2330) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111318);
    final secondaryTextColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF636F88);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top App Bar
            Container(
              color: backgroundColor.withOpacity(0.95),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, size: 24, color: textColor),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Booking Management',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        letterSpacing: -0.015,
                      ),
                    ),
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.more_vert, size: 24, color: textColor),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  style: TextStyle(color: textColor, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: 'Search name or ID',
                    hintStyle: TextStyle(color: secondaryTextColor),
                    prefixIcon:
                        Icon(Icons.search, color: secondaryTextColor, size: 24),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.tune, color: primaryColor, size: 24),
                      onPressed: () {},
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
              ),
            ),

            // Stats Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF1E3A8A).withOpacity(0.2)
                                      : const Color(0xFFDCEEFB),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.calendar_month,
                                    color: primaryColor, size: 20),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Total Bookings',
                                  style: TextStyle(
                                    color: secondaryTextColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '42',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '+12% vs last week',
                            style: TextStyle(
                              color: const Color(0xFF10B981),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFFF97316).withOpacity(0.2)
                                      : const Color(0xFFFFEDD5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(Icons.table_restaurant,
                                    color: const Color(0xFFF97316), size: 20),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'Available',
                                  style: TextStyle(
                                    color: secondaryTextColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '5',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              height: 1.0,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'out of 20 tables',
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Filter Chips
            SizedBox(
              height: 56,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  _buildFilterChip('All', 0, primaryColor, cardColor, textColor,
                      secondaryTextColor, isDark),
                  const SizedBox(width: 8),
                  _buildFilterChip('Today', 1, primaryColor, cardColor,
                      textColor, secondaryTextColor, isDark),
                  const SizedBox(width: 8),
                  _buildFilterChip('Upcoming', 2, primaryColor, cardColor,
                      textColor, secondaryTextColor, isDark),
                  const SizedBox(width: 8),
                  _buildFilterChip('Pending', 3, primaryColor, cardColor,
                      textColor, secondaryTextColor, isDark),
                  const SizedBox(width: 8),
                  _buildFilterChip('Cancelled', 4, primaryColor, cardColor,
                      textColor, secondaryTextColor, isDark),
                ],
              ),
            ),

            // Section Headline
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today\'s Reservations',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'See All',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Booking List
            Expanded(
              child: Builder(
                builder: (context) {
                  final filteredBookings = _getFilteredBookings();

                  if (filteredBookings.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: secondaryTextColor.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No bookings found',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    itemCount: filteredBookings.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final booking = filteredBookings[index];
                      return _buildBookingCard(
                        booking: booking,
                        cardColor: cardColor,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                        primaryColor: primaryColor,
                        isDark: isDark,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: primaryColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: IconButton(
          icon: const Icon(Icons.add, color: Colors.white, size: 30),
          onPressed: () {},
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, int index, Color primaryColor,
      Color cardColor, Color textColor, Color secondaryTextColor, bool isDark) {
    final isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilterIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white : const Color(0xFF111318))
              : cardColor,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(
                  color: isDark
                      ? const Color(0xFF374151)
                      : const Color(0xFFE5E7EB),
                ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? (isDark ? const Color(0xFF111318) : Colors.white)
                : secondaryTextColor,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard({
    required BookingData booking,
    required Color cardColor,
    required Color textColor,
    required Color secondaryTextColor,
    required Color primaryColor,
    required bool isDark,
  }) {
    final isCancelled = booking.status == 'Cancelled';
    final isPending = booking.status == 'Pending';

    return Opacity(
      opacity: booking.opacity,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark ? const Color(0xFF1F2937) : const Color(0xFFE5E7EB),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header: Avatar, Name, Status
            Row(
              children: [
                // Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: booking.initialsColor ?? const Color(0xFFE5E7EB),
                    shape: BoxShape.circle,
                  ),
                  child: booking.imageUrl != null
                      ? ClipOval(
                          child: Image.network(
                            booking.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Text(
                                  booking.initials ??
                                      booking.customerName[0].toUpperCase(),
                                  style: TextStyle(
                                    color: isDark
                                        ? const Color(0xFF111318)
                                        : Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                            booking.initials ??
                                booking.customerName[0].toUpperCase(),
                            style: TextStyle(
                              color: isDark
                                  ? const Color(0xFF111318)
                                  : Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                // Name and Phone
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.customerName,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                          decoration: isCancelled
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor: secondaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.phone,
                              size: 14, color: secondaryTextColor),
                          const SizedBox(width: 4),
                          Text(
                            booking.phoneNumber,
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Status Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isDark
                        ? booking.statusColor.withOpacity(0.3)
                        : booking.statusBgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    booking.status,
                    style: TextStyle(
                      color: isDark
                          ? booking.statusColor.withOpacity(0.9)
                          : booking.statusColor.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Info Cards: Time, Guests, Table
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF122017)
                          : const Color(0xFFF6F6F8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.schedule,
                            color:
                                isCancelled ? secondaryTextColor : primaryColor,
                            size: 20),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TIME',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              booking.time,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF122017)
                          : const Color(0xFFF6F6F8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.group,
                            color: isCancelled
                                ? secondaryTextColor
                                : const Color(0xFFF97316),
                            size: 20),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'GUESTS',
                              style: TextStyle(
                                color: secondaryTextColor,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${booking.guests} ppl',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isCancelled) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF122017)
                            : const Color(0xFFF6F6F8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.table_bar,
                              color: const Color(0xFF8B5CF6), size: 20),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TABLE',
                                style: TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                booking.tableNumber,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),

            // Action Buttons
            if (!isCancelled)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(
                        isPending ? Icons.check : Icons.edit,
                        size: 18,
                        color: isPending ? primaryColor : Colors.white,
                      ),
                      label: Text(
                        isPending ? 'Approve' : 'Edit',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isPending ? primaryColor : Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isPending
                            ? primaryColor.withOpacity(0.1)
                            : primaryColor,
                        foregroundColor:
                            isPending ? primaryColor : Colors.white,
                        elevation: isPending ? 0 : 4,
                        shadowColor:
                            isPending ? null : primaryColor.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF374151)
                            : const Color(0xFFE5E7EB),
                      ),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.close,
                          size: 18, color: secondaryTextColor),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index,
      Color primaryColor, Color secondaryTextColor) {
    final isSelected = _selectedNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedNavIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? primaryColor : secondaryTextColor,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? primaryColor : secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
