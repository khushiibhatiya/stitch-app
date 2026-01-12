import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Booking History Model
class BookingHistoryItem {
  final String restaurantName;
  final String imageUrl;
  final String date;
  final String time;
  final int guests;
  final String status;
  final Color statusColor;

  BookingHistoryItem({
    required this.restaurantName,
    required this.imageUrl,
    required this.date,
    required this.time,
    required this.guests,
    required this.status,
    required this.statusColor,
  });
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedNavIndex = 3; // Profile is selected

  // Selected preferences
  final Set<String> _selectedPreferences = {'Window Seat', 'Free Wi-Fi'};

  final List<BookingHistoryItem> _bookingHistory = [
    BookingHistoryItem(
      restaurantName: 'The Grand Dining Hall',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDF8OSKkbUbXfIsM9si5qv2fF-L83--7tAX7JBhEoBIgJ_n_xbGfCYj-3m1LRDOHS1KdgNb2ePOfGaXNWGkOFT3wVzeiHeX-KOSV4MAbrNmSxSYfo_BGm6Y7mm4hcepAcwFz27qD5jdlUaSbxkpibNUnSGbIWE1VYOl5xDTkQ-2J0QK6GyN57hhFdqHGOYuSkyoKpyPrz7R6KM5_p8JXn2ZZuNj7K6O651mS5cFcEFuuGsWyJ0zUJLoCxkFFobeziiKv2MsQrtVl0c',
      date: 'Oct 24',
      time: '7:00 PM',
      guests: 2,
      status: 'Upcoming',
      statusColor: const Color(0xFF10B981),
    ),
    BookingHistoryItem(
      restaurantName: 'Skyline Rooftop Lounge',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB39hl5mDO4ySTDaO9dPG0R-jiqG3ko6nUczv2yvOB_7AteKWjwEHqw_ktYZ9EC2rrmJbGOB7lzsgAr1cixFl_O9KnmI_2m7ZEnGu2UGUBW9X7F4sln-gxKrNwIA0iQuss0boA1u65n4RFWheOlkdR4xLVUzFBc0-CN1ENIYcyi8QgDmNVMc-lEJfhmsR3IoLdN5-5OHdtDuzpzALhoaCw8g15xnmIHAPSgCcD39ohsgiGX2uzfOZuxETe_WTO14-1d4yqM09c_cXA',
      date: 'Sep 12',
      time: '8:30 PM',
      guests: 4,
      status: 'Completed',
      statusColor: const Color(0xFF64748B),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF195DE6);
    final backgroundColor =
        isDark ? const Color(0xFF111621) : const Color(0xFFF6F6F8);
    final cardColor = isDark ? const Color(0xFF1E2430) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryTextColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top App Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: backgroundColor.withOpacity(0.9),
                border: const Border(
                  bottom: BorderSide(color: Colors.transparent),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: cardColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, size: 20, color: textColor),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  Text(
                    'My Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      letterSpacing: -0.015,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: cardColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.settings, size: 20, color: textColor),
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 24),
                      child: SizedBox(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Profile Picture with Edit Badge
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: 128,
                                  height: 128,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.15),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: cardColor,
                                      width: 4,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child: Image.network(
                                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAox1zadrQFm5qzJ3qSqegn_zJS5CG8rd62lvQDV8wyNRoPrQE66ccDaveqg3QOj7-aAzF1Zv-9q9ucLyvzKPCiWqB4EVq0BKmu9QpViN5pH8e4xBGtI6Ki_Xbe2qo5jQKZABpjBO3pSsu2GGwIKyHIEQ9hCwXcqi4a9CiqLh5rFA0YEqD5LBTT2rGhHnvDyTCL5fnQepmJvu1gEQ6wUt9vpe-1wb1ptmy_932c_tNtJ_5n2F_-4sPuBXguh8pE7LDQKd-BxdB2qgw',
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          color: Colors.grey[300],
                                          child: Icon(Icons.person,
                                              size: 48,
                                              color: Colors.grey[600]),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: backgroundColor,
                                        width: 4,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Name
                            Text(
                              'Alex Morgan',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Gold Member Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFFFBBF24).withOpacity(0.3)
                                    : const Color(0xFFFEF3C7),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.stars,
                                    size: 16,
                                    color: isDark
                                        ? const Color(0xFFFBBF24)
                                        : const Color(0xFFB45309),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'GOLD MEMBER',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? const Color(0xFFFBBF24)
                                          : const Color(0xFFB45309),
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Member since 2021',
                              style: TextStyle(
                                fontSize: 14,
                                color: secondaryTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Personal Info Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          // Section Header
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Personal Info',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Info Card
                          Container(
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFF1F5F9),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                _buildInfoItem(
                                  icon: Icons.mail,
                                  iconColor: primaryColor,
                                  iconBgColor: isDark
                                      ? primaryColor.withOpacity(0.2)
                                      : const Color(0xFFDCEEFB),
                                  label: 'Email',
                                  value: 'alex.morgan@example.com',
                                  textColor: textColor,
                                  secondaryTextColor: secondaryTextColor,
                                  isDark: isDark,
                                  showDivider: true,
                                ),
                                _buildInfoItem(
                                  icon: Icons.phone,
                                  iconColor: const Color(0xFF10B981),
                                  iconBgColor: isDark
                                      ? const Color(0xFF10B981).withOpacity(0.2)
                                      : const Color(0xFFD1FAE5),
                                  label: 'Phone',
                                  value: '+1 (555) 019-2834',
                                  textColor: textColor,
                                  secondaryTextColor: secondaryTextColor,
                                  isDark: isDark,
                                  showDivider: true,
                                ),
                                _buildInfoItem(
                                  icon: Icons.badge,
                                  iconColor: const Color(0xFF8B5CF6),
                                  iconBgColor: isDark
                                      ? const Color(0xFF8B5CF6).withOpacity(0.2)
                                      : const Color(0xFFEDE9FE),
                                  label: 'Member ID',
                                  value: '8839201',
                                  textColor: textColor,
                                  secondaryTextColor: secondaryTextColor,
                                  isDark: isDark,
                                  showDivider: false,
                                  showCopyButton: true,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Recent Bookings Section
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Recent Bookings',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'See All',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 240,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            itemCount: _bookingHistory.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 16),
                            itemBuilder: (context, index) {
                              final booking = _bookingHistory[index];
                              return _buildBookingCard(
                                booking: booking,
                                cardColor: cardColor,
                                textColor: textColor,
                                secondaryTextColor: secondaryTextColor,
                                isDark: isDark,
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Dining Preferences Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 12),
                            child: Text(
                              'Dining Preferences',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFF1F5F9),
                              ),
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
                                Text(
                                  'Select your preferences to help us find the perfect table for you.',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: secondaryTextColor,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _buildPreferenceChip(
                                      icon: Icons.window,
                                      label: 'Window Seat',
                                      isSelected: true,
                                      primaryColor: primaryColor,
                                      textColor: textColor,
                                      secondaryTextColor: secondaryTextColor,
                                      isDark: isDark,
                                    ),
                                    _buildPreferenceChip(
                                      icon: Icons.volume_off,
                                      label: 'Quiet Zone',
                                      isSelected: false,
                                      primaryColor: primaryColor,
                                      textColor: textColor,
                                      secondaryTextColor: secondaryTextColor,
                                      isDark: isDark,
                                    ),
                                    _buildPreferenceChip(
                                      icon: Icons.eco,
                                      label: 'Vegetarian',
                                      isSelected: false,
                                      primaryColor: primaryColor,
                                      textColor: textColor,
                                      secondaryTextColor: secondaryTextColor,
                                      isDark: isDark,
                                    ),
                                    _buildPreferenceChip(
                                      icon: Icons.wifi,
                                      label: 'Free Wi-Fi',
                                      isSelected: true,
                                      primaryColor: primaryColor,
                                      textColor: textColor,
                                      secondaryTextColor: secondaryTextColor,
                                      isDark: isDark,
                                    ),
                                    _buildPreferenceChip(
                                      icon: Icons.accessible,
                                      label: 'Accessible',
                                      isSelected: false,
                                      primaryColor: primaryColor,
                                      textColor: textColor,
                                      secondaryTextColor: secondaryTextColor,
                                      isDark: isDark,
                                    ),
                                    _buildAddPreferenceChip(
                                      primaryColor: primaryColor,
                                      secondaryTextColor: secondaryTextColor,
                                      isDark: isDark,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation

    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String label,
    required String value,
    required Color textColor,
    required Color secondaryTextColor,
    required bool isDark,
    required bool showDivider,
    bool showCopyButton = false,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: secondaryTextColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showCopyButton)
                  IconButton(
                    icon: Icon(
                      Icons.content_copy,
                      size: 20,
                      color: secondaryTextColor,
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: value));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Copied to clipboard'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
          ),
      ],
    );
  }

  Widget _buildBookingCard({
    required BookingHistoryItem booking,
    required Color cardColor,
    required Color textColor,
    required Color secondaryTextColor,
    required bool isDark,
  }) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        ),
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
          // Image with Status Badge
          Stack(
            children: [
              Container(
                height: 128,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  color: Colors.grey[300],
                ),
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    booking.imageUrl,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.restaurant,
                            size: 48, color: Colors.grey[600]),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: booking.statusColor,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    booking.status.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.restaurantName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: 18, color: secondaryTextColor),
                    const SizedBox(width: 8),
                    Text(
                      '${booking.date}, ${booking.time}',
                      style: TextStyle(
                        fontSize: 14,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.group, size: 18, color: secondaryTextColor),
                    const SizedBox(width: 8),
                    Text(
                      '${booking.guests} Guests',
                      style: TextStyle(
                        fontSize: 14,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferenceChip({
    required IconData icon,
    required String label,
    required bool isSelected,
    required Color primaryColor,
    required Color textColor,
    required Color secondaryTextColor,
    required bool isDark,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedPreferences.remove(label);
          } else {
            _selectedPreferences.add(label);
          }
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? Colors.white
                  : (isDark ? secondaryTextColor : const Color(0xFF94A3B8)),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark
                        ? const Color(0xFFD1D5DB)
                        : const Color(0xFF475569)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddPreferenceChip({
    required Color primaryColor,
    required Color secondaryTextColor,
    required bool isDark,
  }) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDark ? const Color(0xFF475569) : const Color(0xFFD1D5DB),
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add,
              size: 18,
              color: secondaryTextColor,
            ),
            const SizedBox(width: 6),
            Text(
              'Add Preference',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: secondaryTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(
      {required IconData icon,
      required String label,
      required int index,
      required Color primaryColor,
      required Color secondaryTextColor,
      bool showBadge = false}) {
    final isSelected = _selectedNavIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedNavIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                color: isSelected ? primaryColor : secondaryTextColor,
                size: 24,
              ),
              if (showBadge)
                Positioned(
                  top: -4,
                  right: -4,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4444),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '1',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
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
