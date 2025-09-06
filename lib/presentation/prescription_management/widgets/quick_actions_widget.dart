import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class QuickActionsWidget extends StatelessWidget {
  final VoidCallback onMarkTaken;
  final VoidCallback onSkipDose;
  final VoidCallback onContactDoctor;

  const QuickActionsWidget({
    super.key,
    required this.onMarkTaken,
    required this.onSkipDose,
    required this.onContactDoctor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      height: 12.h,
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              context,
              colorScheme,
              'check_circle',
              'Mark as Taken',
              Colors.green,
              onMarkTaken,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: _buildActionButton(
              context,
              colorScheme,
              'skip_next',
              'Skip Dose',
              Colors.orange,
              onSkipDose,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: _buildActionButton(
              context,
              colorScheme,
              'phone',
              'Contact Doctor',
              Colors.blue,
              onContactDoctor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    ColorScheme colorScheme,
    String iconName,
    String label,
    Color accentColor,
    VoidCallback onPressed,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: iconName,
                    color: accentColor,
                    size: 24,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 10.sp,
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
        ),
      ),
    );
  }
}
