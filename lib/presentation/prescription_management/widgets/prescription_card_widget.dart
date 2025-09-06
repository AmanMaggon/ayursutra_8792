import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PrescriptionCardWidget extends StatelessWidget {
  final Map<String, dynamic> prescription;
  final VoidCallback? onTap;
  final VoidCallback? onReminderToggle;
  final VoidCallback? onFindChemist;
  final VoidCallback? onMarkTaken;
  final VoidCallback? onSkipDose;
  final VoidCallback? onContactDoctor;

  const PrescriptionCardWidget({
    super.key,
    required this.prescription,
    this.onTap,
    this.onReminderToggle,
    this.onFindChemist,
    this.onMarkTaken,
    this.onSkipDose,
    this.onContactDoctor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String status = prescription["status"] as String;
    final int remainingQuantity = prescription["remainingQuantity"] as int;
    final int totalQuantity = prescription["totalQuantity"] as int;
    final double progress = remainingQuantity / totalQuantity;

    Color cardColor = _getCardColor(status, colorScheme);
    Color borderColor = _getBorderColor(status, colorScheme);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor, width: 1.5),
        ),
        color: cardColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context, colorScheme),
                SizedBox(height: 2.h),
                _buildDosageInfo(context, colorScheme),
                SizedBox(height: 2.h),
                _buildProgressSection(context, colorScheme, progress),
                SizedBox(height: 2.h),
                _buildActionButtons(context, colorScheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme) {
    final String status = prescription["status"] as String;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                prescription["medicineName"] as String,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 18.sp,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 0.5.h),
              Text(
                prescription["doctorName"] as String,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                      fontSize: 12.sp,
                    ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: _getStatusColor(status, colorScheme),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 10.sp,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildDosageInfo(BuildContext context, ColorScheme colorScheme) {
    final List<dynamic> dosageTimes =
        prescription["dosageTimes"] as List<dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Dosage Instructions",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: dosageTimes.map<Widget>((time) {
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: 2.w),
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    CustomIconWidget(
                      iconName: _getDosageIcon(time as String),
                      color: colorScheme.primary,
                      size: 20,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      time,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 1.h),
        Text(
          prescription["instructions"] as String,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                color: colorScheme.onSurface.withValues(alpha: 0.8),
              ),
        ),
      ],
    );
  }

  Widget _buildProgressSection(
      BuildContext context, ColorScheme colorScheme, double progress) {
    final int remainingQuantity = prescription["remainingQuantity"] as int;
    final int totalQuantity = prescription["totalQuantity"] as int;
    final String refillDate = prescription["refillDate"] as String;
    final bool isRefillDue = prescription["isRefillDue"] as bool;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Remaining: $remainingQuantity/$totalQuantity",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.sp,
                  ),
            ),
            if (isRefillDue)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Refill Due",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 9.sp,
                      ),
                ),
              ),
          ],
        ),
        SizedBox(height: 1.h),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: colorScheme.outline.withValues(alpha: 0.2),
          valueColor: AlwaysStoppedAnimation<Color>(
            progress > 0.3 ? colorScheme.primary : Colors.orange,
          ),
          minHeight: 6,
        ),
        SizedBox(height: 1.h),
        Text(
          "Next refill: $refillDate",
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: 11.sp,
                color: isRefillDue
                    ? Colors.orange
                    : colorScheme.onSurface.withValues(alpha: 0.6),
              ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, ColorScheme colorScheme) {
    final bool reminderEnabled = prescription["reminderEnabled"] as bool;

    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              CustomIconWidget(
                iconName: reminderEnabled
                    ? 'notifications_active'
                    : 'notifications_off',
                color: reminderEnabled
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.5),
                size: 18,
              ),
              SizedBox(width: 2.w),
              Text(
                "Reminder",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 11.sp,
                    ),
              ),
              SizedBox(width: 2.w),
              Switch(
                value: reminderEnabled,
                onChanged: (_) => onReminderToggle?.call(),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ],
          ),
        ),
        SizedBox(width: 2.w),
        ElevatedButton.icon(
          onPressed: onFindChemist,
          icon: CustomIconWidget(
            iconName: 'local_pharmacy',
            color: colorScheme.onPrimary,
            size: 16,
          ),
          label: Text(
            "Find Chemist",
            style: TextStyle(fontSize: 11.sp),
          ),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            minimumSize: Size(20.w, 5.h),
          ),
        ),
      ],
    );
  }

  Color _getCardColor(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'current':
        return colorScheme.surface;
      case 'refill needed':
        return Colors.yellow.shade50;
      case 'expired':
        return Colors.red.shade50;
      default:
        return colorScheme.surface;
    }
  }

  Color _getBorderColor(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'current':
        return Colors.green;
      case 'refill needed':
        return Colors.orange;
      case 'expired':
        return Colors.red;
      default:
        return colorScheme.outline;
    }
  }

  Color _getStatusColor(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'current':
        return Colors.green;
      case 'refill needed':
        return Colors.orange;
      case 'expired':
        return Colors.red;
      default:
        return colorScheme.primary;
    }
  }

  String _getDosageIcon(String time) {
    switch (time.toLowerCase()) {
      case 'morning':
        return 'wb_sunny';
      case 'afternoon':
        return 'wb_sunny_outlined';
      case 'evening':
        return 'nights_stay';
      case 'night':
        return 'bedtime';
      default:
        return 'schedule';
    }
  }
}
