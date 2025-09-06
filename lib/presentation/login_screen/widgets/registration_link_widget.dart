import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class RegistrationLinkWidget extends StatelessWidget {
  final VoidCallback onRegisterTap;

  const RegistrationLinkWidget({
    super.key,
    required this.onRegisterTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(top: 4.h, bottom: 2.h),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          // Welcome Text
          Text(
            'New to Ayurvedic Care?',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 1.h),

          // Description
          Text(
            'Join thousands of patients experiencing traditional healing with modern convenience',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 14.sp,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 2.h),

          // Register Button
          SizedBox(
            width: double.infinity,
            height: 6.h,
            child: OutlinedButton.icon(
              onPressed: onRegisterTap,
              icon: CustomIconWidget(
                iconName: 'person_add',
                color: colorScheme.primary,
                size: 5.w,
              ),
              label: Text(
                'Create Account',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: colorScheme.primary,
                  width: 2.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.w),
                ),
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              ),
            ),
          ),

          SizedBox(height: 1.5.h),

          // Benefits List
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildBenefit(
                context,
                'Free Consultation',
                'medical_services',
                colorScheme.primary,
              ),
              _buildBenefit(
                context,
                'Digital Prescriptions',
                'receipt',
                colorScheme.secondary,
              ),
              _buildBenefit(
                context,
                '24/7 Support',
                'support_agent',
                colorScheme.tertiary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBenefit(
    BuildContext context,
    String text,
    String iconName,
    Color color,
  ) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: iconName,
                color: color,
                size: 6.w,
              ),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
