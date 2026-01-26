import 'package:flutter/material.dart';
import 'package:stitch/core/services/data_manager.dart';
import 'package:stitch/core/models/table.dart';

class TableManagementScreen extends StatefulWidget {
  final String restaurantId;
  final String restaurantName;

  const TableManagementScreen({
    super.key,
    required this.restaurantId,
    required this.restaurantName,
  });

  @override
  State<TableManagementScreen> createState() => _TableManagementScreenState();
}

class _TableManagementScreenState extends State<TableManagementScreen> {
  void _showTableDialog({RestaurantTable? tableToEdit}) {
    final isEditing = tableToEdit != null;
    final nameController =
        TextEditingController(text: tableToEdit?.tableName ?? '');
    final sectionController =
        TextEditingController(text: tableToEdit?.section ?? 'Main Hall');
    final seatsController =
        TextEditingController(text: tableToEdit?.seats.toString() ?? '4');

    String selectedStatus = tableToEdit?.status ?? 'Available';

    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final backgroundColor =
            isDark ? const Color(0xFF1E2330) : const Color(0xFFF5F6FA);
        final textColor = isDark ? Colors.white : const Color(0xFF111318);
        final inputFillColor = isDark ? const Color(0xFF111621) : Colors.white;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEditing ? 'Edit Table' : 'Add New Table',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildLabel('Table Name', textColor),
                    _buildThemedTextField(
                        nameController,
                        'e.g., Table 1, VIP-A',
                        Icons.table_restaurant,
                        inputFillColor,
                        textColor),
                    const SizedBox(height: 16),
                    _buildLabel('Section', textColor),
                    _buildThemedTextField(
                        sectionController,
                        'e.g., Main Hall, Patio',
                        Icons.location_on,
                        inputFillColor,
                        textColor),
                    const SizedBox(height: 16),
                    _buildLabel('Seats', textColor),
                    _buildThemedTextField(seatsController, 'Number of seats',
                        Icons.people, inputFillColor, textColor,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 16),
                    _buildLabel('Status', textColor),
                    Container(
                      decoration: BoxDecoration(
                        color: inputFillColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedStatus,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                          dropdownColor: inputFillColor,
                          style: TextStyle(color: textColor, fontSize: 16),
                          items: ['Available', 'Booked', 'Maintenance']
                              .map((String status) {
                            Color statusColor;
                            IconData statusIcon;
                            switch (status) {
                              case 'Available':
                                statusColor = Colors.green;
                                statusIcon = Icons.check_circle;
                                break;
                              case 'Booked':
                                statusColor = Colors.orange;
                                statusIcon = Icons.event_busy;
                                break;
                              case 'Maintenance':
                                statusColor = Colors.grey;
                                statusIcon = Icons.build;
                                break;
                              default:
                                statusColor = Colors.grey;
                                statusIcon = Icons.help;
                            }
                            return DropdownMenuItem<String>(
                              value: status,
                              child: Row(
                                children: [
                                  Icon(statusIcon,
                                      color: statusColor, size: 20),
                                  const SizedBox(width: 12),
                                  Text(status),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setDialogState(() {
                                selectedStatus = newValue;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: textColor.withOpacity(0.7),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (nameController.text.isNotEmpty &&
                                  sectionController.text.isNotEmpty &&
                                  seatsController.text.isNotEmpty) {
                                final seats =
                                    int.tryParse(seatsController.text) ?? 4;
                                final tableId = isEditing
                                    ? tableToEdit.id
                                    : DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString();

                                final newTable = RestaurantTable(
                                  id: tableId,
                                  restaurantId: widget.restaurantId,
                                  tableName: nameController.text,
                                  section: sectionController.text,
                                  seats: seats,
                                  status: selectedStatus,
                                  icon: Icons.table_restaurant,
                                );

                                if (isEditing) {
                                  DataManager().updateTable(tableId, newTable);
                                } else {
                                  DataManager().addTable(newTable);
                                }
                                setState(() {});
                                Navigator.pop(context);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E60F7),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              elevation: 4,
                              shadowColor:
                                  const Color(0xFF1E60F7).withOpacity(0.4),
                            ),
                            child: Text(
                              isEditing ? 'Update' : 'Add',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLabel(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: color,
        ),
      ),
    );
  }

  Widget _buildThemedTextField(
    TextEditingController controller,
    String hint,
    IconData icon,
    Color fillColor,
    Color textColor, {
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(icon, color: Colors.grey),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tables = DataManager().getTablesForRestaurant(widget.restaurantId);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = const Color(0xFF1E60F7);
    final backgroundColor =
        isDark ? const Color(0xFF111621) : const Color(0xFFF6F8F7);
    final cardColor = isDark ? const Color(0xFF1E2330) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF111318);
    final secondaryTextColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF636F88);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Manage Tables - ${widget.restaurantName}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Inter',
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      body: tables.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.table_restaurant,
                      size: 64, color: secondaryTextColor.withOpacity(0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'No tables found',
                    style: TextStyle(
                      fontSize: 18,
                      color: secondaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add a table',
                    style: TextStyle(
                      fontSize: 14,
                      color: secondaryTextColor.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: tables.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final table = tables[index];
                final statusColor = table.isAvailable
                    ? Colors.green
                    : table.isBooked
                        ? Colors.orange
                        : Colors.grey;

                return Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.table_restaurant,
                          color: primaryColor, size: 28),
                    ),
                    title: Text(
                      table.tableName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 12,
                          runSpacing: 4,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.location_on,
                                    size: 14, color: secondaryTextColor),
                                const SizedBox(width: 4),
                                Text(
                                  table.section,
                                  style: TextStyle(color: secondaryTextColor),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.people,
                                    size: 14, color: secondaryTextColor),
                                const SizedBox(width: 4),
                                Text(
                                  '${table.seats} seats',
                                  style: TextStyle(color: secondaryTextColor),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            table.status,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: primaryColor, size: 20),
                          onPressed: () => _showTableDialog(tableToEdit: table),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete,
                              color: Colors.red, size: 20),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Delete Table'),
                                content: Text(
                                    'Are you sure you want to delete ${table.tableName}?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      DataManager().deleteTable(
                                          widget.restaurantId, table.tableName);
                                      setState(() {});
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
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
          onPressed: () => _showTableDialog(),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
