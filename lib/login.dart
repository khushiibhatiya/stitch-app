import 'package:flutter/material.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Fallback color
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/loginpage.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                   // Gradient or dimming overlay for better text visibility if needed
                   Container(
                     decoration: BoxDecoration(
                       gradient: LinearGradient(
                         begin: Alignment.topCenter,
                         end: Alignment.bottomCenter,
                         colors: [Colors.black.withOpacity(0.3), Colors.transparent],
                       ),
                     ),
                   ),
                   SafeArea(
                     child: Padding(
                       padding: const EdgeInsets.all(16.0),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                            CircleAvatar(
                              backgroundColor: Colors.white.withOpacity(0.2),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                         ],
                       ),
                     ),
                   ),
                   const Positioned(
                     bottom: 40, // Space for the curved sheet overlap
                     left: 24,
                     right: 24,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Text(
                           'Welcome Back',
                           textAlign: TextAlign.center,
                           style: TextStyle(
                             color: Colors.white,
                             fontSize: 32,
                             fontWeight: FontWeight.bold,
                             fontFamily: 'Inter',
                           ),
                         ),
                         SizedBox(height: 8),
                         Text(
                           'Sign in to manage your reservations',
                           textAlign: TextAlign.center,
                           style: TextStyle(
                             color: Colors.white70,
                             fontSize: 16,
                           ),
                         ),
                       ],
                     ),
                   )
                ],
              ),
            ),
          ),
          
          // Foreground Sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.60,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F6FA), // Match background color from register screen or design
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildLabel('Email Address'),
                    _buildTextField(
                      hint: 'guest@hotel.com',
                      icon: Icons.email_outlined,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildLabel('Password', paddingBottom: 0),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Color(0xFF1E60F7),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildTextField(
                      hint: '••••••••',
                      isPassword: true,
                      isVisible: _isPasswordVisible,
                      icon: Icons.lock_outline,
                       onVisibilityToggle: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    
                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E60F7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 4,
                          shadowColor: const Color(0xFF1E60F7).withOpacity(0.4),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Log In',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, color: Colors.white),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Social Login
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[300])),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'OR CONTINUE WITH',
                            style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey[300])),
                      ],
                    ),
                    const SizedBox(height: 24),
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialCircleButton(
                          // Google Placeholder
                          child: Text('G', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 24)),
                        ),
                        const SizedBox(width: 24),
                         _buildSocialCircleButton(
                          child: const Icon(Icons.apple, color: Colors.black, size: 28),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    
                     // Footer
                    Center(
                      child: GestureDetector(
                        onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterScreen()),
                          );
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: 'Don\'t have an account? ',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                            children: [
                              TextSpan(
                                text: 'Sign Up',
                                style: TextStyle(
                                  color: Color(0xFF1E60F7),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text, {double paddingBottom = 8.0}) {
    return Padding(
      padding: EdgeInsets.only(bottom: paddingBottom),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    IconData? icon,
    bool isPassword = false,
    bool isVisible = false,
    VoidCallback? onVisibilityToggle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        obscureText: isPassword && !isVisible,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: Icon(icon, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    isVisible ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: onVisibilityToggle,
                )
              : null,
        ),
      ),
    );
  }

   Widget _buildSocialCircleButton({required Widget child}) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(child: child),
    );
  }
}
