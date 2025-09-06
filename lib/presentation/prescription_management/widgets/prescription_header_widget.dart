import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PrescriptionHeaderWidget extends StatelessWidget {
  final int prescriptionCount;
  final bool reminderEnabled;
  final VoidCallback onReminderToggle;

  const PrescriptionHeaderWidget({
    super.key,
    required this.prescriptionCount,
    required this.reminderEnabled,
    required this.onReminderToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildPrescriptionCount(context, colorScheme),
              ),
              SizedBox(width: 4.w),
              _buildReminderToggle(context, colorScheme),
            ],
          ),
          SizedBox(height: 2.h),
          _buildQuickStats(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildPrescriptionCount(
      BuildContext context, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIconWidget(
              iconName: 'medication',
              color: colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              "Active Prescriptions",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14.sp,
                  ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Text(
          prescriptionCount.toString(),
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 32.sp,
                color: colorScheme.primary,
              ),
        ),
        Text(
          prescriptionCount == 1 ? "Medicine" : "Medicines",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 12.sp,
              ),
        ),
      ],
    );
  }

  Widget _buildReminderToggle(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName:
                reminderEnabled ? 'notifications_active' : 'notifications_off',
            color: reminderEnabled
                ? colorScheme.primary
                : colorScheme.onSurface.withValues(alpha: 0.5),
            size: 28,
          ),
          SizedBox(height: 1.h),
          Text(
            "Medicine\nReminders",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Transform.scale(
            scale: 1.2,
            child: Switch(
              value: reminderEnabled,
              onChanged: (_) => onReminderToggle(),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, ColorScheme colorScheme) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            context,
            colorScheme,
            'schedule',
            'Next Dose',
            '2:30 PM',
            Colors.blue,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildStatItem(
            context,
            colorScheme,
            'local_pharmacy',
            'Refills Due',
            '2',
            Colors.orange,
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: _buildStatItem(
            context,
            colorScheme,
            'check_circle',
            'Completed',
            '85%',
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    ColorScheme colorScheme,
    String iconName,
    String label,
    String value,
    Color accentColor,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 2.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            color: accentColor,
            size: 20,
          ),
          SizedBox(height: 0.5.h),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                  color: accentColor,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 9.sp,
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
