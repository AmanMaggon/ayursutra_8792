import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class AppointmentCardWidget extends StatelessWidget {
  final Map<String, dynamic> appointment;
  final VoidCallback? onStartConsultation;
  final VoidCallback? onReschedule;
  final VoidCallback? onViewHistory;
  final VoidCallback? onCallPatient;
  final VoidCallback? onSendReminder;

  const AppointmentCardWidget({
    super.key,
    required this.appointment,
    this.onStartConsultation,
    this.onReschedule,
    this.onViewHistory,
    this.onCallPatient,
    this.onSendReminder,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String status = appointment['status'] as String? ?? 'scheduled';
    final bool isUrgent = appointment['isUrgent'] as bool? ?? false;
    final String patientName =
        appointment['patientName'] as String? ?? 'Unknown Patient';
    final String time = appointment['time'] as String? ?? '';
    final String type = appointment['type'] as String? ?? 'consultation';
    final int age = appointment['age'] as int? ?? 0;
    final String condition = appointment['condition'] as String? ?? '';

    Color statusColor = _getStatusColor(status, colorScheme);
    Color cardColor = isUrgent
        ? colorScheme.error.withValues(alpha: 0.05)
        : colorScheme.surface;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Slidable(
        key: ValueKey(appointment['id']),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (_) => onStartConsultation?.call(),
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              icon: Icons.video_call,
              label: 'Start',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onReschedule?.call(),
              backgroundColor: colorScheme.secondary,
              foregroundColor: colorScheme.onSecondary,
              icon: Icons.schedule,
              label: 'Reschedule',
              borderRadius: BorderRadius.circular(12),
            ),
            SlidableAction(
              onPressed: (_) => onViewHistory?.call(),
              backgroundColor: colorScheme.tertiary,
              foregroundColor: colorScheme.onTertiary,
              icon: Icons.history,
              label: 'History',
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: GestureDetector(
          onLongPress: () => _showContextMenu(context),
          child: Card(
            color: cardColor,
            elevation: isUrgent ? 4 : 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: isUrgent
                  ? BorderSide(color: colorScheme.error, width: 1)
                  : BorderSide.none,
            ),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 6.w,
                              backgroundColor:
                                  colorScheme.primary.withValues(alpha: 0.1),
                              child: CustomIconWidget(
                                iconName: 'person',
                                color: colorScheme.primary,
                                size: 6.w,
                              ),
                            ),
                            SizedBox(width: 3.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    patientName,
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 0.5.h),
                                  Text(
                                    'Age: $age • $type',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurface
                                          .withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              status.toUpperCase(),
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            time,
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (condition.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(3.w),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'medical_services',
                            color: colorScheme.primary,
                            size: 4.w,
                          ),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              condition,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurface,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (isUrgent) ...[
                    SizedBox(height: 1.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'priority_high',
                          color: colorScheme.error,
                          size: 4.w,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          'Urgent Consultation Required',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return colorScheme.primary;
      case 'in_progress':
        return colorScheme.tertiary;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return colorScheme.error;
      case 'rescheduled':
        return colorScheme.secondary;
      default:
        return colorScheme.onSurface;
    }
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'call',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('Call Patient'),
              onTap: () {
                Navigator.pop(context);
                onCallPatient?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'history',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('View Full History'),
              onTap: () {
                Navigator.pop(context);
                onViewHistory?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'notifications',
                color: Theme.of(context).colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('Send Reminder'),
              onTap: () {
                Navigator.pop(context);
                onSendReminder?.call();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
