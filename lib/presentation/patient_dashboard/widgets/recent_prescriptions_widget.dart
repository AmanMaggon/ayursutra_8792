import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class RecentPrescriptionsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> prescriptions;
  final Function(Map<String, dynamic>, bool) onReminderToggle;

  const RecentPrescriptionsWidget({
    super.key,
    required this.prescriptions,
    required this.onReminderToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (prescriptions.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Prescriptions',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/prescription-management');
                },
                child: Text(
                  'View All',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          itemCount: prescriptions.length > 3 ? 3 : prescriptions.length,
          separatorBuilder: (context, index) => SizedBox(height: 2.h),
          itemBuilder: (context, index) {
            final prescription = prescriptions[index];
            return _buildPrescriptionCard(context, prescription);
          },
        ),
      ],
    );
  }

  Widget _buildPrescriptionCard(
      BuildContext context, Map<String, dynamic> prescription) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final DateTime prescribedDate = prescription['prescribedDate'] as DateTime;
    final bool reminderEnabled = prescription['reminderEnabled'] as bool;
    final List<dynamic> medicines = prescription['medicines'] as List<dynamic>;

    return Container(
      width: double.infinity,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: CustomIconWidget(
                  iconName: 'medication',
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prescription['doctorName'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Prescribed on ${prescribedDate.day}/${prescribedDate.month}/${prescribedDate.year}',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: reminderEnabled,
                onChanged: (value) => onReminderToggle(prescription, value),
                activeColor: colorScheme.primary,
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'Medicines (${medicines.length})',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          SizedBox(height: 1.h),
          ...medicines.take(2).map((medicine) {
            final medicineMap = medicine as Map<String, dynamic>;
            return Padding(
              padding: EdgeInsets.only(bottom: 1.h),
              child: Row(
                children: [
                  Container(
                    width: 1.w,
                    height: 1.w,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      '${medicineMap['name']} - ${medicineMap['dosage']}',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w400,
                        color: colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.w),
                    decoration: BoxDecoration(
                      color: _getStatusColor(medicineMap['status'] as String)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(1.w),
                    ),
                    child: Text(
                      medicineMap['status'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w500,
                        color: _getStatusColor(medicineMap['status'] as String),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          if (medicines.length > 2)
            Padding(
              padding: EdgeInsets.only(left: 3.w),
              child: Text(
                '+${medicines.length - 2} more medicines',
                style: GoogleFonts.inter(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: colorScheme.primary,
                ),
              ),
            ),
          SizedBox(height: 2.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, '/prescription-management');
                  },
                  icon: CustomIconWidget(
                    iconName: 'visibility',
                    color: colorScheme.primary,
                    size: 16,
                  ),
                  label: Text(
                    'View Details',
                    style: GoogleFonts.inter(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.w),
                    side: BorderSide(color: colorScheme.primary, width: 1),
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: reminderEnabled
                      ? colorScheme.primary.withValues(alpha: 0.1)
                      : colorScheme.onSurface.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(1.w),
                ),
                child: CustomIconWidget(
                  iconName: reminderEnabled
                      ? 'notifications_active'
                      : 'notifications_off',
                  color: reminderEnabled
                      ? colorScheme.primary
                      : colorScheme.onSurface.withValues(alpha: 0.5),
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'medication',
            color: colorScheme.onSurface.withValues(alpha: 0.5),
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No Recent Prescriptions',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Your prescribed medicines will appear here',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      case 'expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}