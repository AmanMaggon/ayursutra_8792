import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class BiometricAuthWidget extends StatefulWidget {
  final VoidCallback onBiometricAuth;
  final bool isEnabled;

  const BiometricAuthWidget({
    super.key,
    required this.onBiometricAuth,
    required this.isEnabled,
  });

  @override
  State<BiometricAuthWidget> createState() => _BiometricAuthWidgetState();
}

class _BiometricAuthWidgetState extends State<BiometricAuthWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleBiometricAuth() async {
    if (!widget.isEnabled || _isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    // Simulate biometric authentication process
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });

      // For demo purposes, show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Biometric authentication successful! Redirecting to dashboard...',
            style: TextStyle(fontSize: 14.sp),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          duration: const Duration(seconds: 2),
        ),
      );

      // Simulate successful authentication
      await Future.delayed(const Duration(seconds: 1));
      widget.onBiometricAuth();
    }
  }

  String _getBiometricText() {
    if (kIsWeb) {
      return 'Browser Authentication';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'Face ID / Touch ID';
    } else {
      return 'Fingerprint / Face Unlock';
    }
  }

  String _getBiometricIcon() {
    if (kIsWeb) {
      return 'security';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'face';
    } else {
      return 'fingerprint';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!widget.isEnabled) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 3.h),
      child: Column(
        children: [
          // Divider with "OR" text
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                  thickness: 1,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  'OR',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: colorScheme.outline.withValues(alpha: 0.3),
                  thickness: 1,
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Biometric Authentication Button
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: GestureDetector(
                  onTap: _handleBiometricAuth,
                  child: Container(
                    width: 20.w,
                    height: 20.w,
                    decoration: BoxDecoration(
                      color: widget.isEnabled
                          ? colorScheme.primary.withValues(alpha: 0.1)
                          : colorScheme.onSurface.withValues(alpha: 0.05),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: widget.isEnabled
                            ? colorScheme.primary
                            : colorScheme.onSurface.withValues(alpha: 0.2),
                        width: 2.0,
                      ),
                    ),
                    child: _isProcessing
                        ? Center(
                            child: SizedBox(
                              width: 8.w,
                              height: 8.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colorScheme.primary,
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: CustomIconWidget(
                              iconName: _getBiometricIcon(),
                              color: widget.isEnabled
                                  ? colorScheme.primary
                                  : colorScheme.onSurface
                                      .withValues(alpha: 0.4),
                              size: 10.w,
                            ),
                          ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 2.h),

          // Biometric Text
          Text(
            _getBiometricText(),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: widget.isEnabled
                  ? colorScheme.onSurface
                  : colorScheme.onSurface.withValues(alpha: 0.4),
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.h),

          // Helper Text
          Text(
            _isProcessing
                ? 'Authenticating...'
                : 'Touch to authenticate with biometrics',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
