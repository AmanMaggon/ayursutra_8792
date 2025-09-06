import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom Tab Bar widget for the Ayurvedic healthcare application
/// Provides contextual navigation within screens with accessibility optimizations
class CustomTabBar extends StatelessWidget {
  final List<String> tabs;
  final int currentIndex;
  final Function(int) onTap;
  final TabBarVariant variant;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;
  final Color? indicatorColor;
  final Color? labelColor;
  final Color? unselectedLabelColor;

  const CustomTabBar({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTap,
    this.variant = TabBarVariant.primary,
    this.isScrollable = false,
    this.padding,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color effectiveIndicatorColor;
    Color effectiveLabelColor;
    Color effectiveUnselectedLabelColor;
    Color backgroundColor;

    switch (variant) {
      case TabBarVariant.primary:
        effectiveIndicatorColor = indicatorColor ?? colorScheme.primary;
        effectiveLabelColor = labelColor ?? colorScheme.primary;
        effectiveUnselectedLabelColor = unselectedLabelColor ??
            colorScheme.onSurface.withValues(alpha: 0.6);
        backgroundColor = colorScheme.surface;
        break;
      case TabBarVariant.secondary:
        effectiveIndicatorColor = indicatorColor ?? colorScheme.secondary;
        effectiveLabelColor = labelColor ?? colorScheme.secondary;
        effectiveUnselectedLabelColor = unselectedLabelColor ??
            colorScheme.onSurface.withValues(alpha: 0.6);
        backgroundColor = colorScheme.surface;
        break;
      case TabBarVariant.accent:
        effectiveIndicatorColor = indicatorColor ?? colorScheme.tertiary;
        effectiveLabelColor = labelColor ?? colorScheme.tertiary;
        effectiveUnselectedLabelColor = unselectedLabelColor ??
            colorScheme.onSurface.withValues(alpha: 0.6);
        backgroundColor = colorScheme.surface;
        break;
      case TabBarVariant.card:
        effectiveIndicatorColor = indicatorColor ?? Colors.transparent;
        effectiveLabelColor = labelColor ?? colorScheme.onPrimary;
        effectiveUnselectedLabelColor = unselectedLabelColor ??
            colorScheme.onSurface.withValues(alpha: 0.6);
        backgroundColor = colorScheme.surface;
        break;
    }

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1.0,
          ),
        ),
      ),
      child: variant == TabBarVariant.card
          ? _buildCardTabs(
              context, effectiveLabelColor, effectiveUnselectedLabelColor)
          : _buildStandardTabs(context, effectiveIndicatorColor,
              effectiveLabelColor, effectiveUnselectedLabelColor),
    );
  }

  Widget _buildStandardTabs(
    BuildContext context,
    Color indicatorColor,
    Color labelColor,
    Color unselectedLabelColor,
  ) {
    return TabBar(
      tabs: tabs
          .map((tab) => Tab(
                text: tab,
                height: 48, // Larger touch target for elderly users
              ))
          .toList(),
      isScrollable: isScrollable,
      indicatorColor: indicatorColor,
      indicatorWeight: 3.0,
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: labelColor,
      unselectedLabelColor: unselectedLabelColor,
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.1,
      ),
      onTap: onTap,
      splashFactory: InkRipple.splashFactory,
      overlayColor: WidgetStateProperty.all(
        labelColor.withValues(alpha: 0.1),
      ),
    );
  }

  Widget _buildCardTabs(
    BuildContext context,
    Color labelColor,
    Color unselectedLabelColor,
  ) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = index == currentIndex;

          return Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 8.0, bottom: 8.0),
            child: GestureDetector(
              onTap: () => onTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : colorScheme.surface,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outline.withValues(alpha: 0.3),
                    width: 1.0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: colorScheme.shadow,
                            blurRadius: 4.0,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  tab,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                    color: isSelected ? labelColor : unselectedLabelColor,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Predefined tab configurations for common healthcare scenarios
class HealthcareTabConfigs {
  static const List<String> patientDashboard = [
    'Overview',
    'Appointments',
    'Medications',
    'Reports',
  ];

  static const List<String> doctorDashboard = [
    'Today',
    'Patients',
    'Schedule',
    'Analytics',
  ];

  static const List<String> appointmentBooking = [
    'Available',
    'Upcoming',
    'History',
  ];

  static const List<String> prescriptionManagement = [
    'Active',
    'Completed',
    'Refills',
  ];

  static const List<String> healthRecords = [
    'Medical History',
    'Lab Results',
    'Prescriptions',
    'Documents',
  ];

  static const List<String> medicineCategories = [
    'Ayurvedic',
    'Allopathic',
    'Homeopathic',
    'Supplements',
  ];
}

/// Enum for different TabBar variants
enum TabBarVariant {
  primary,
  secondary,
  accent,
  card,
}
