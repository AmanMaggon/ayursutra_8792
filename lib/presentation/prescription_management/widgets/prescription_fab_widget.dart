import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class PrescriptionFabWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const PrescriptionFabWidget({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return FloatingActionButton.extended(
      onPressed: onPressed,
      backgroundColor: colorScheme.tertiary,
      foregroundColor: colorScheme.onTertiary,
      elevation: 6,
      icon: CustomIconWidget(
        iconName: 'camera_alt',
        color: colorScheme.onTertiary,
        size: 24,
      ),
      label: Text(
        "Upload Prescription",
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colorScheme.onTertiary,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
