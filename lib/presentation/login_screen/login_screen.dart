import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/app_logo_widget.dart';
import './widgets/biometric_auth_widget.dart';
import './widgets/login_form_widget.dart';
import './widgets/registration_link_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  bool _isBiometricEnabled = true;
  final ScrollController _scrollController = ScrollController();

  // Mock credentials for different user roles
  final Map<String, Map<String, dynamic>> _mockCredentials = {
    '9876543210': {
      'password': 'patient123',
      'role': 'patient',
      'name': 'Rajesh Kumar',
      'route': '/patient-dashboard',
    },
    '9876543211': {
      'password': 'doctor123',
      'role': 'doctor',
      'name': 'Dr. Priya Sharma',
      'route': '/doctor-dashboard',
    },
    '9876543212': {
      'password': 'admin123',
      'role': 'admin',
      'name': 'Admin User',
      'route': '/doctor-dashboard',
    },
    '9876543213': {
      'password': 'chemist123',
      'role': 'chemist',
      'name': 'Pharmacist Amit',
      'route': '/prescription-management',
    },
  };

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _checkBiometricAvailability() {
    // In a real app, you would check for biometric availability
    // For demo purposes, we'll assume it's available
    setState(() {
      _isBiometricEnabled = true;
    });
  }

  Future<void> _handleLogin(String mobile, String password) async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      // Check credentials
      final userCredentials = _mockCredentials[mobile];

      if (userCredentials != null && userCredentials['password'] == password) {
        // Success - provide haptic feedback
        HapticFeedback.lightImpact();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Welcome back, ${userCredentials['name']}!',
              style: TextStyle(fontSize: 14.sp),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            duration: const Duration(seconds: 2),
          ),
        );

        // Navigate to appropriate dashboard
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            userCredentials['route'],
            (route) => false,
          );
        }
      } else {
        // Error - show specific error message
        String errorMessage = 'Invalid credentials. Please try again.';

        if (userCredentials == null) {
          errorMessage =
              'Mobile number not registered. Please create an account.';
        } else if (userCredentials['password'] != password) {
          errorMessage =
              'Incorrect password. Please try again or reset your password.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorMessage,
              style: TextStyle(fontSize: 14.sp),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleBiometricAuth() {
    // Simulate successful biometric authentication
    // Navigate to patient dashboard as default
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/patient-dashboard',
      (route) => false,
    );
  }

  void _handleRegisterTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Registration feature coming soon. Please contact support for account creation.',
          style: TextStyle(fontSize: 14.sp),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 4.h),

                  // App Logo and Branding
                  const AppLogoWidget(),

                  SizedBox(height: 4.h),

                  // Welcome Text
                  Text(
                    'Welcome Back',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w600,
                      fontSize: 24.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 1.h),

                  Text(
                    'Sign in to continue your Ayurvedic wellness journey',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                      fontSize: 14.sp,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 4.h),

                  // Login Form
                  LoginFormWidget(
                    onLogin: _handleLogin,
                    isLoading: _isLoading,
                  ),

                  // Biometric Authentication
                  BiometricAuthWidget(
                    onBiometricAuth: _handleBiometricAuth,
                    isEnabled: _isBiometricEnabled && !_isLoading,
                  ),

                  // Registration Link
                  RegistrationLinkWidget(
                    onRegisterTap: _handleRegisterTap,
                  ),

                  SizedBox(height: 2.h),

                  // Demo Credentials Info
                  Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(2.w),
                      border: Border.all(
                        color: colorScheme.primary.withValues(alpha: 0.2),
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'info',
                              color: colorScheme.primary,
                              size: 5.w,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Demo Credentials',
                              style: theme.textTheme.titleSmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'Patient: 9876543210 / patient123\n'
                          'Doctor: 9876543211 / doctor123\n'
                          'Admin: 9876543212 / admin123\n'
                          'Chemist: 9876543213 / chemist123',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.8),
                            fontSize: 12.sp,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
