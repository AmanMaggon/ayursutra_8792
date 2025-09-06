import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class LoginFormWidget extends StatefulWidget {
  final Function(String, String) onLogin;
  final bool isLoading;

  const LoginFormWidget({
    super.key,
    required this.onLogin,
    required this.isLoading,
  });

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _mobileController.addListener(_validateForm);
    _passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final isValid = _mobileController.text.length == 10 &&
        _passwordController.text.length >= 6;
    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  String? _validateMobile(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mobile number is required';
    }
    if (value.length != 10) {
      return 'Please enter a valid 10-digit mobile number';
    }
    if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(value)) {
      return 'Please enter a valid Indian mobile number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onLogin(_mobileController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Mobile Number Field
          Container(
            margin: EdgeInsets.only(bottom: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mobile Number',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 16.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your mobile number',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'phone',
                        color: colorScheme.primary,
                        size: 6.w,
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.w),
                      borderSide: BorderSide(
                        color: colorScheme.outline,
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.w),
                      borderSide: BorderSide(
                        color: colorScheme.outline,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.w),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 2.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.w),
                      borderSide: BorderSide(
                        color: colorScheme.error,
                        width: 1.0,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.w),
                      borderSide: BorderSide(
                        color: colorScheme.error,
                        width: 2.0,
                      ),
                    ),
                  ),
                  validator: _validateMobile,
                  enabled: !widget.isLoading,
                ),
              ],
            ),
          ),

          // Password Field
          Container(
            margin: EdgeInsets.only(bottom: 1.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Password',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 1.h),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 16.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(3.w),
                      child: CustomIconWidget(
                        iconName: 'lock',
                        color: colorScheme.primary,
                        size: 6.w,
                      ),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: widget.isLoading
                          ? null
                          : () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                      child: Container(
                        padding: EdgeInsets.all(3.w),
                        child: CustomIconWidget(
                          iconName: _isPasswordVisible
                              ? 'visibility'
                              : 'visibility_off',
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                          size: 6.w,
                        ),
                      ),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 2.h,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.w),
                      borderSide: BorderSide(
                        color: colorScheme.outline,
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.w),
                      borderSide: BorderSide(
                        color: colorScheme.outline,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.w),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 2.0,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.w),
                      borderSide: BorderSide(
                        color: colorScheme.error,
                        width: 1.0,
                      ),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.w),
                      borderSide: BorderSide(
                        color: colorScheme.error,
                        width: 2.0,
                      ),
                    ),
                  ),
                  validator: _validatePassword,
                  enabled: !widget.isLoading,
                ),
              ],
            ),
          ),

          // Forgot Password Link
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.isLoading
                  ? null
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Forgot password feature coming soon'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
                minimumSize: Size(20.w, 6.h),
              ),
              child: Text(
                'Forgot Password?',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Login Button
          SizedBox(
            height: 7.h,
            child: ElevatedButton(
              onPressed:
                  (_isFormValid && !widget.isLoading) ? _handleLogin : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                disabledBackgroundColor:
                    colorScheme.onSurface.withValues(alpha: 0.12),
                disabledForegroundColor:
                    colorScheme.onSurface.withValues(alpha: 0.38),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
                elevation: widget.isLoading ? 0 : 2,
              ),
              child: widget.isLoading
                  ? SizedBox(
                      height: 5.w,
                      width: 5.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          colorScheme.onPrimary,
                        ),
                      ),
                    )
                  : Text(
                      'Login',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
