import 'package:flutter/material.dart';
import 'package:stitch/features/client/booking/book_table.dart';

// Table data model
class TableData {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String tableName;
  final String section;
  final int seats;
  final String status;
  final Color statusColor;
  final double opacity;

  TableData({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.tableName,
    required this.section,
    required this.seats,
    required this.status,
    required this.statusColor,
    this.opacity = 1.0,
  });
}

class TableManagementScreen extends StatefulWidget {
  final Map<String, dynamic> restaurant;
  const TableManagementScreen({super.key, required this.restaurant});

  @override
  State<TableManagementScreen> createState() => _TableManagementScreenState();
}

class _TableManagementScreenState extends State<TableManagementScreen> {
  int _selectedTabIndex = 0;
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

  List<TableData> _getAllTables(
      bool isDark, Color primaryColor, Color secondaryTextColor) {
    return [
      TableData(
        icon: Icons.table_restaurant,
        iconColor: primaryColor,
        iconBgColor: primaryColor.withOpacity(0.1),
        tableName: 'Table 01',
        section: 'VIP Section',
        seats: 4,
        status: 'Booked',
        statusColor: primaryColor,
      ),
      TableData(
        icon: Icons.table_bar,
        iconColor: secondaryTextColor,
        iconBgColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        tableName: 'Table 02',
        section: 'Main Hall',
        seats: 2,
        status: 'Available',
        statusColor: const Color(0xFF10B981),
      ),
      TableData(
        icon: Icons.deck,
        iconColor: primaryColor,
        iconBgColor: primaryColor.withOpacity(0.1),
        tableName: 'Table 03',
        section: 'Window View',
        seats: 6,
        status: 'Booked',
        statusColor: primaryColor,
      ),
      TableData(
        icon: Icons.umbrella,
        iconColor: secondaryTextColor,
        iconBgColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
        tableName: 'Table 04',
        section: 'Outdoor Terrace',
        seats: 8,
        status: 'Available',
        statusColor: const Color(0xFF10B981),
      ),
      TableData(
        icon: Icons.construction,
        iconColor: const Color(0xFFF59E0B),
        iconBgColor: isDark
            ? const Color(0xFFF59E0B).withOpacity(0.2)
            : const Color(0xFFFEF3C7),
        tableName: 'Table 05',
        section: 'Bar Area',
        seats: 2,
        status: 'Maintenance',
        statusColor: const Color(0xFFF59E0B),
        opacity: 0.8,
      ),
    ];
  }

  List<TableData> _getFilteredTables(
      bool isDark, Color primaryColor, Color secondaryTextColor) {
    List<TableData> allTables =
        _getAllTables(isDark, primaryColor, secondaryTextColor);

    // Apply status filter based on selected tab
    List<TableData> filtered = allTables;
    if (_selectedTabIndex == 1) {
      // Available tab
      filtered =
          allTables.where((table) => table.status == 'Available').toList();
    } else if (_selectedTabIndex == 2) {
      // Booked tab
      filtered = allTables.where((table) => table.status == 'Booked').toList();
    }

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((table) {
        return table.tableName.toLowerCase().contains(_searchQuery) ||
            table.section.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    return filtered;
  }

  int _getStatusCount(String status, bool isDark, Color primaryColor,
      Color secondaryTextColor) {
    List<TableData> allTables =
        _getAllTables(isDark, primaryColor, secondaryTextColor);
    if (status == 'All') {
      return allTables.length;
    }
    return allTables.where((table) => table.status == status).length;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF195DE6);
    final backgroundColor =
        isDark ? const Color(0xFF111621) : const Color(0xFFF8F9FB);
    final cardColor = isDark ? const Color(0xFF1E2330) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF0F172A);
    final secondaryTextColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header Section
            Container(
              color: backgroundColor.withOpacity(0.95),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Column(
                children: [
                  // Title Bar
                  Row(
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
                          icon: Icon(Icons.arrow_back,
                              size: 20, color: textColor),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.restaurant['name'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 40), // Balance the back button
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Search and Add Button
                  Row(
                    children: [
                      Expanded(
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
                            style: TextStyle(color: textColor, fontSize: 14),
                            decoration: InputDecoration(
                              hintText: 'Search tables...',
                              hintStyle: TextStyle(color: secondaryTextColor),
                              prefixIcon: Icon(Icons.search,
                                  color: secondaryTextColor, size: 20),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Tabs
                  Container(
                    padding: const EdgeInsets.all(4),
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
                    child: Row(
                      children: [
                        _buildTab(
                            'All',
                            _getStatusCount('All', isDark, primaryColor,
                                secondaryTextColor),
                            0,
                            primaryColor,
                            cardColor,
                            textColor),
                        _buildTab(
                            'Available',
                            _getStatusCount('Available', isDark, primaryColor,
                                secondaryTextColor),
                            1,
                            primaryColor,
                            cardColor,
                            textColor),
                        _buildTab(
                            'Booked',
                            _getStatusCount('Booked', isDark, primaryColor,
                                secondaryTextColor),
                            2,
                            primaryColor,
                            cardColor,
                            textColor),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Builder(
                builder: (context) {
                  final filteredTables = _getFilteredTables(
                      isDark, primaryColor, secondaryTextColor);

                  if (filteredTables.isEmpty) {
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
                            'No tables found',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: secondaryTextColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'Try a different search term'
                                : 'No tables in this category',
                            style: TextStyle(
                              fontSize: 14,
                              color: secondaryTextColor.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                    itemCount: filteredTables.length +
                        1, // +1 for the "View more" button
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      if (index == filteredTables.length) {
                        // Load More Button
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: TextButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.expand_more,
                                  size: 18, color: secondaryTextColor),
                              label: Text(
                                'View more tables',
                                style: TextStyle(
                                  color: secondaryTextColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        );
                      }

                      final table = filteredTables[index];
                      return _buildTableCard(
                        icon: table.icon,
                        iconColor: table.iconColor,
                        iconBgColor: table.iconBgColor,
                        tableName: table.tableName,
                        section: table.section,
                        seats: table.seats,
                        status: table.status,
                        statusColor: table.statusColor,
                        cardColor: cardColor,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                        opacity: table.opacity,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label, int count, int index, Color primaryColor,
      Color cardColor, Color textColor) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (index == 0) ...[
                // Only show count for "All" tab
                const SizedBox(width: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white.withOpacity(0.8)
                          : const Color(0xFF64748B),
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String tableName,
    required String section,
    required int seats,
    required String status,
    required Color statusColor,
    required Color cardColor,
    required Color textColor,
    required Color secondaryTextColor,
    double opacity = 1.0,
  }) {
    return Opacity(
      opacity: opacity,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookTableScreen(
                restaurant: widget.restaurant,
                tableName: tableName,
              ),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.transparent),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 16),

              // Table Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tableName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      section,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: secondaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.group, size: 14, color: secondaryTextColor),
                        const SizedBox(width: 4),
                        Text(
                          '$seats Seats',
                          style: TextStyle(
                            fontSize: 12,
                            color: secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Status and Menu
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.more_vert,
                        size: 20, color: secondaryTextColor),
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
