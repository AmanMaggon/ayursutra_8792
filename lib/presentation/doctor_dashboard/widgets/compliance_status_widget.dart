import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ComplianceStatusWidget extends StatelessWidget {
  final Map<String, dynamic> complianceData;

  const ComplianceStatusWidget({
    super.key,
    required this.complianceData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String status = complianceData['status'] as String? ?? 'compliant';
    final String lastUpdated = complianceData['lastUpdated'] as String? ?? '';
    final int certificationsCount =
        complianceData['certificationsCount'] as int? ?? 0;
    final bool ayushCompliant =
        complianceData['ayushCompliant'] as bool? ?? true;
    final bool digitalSignature =
        complianceData['digitalSignature'] as bool? ?? true;

    Color statusColor = _getStatusColor(status, colorScheme);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'verified',
                  color: statusColor,
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Government Compliance',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'Status: ${status.toUpperCase()}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  certificationsCount.toString(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: _buildComplianceItem(
                  context,
                  'AYUSH Ministry',
                  ayushCompliant,
                  'ayush_compliant',
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: _buildComplianceItem(
                  context,
                  'Digital Signature',
                  digitalSignature,
                  'digital_signature',
                ),
              ),
            ],
          ),
          if (lastUpdated.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Last updated: $lastUpdated',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildComplianceItem(
    BuildContext context,
    String title,
    bool isCompliant,
    String type,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color itemColor = isCompliant ? Colors.green : colorScheme.error;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: itemColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: itemColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: isCompliant ? 'check_circle' : 'error',
            color: itemColor,
            size: 6.w,
          ),
          SizedBox(height: 1.h),
          Text(
            title,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          SizedBox(height: 0.5.h),
          Text(
            isCompliant ? 'Active' : 'Pending',
            style: theme.textTheme.labelSmall?.copyWith(
              color: itemColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status, ColorScheme colorScheme) {
    switch (status.toLowerCase()) {
      case 'compliant':
        return Colors.green;
      case 'pending':
        return colorScheme.secondary;
      case 'non_compliant':
        return colorScheme.error;
      default:
        return colorScheme.onSurface;
    }
  }
}
