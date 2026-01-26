import 'package:flutter/material.dart';
import 'package:stitch/core/services/data_manager.dart';
import 'package:stitch/core/models/admin_user.dart';
import 'package:stitch/core/models/restaurant.dart';
import 'package:stitch/features/auth/screens/login.dart';
import 'package:stitch/features/admin/table_management_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MasterAdminDashboardScreen extends StatefulWidget {
  const MasterAdminDashboardScreen({super.key});

  @override
  State<MasterAdminDashboardScreen> createState() =>
      _MasterAdminDashboardScreenState();
}

class _MasterAdminDashboardScreenState
    extends State<MasterAdminDashboardScreen> {
  void _showRestaurantAdminDialog(
      {Restaurant? restaurantToEdit, AdminUser? adminToEdit}) {
    final isEditing = restaurantToEdit != null;

    // Restaurant fields
    final nameController =
        TextEditingController(text: restaurantToEdit?.name ?? '');
    final cuisineController =
        TextEditingController(text: restaurantToEdit?.cuisine ?? '');
    String? selectedImagePath = restaurantToEdit?.image;
    final ratingController = TextEditingController(
        text: restaurantToEdit?.rating.toString() ?? '4.5');

    // Admin fields
    final emailController =
        TextEditingController(text: adminToEdit?.email ?? '');
    final passwordController =
        TextEditingController(text: adminToEdit?.password ?? '');

    Future<void> pickImage(StateSetter setDialogState) async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setDialogState(() {
          selectedImagePath = image.path;
        });
      }
    }

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
                  borderRadius: BorderRadius.circular(24)),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isEditing
                          ? 'Edit Restaurant & Admin'
                          : 'Add New Restaurant & Admin',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Restaurant Section
                    Text('Restaurant Details',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor)),
                    const SizedBox(height: 16),
                    _buildLabel('Restaurant Name', textColor),
                    _buildThemedTextField(nameController, 'Enter name',
                        Icons.restaurant, inputFillColor, textColor),
                    const SizedBox(height: 16),
                    _buildLabel('Cuisine', textColor),
                    _buildThemedTextField(
                        cuisineController,
                        'Enter cuisine type',
                        Icons.food_bank,
                        inputFillColor,
                        textColor),
                    const SizedBox(height: 16),
                    _buildLabel('Restaurant Image', textColor),
                    GestureDetector(
                      onTap: () => pickImage(setDialogState),
                      child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                          color: inputFillColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF1E60F7).withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: selectedImagePath != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: selectedImagePath!.startsWith('http')
                                    ? Image.network(
                                        selectedImagePath!,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      )
                                    : Image.file(
                                        File(selectedImagePath!),
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      ),
                              )
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add_photo_alternate,
                                      size: 48,
                                      color: const Color(0xFF1E60F7)
                                          .withOpacity(0.5)),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Tap to upload image',
                                    style: TextStyle(
                                      color: textColor.withOpacity(0.6),
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLabel('Rating', textColor),
                    _buildThemedTextField(
                        ratingController,
                        'Enter rating (0-5)',
                        Icons.star,
                        inputFillColor,
                        textColor,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 24),
                    // Admin Section
                    Text('Admin Details',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: textColor)),
                    const SizedBox(height: 16),
                    _buildLabel('Admin Email', textColor),
                    _buildThemedTextField(emailController, 'Enter email',
                        Icons.email, inputFillColor, textColor),
                    const SizedBox(height: 16),
                    _buildLabel('Admin Password', textColor),
                    _buildThemedTextField(passwordController, 'Enter password',
                        Icons.lock, inputFillColor, textColor),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16)),
                            child: Text('Cancel',
                                style: TextStyle(
                                    color: textColor.withOpacity(0.7),
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (nameController.text.isNotEmpty &&
                                  cuisineController.text.isNotEmpty &&
                                  selectedImagePath != null &&
                                  ratingController.text.isNotEmpty &&
                                  emailController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                final rating =
                                    double.tryParse(ratingController.text) ??
                                        4.5;
                                final restaurantId = isEditing
                                    ? restaurantToEdit.id
                                    : DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString();

                                final newRestaurant = Restaurant(
                                  id: restaurantId,
                                  name: nameController.text,
                                  cuisine: cuisineController.text,
                                  image: selectedImagePath!,
                                  rating: rating,
                                );

                                final newAdmin = AdminUser(
                                  email: emailController.text,
                                  password: passwordController.text,
                                  restaurantId: restaurantId,
                                  restaurantName: nameController.text,
                                );

                                if (isEditing) {
                                  DataManager().updateRestaurant(
                                      restaurantId, newRestaurant);
                                  DataManager().updateAdmin(
                                      adminToEdit!.email, newAdmin);
                                } else {
                                  DataManager().addRestaurant(newRestaurant);
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
                                  borderRadius: BorderRadius.circular(30)),
                              elevation: 4,
                              shadowColor:
                                  const Color(0xFF1E60F7).withOpacity(0.4),
                            ),
                            child: Text(
                              isEditing ? 'Update' : 'Add',
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
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

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final restaurants = DataManager().getAllRestaurants();
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
                        'Restaurant Management',
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
                    decoration: const BoxDecoration(
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

            // Restaurant List
            Expanded(
              child: restaurants.isEmpty
                  ? Center(
                      child: Text(
                        'No restaurants found',
                        style: TextStyle(color: secondaryTextColor),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: restaurants.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final restaurant = restaurants[index];
                        // Find the admin for this restaurant
                        final admin = DataManager().admins.firstWhere(
                              (a) => a.restaurantId == restaurant.id,
                              orElse: () => AdminUser(
                                email: 'No admin',
                                password: '',
                                restaurantId: restaurant.id,
                                restaurantName: restaurant.name,
                              ),
                            );

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
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TableManagementScreen(
                                    restaurantId: restaurant.id,
                                    restaurantName: restaurant.name,
                                  ),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  restaurant.image,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 60,
                                      height: 60,
                                      color: primaryColor.withOpacity(0.1),
                                      child: Icon(Icons.restaurant,
                                          color: primaryColor, size: 30),
                                    );
                                  },
                                ),
                              ),
                              title: Text(
                                restaurant.name,
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
                                    restaurant.cuisine,
                                    style: TextStyle(color: secondaryTextColor),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          size: 14, color: Colors.amber),
                                      const SizedBox(width: 4),
                                      Text(
                                        restaurant.rating.toString(),
                                        style: TextStyle(
                                            color: secondaryTextColor,
                                            fontSize: 12),
                                      ),
                                      const SizedBox(width: 12),
                                      Icon(Icons.person,
                                          size: 14, color: secondaryTextColor),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          admin.email,
                                          style: TextStyle(
                                              color: secondaryTextColor,
                                              fontSize: 12),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit,
                                        color: primaryColor, size: 20),
                                    onPressed: () => _showRestaurantAdminDialog(
                                        restaurantToEdit: restaurant,
                                        adminToEdit: admin),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red, size: 20),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title:
                                              const Text('Delete Restaurant'),
                                          content: Text(
                                              'Are you sure you want to delete ${restaurant.name} and its admin?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                DataManager()
                                                    .deleteRestaurantAndAdmin(
                                                        restaurant.id);
                                                setState(() {});
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Delete',
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: secondaryTextColor,
                                    size: 30,
                                  ),
                                ],
                              ),
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
          onPressed: () => _showRestaurantAdminDialog(),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
