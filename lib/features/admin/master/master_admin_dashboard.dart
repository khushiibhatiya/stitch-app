import 'package:flutter/material.dart';
import 'package:stitch/core/services/data_manager.dart';
import 'package:stitch/core/models/admin_user.dart';
import 'package:stitch/features/auth/screens/login.dart';

class MasterAdminDashboardScreen extends StatefulWidget {
  const MasterAdminDashboardScreen({super.key});

  @override
  State<MasterAdminDashboardScreen> createState() =>
      _MasterAdminDashboardScreenState();
}

class _MasterAdminDashboardScreenState
    extends State<MasterAdminDashboardScreen> {
  void _showAdminDialog({AdminUser? adminToEdit}) {
    final isEditing = adminToEdit != null;
    final emailController =
        TextEditingController(text: adminToEdit?.email ?? '');
    final passwordController =
        TextEditingController(text: adminToEdit?.password ?? '');
    final nameController =
        TextEditingController(text: adminToEdit?.restaurantName ?? '');
    final idController =
        TextEditingController(text: adminToEdit?.restaurantId ?? '');

    showDialog(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final backgroundColor =
            isDark ? const Color(0xFF1E2330) : const Color(0xFFF5F6FA);
        final textColor = isDark ? Colors.white : const Color(0xFF111318);
        final inputFillColor = isDark ? const Color(0xFF111621) : Colors.white;

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
                  isEditing ? 'Edit Admin' : 'Add New Admin',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 24),
                _buildLabel('Email', textColor),
                _buildThemedTextField(
                    emailController, 'Enter email', Icons.email, inputFillColor, textColor),
                const SizedBox(height: 16),
                _buildLabel('Password', textColor),
                _buildThemedTextField(passwordController, 'Enter password',
                    Icons.lock, inputFillColor, textColor),
                const SizedBox(height: 16),
                _buildLabel('Restaurant Name', textColor),
                _buildThemedTextField(nameController, 'Enter name',
                    Icons.store, inputFillColor, textColor),
                const SizedBox(height: 16),
                _buildLabel('Restaurant ID', textColor),
                _buildThemedTextField(idController, 'Enter ID',
                    Icons.confirmation_number, inputFillColor, textColor),
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
                          if (emailController.text.isNotEmpty &&
                              passwordController.text.isNotEmpty &&
                              nameController.text.isNotEmpty &&
                              idController.text.isNotEmpty) {
                            final newAdmin = AdminUser(
                              email: emailController.text,
                              password: passwordController.text,
                              restaurantId: idController.text,
                              restaurantName: nameController.text,
                            );

                            if (isEditing) {
                              DataManager()
                                  .updateAdmin(adminToEdit.email, newAdmin);
                            } else {
                              DataManager().addAdmin(newAdmin);
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
                          shadowColor: const Color(0xFF1E60F7).withOpacity(0.4),
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

  Widget _buildThemedTextField(TextEditingController controller, String hint,
      IconData icon, Color fillColor, Color textColor) {
    return Container(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
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

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final admins = DataManager().admins.where((a) => !a.isMaster).toList();
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
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top App Bar
            Container(
              color: backgroundColor.withOpacity(0.95),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Master Control',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: secondaryTextColor),
                      ),
                      Text(
                        'Admin Management',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textColor,
                          letterSpacing: -0.015,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.logout, size: 24, color: textColor),
                      onPressed: _logout,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),

            // Admin List
            Expanded(
              child: admins.isEmpty
                  ? Center(
                      child: Text(
                        'No admins found',
                        style: TextStyle(color: secondaryTextColor),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: admins.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final admin = admins[index];
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
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            leading: Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.person,
                                  color: primaryColor, size: 24),
                            ),
                            title: Text(
                              admin.restaurantName,
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
                                Text(
                                  'Email: ${admin.email}',
                                  style: TextStyle(color: secondaryTextColor),
                                ),
                                Text(
                                  'ID: ${admin.restaurantId}',
                                  style: TextStyle(color: secondaryTextColor),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit,
                                      color: primaryColor, size: 20),
                                  onPressed: () =>
                                      _showAdminDialog(adminToEdit: admin),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red, size: 20),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Delete Admin'),
                                        content: Text(
                                            'Are you sure you want to delete admin for ${admin.restaurantName}?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              DataManager()
                                                  .deleteAdmin(admin.email);
                                              setState(() {});
                                              Navigator.pop(context);
                                            },
                                            child: const Text(
                                              'Delete',
                                              style:
                                                  TextStyle(color: Colors.red),
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
            ),
          ],
        ),
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
          onPressed: () => _showAdminDialog(),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
