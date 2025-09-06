import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PatientInteractionWidget extends StatelessWidget {
  final Map<String, dynamic> interaction;
  final VoidCallback? onTap;

  const PatientInteractionWidget({
    super.key,
    required this.interaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String patientName =
        interaction['patientName'] as String? ?? 'Unknown Patient';
    final String type = interaction['type'] as String? ?? 'consultation';
    final String time = interaction['time'] as String? ?? '';
    final String status = interaction['status'] as String? ?? 'completed';
    final String notes = interaction['notes'] as String? ?? '';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                color: _getTypeColor(type, colorScheme).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CustomIconWidget(
                iconName: _getTypeIcon(type),
                color: _getTypeColor(type, colorScheme),
                size: 5.w,
              ),
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patientName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    type.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: _getTypeColor(type, colorScheme),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (notes.isNotEmpty) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      notes,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                SizedBox(height: 1.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status, colorScheme)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: _getStatusColor(status, colorScheme),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'consultation':
        return 'medical_services';
      case 'prescription':
        return 'medication';
      case 'follow_up':
        return 'follow_the_signs';
      case 'emergency':
        return 'emergency';
      default:
        return 'person';
    }
  }

  Color _getTypeColor(String type, ColorScheme colorScheme) {
    switch (type.toLowerCase()) {
      case 'consultation':
        return colorScheme.primary;
      case 'prescription':
        return colorScheme.secondary;
      case 'follow_up':
        return colorScheme.tertiary;
      case 'emergency':
        return colorScheme.error;
      default:
        return colorScheme.onSurface;
    }
  }

  Color _getStatusColor(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return colorScheme.secondary;
      case 'cancelled':
        return colorScheme.error;
      default:
        return colorScheme.onSurface;
    }
  }
}
