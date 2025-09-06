import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ActionCardsWidget extends StatelessWidget {
  final VoidCallback onBookConsultation;
  final VoidCallback onViewPrescriptions;
  final VoidCallback onFindDoctors;
  final VoidCallback onHealthRecords;

  const ActionCardsWidget({
    super.key,
    required this.onBookConsultation,
    required this.onViewPrescriptions,
    required this.onFindDoctors,
    required this.onHealthRecords,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        children: [
          // Primary action card - Book Consultation
          _buildPrimaryActionCard(
            context: context,
            title: 'Book Consultation',
            subtitle: 'Connect with Ayurvedic doctors',
            icon: 'medical_services',
            onTap: onBookConsultation,
            backgroundColor: colorScheme.primary,
            textColor: colorScheme.onPrimary,
          ),
          SizedBox(height: 3.h),
          // Secondary action cards grid
          Row(
            children: [
              Expanded(
                child: _buildSecondaryActionCard(
                  context: context,
                  title: 'View Prescriptions',
                  icon: 'receipt_long',
                  onTap: onViewPrescriptions,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildSecondaryActionCard(
                  context: context,
                  title: 'Find Nearby Doctors',
                  icon: 'location_on',
                  onTap: onFindDoctors,
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          // Health Records card
          _buildSecondaryActionCard(
            context: context,
            title: 'Health Records',
            icon: 'folder_shared',
            onTap: onHealthRecords,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryActionCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String icon,
    required VoidCallback onTap,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(5.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(4.w),
          boxShadow: [
            BoxShadow(
              color: backgroundColor.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: textColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(3.w),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: textColor,
                size: 32,
              ),
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: textColor.withValues(alpha: 0.9),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            CustomIconWidget(
              iconName: 'arrow_forward_ios',
              color: textColor.withValues(alpha: 0.8),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryActionCard({
    required BuildContext context,
    required String title,
    required String icon,
    required VoidCallback onTap,
    bool isFullWidth = false,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isFullWidth ? double.infinity : null,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(2.w),
              ),
              child: CustomIconWidget(
                iconName: icon,
                color: colorScheme.primary,
                size: 28,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}