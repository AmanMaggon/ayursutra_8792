import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AppLogoWidget extends StatelessWidget {
  final bool isCompact;

  const AppLogoWidget({
    super.key,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(vertical: isCompact ? 2.h : 4.h),
      child: Column(
        children: [
          // App Logo Container
          Container(
            width: isCompact ? 20.w : 25.w,
            height: isCompact ? 20.w : 25.w,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.3),
                width: 2.0,
              ),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: 'local_hospital',
                color: colorScheme.primary,
                size: isCompact ? 10.w : 12.w,
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // App Name
          Text(
            'AyurSutra',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
              fontSize: isCompact ? 24.sp : 28.sp,
              letterSpacing: 0.5,
            ),
          ),

          SizedBox(height: 0.5.h),

          // App Tagline
          Text(
            'Traditional Healing, Modern Care',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w400,
              fontSize: isCompact ? 12.sp : 14.sp,
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),

          if (!isCompact) ...[
            SizedBox(height: 1.h),

            // Trust Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTrustBadge(
                  context,
                  'AYUSH Certified',
                  'verified',
                  colorScheme.primary,
                ),
                SizedBox(width: 4.w),
                _buildTrustBadge(
                  context,
                  'Government Approved',
                  'security',
                  colorScheme.secondary,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTrustBadge(
    BuildContext context,
    String text,
    String iconName,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(1.w),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: color,
            size: 3.w,
          ),
          SizedBox(width: 1.w),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
