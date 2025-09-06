import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom Bottom Navigation Bar for the Ayurvedic healthcare application
/// Provides role-based navigation optimized for elderly users and healthcare professionals
class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final BottomBarRole role;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.role = BottomBarRole.patient,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    List<BottomNavigationBarItem> items = _getNavigationItems(role);

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow,
            blurRadius: 8.0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _handleNavigation(context, index, role),
          type: BottomNavigationBarType.fixed,
          backgroundColor: colorScheme.surface,
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: colorScheme.onSurface.withValues(alpha: 0.6),
          selectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          elevation: 0, // We handle elevation with container shadow
          items: items,
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> _getNavigationItems(BottomBarRole role) {
    switch (role) {
      case BottomBarRole.patient:
        return [
          const BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined, size: 28),
            activeIcon: Icon(Icons.dashboard, size: 28),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined, size: 28),
            activeIcon: Icon(Icons.calendar_today, size: 28),
            label: 'Appointments',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.medication_outlined, size: 28),
            activeIcon: Icon(Icons.medication, size: 28),
            label: 'Medicines',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.folder_outlined, size: 28),
            activeIcon: Icon(Icons.folder, size: 28),
            label: 'Records',
          ),
        ];

      case BottomBarRole.doctor:
        return [
          const BottomNavigationBarItem(
            icon: Icon(Icons.medical_services_outlined, size: 28),
            activeIcon: Icon(Icons.medical_services, size: 28),
            label: 'Dashboard',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.people_outline, size: 28),
            activeIcon: Icon(Icons.people, size: 28),
            label: 'Patients',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.schedule_outlined, size: 28),
            activeIcon: Icon(Icons.schedule, size: 28),
            label: 'Schedule',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined, size: 28),
            activeIcon: Icon(Icons.analytics, size: 28),
            label: 'Analytics',
          ),
        ];

      case BottomBarRole.admin:
        return [
          const BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings_outlined, size: 28),
            activeIcon: Icon(Icons.admin_panel_settings, size: 28),
            label: 'Admin',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined, size: 28),
            activeIcon: Icon(Icons.group, size: 28),
            label: 'Users',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined, size: 28),
            activeIcon: Icon(Icons.bar_chart, size: 28),
            label: 'Reports',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined, size: 28),
            activeIcon: Icon(Icons.settings, size: 28),
            label: 'Settings',
          ),
        ];
    }
  }

  void _handleNavigation(BuildContext context, int index, BottomBarRole role) {
    // Provide haptic feedback for better user experience
    _provideFeedback();

    // Call the onTap callback
    onTap(index);

    // Navigate based on role and index
    String route = _getRouteForIndex(index, role);
    if (route.isNotEmpty) {
      Navigator.pushNamed(context, route);
    }
  }

  String _getRouteForIndex(int index, BottomBarRole role) {
    switch (role) {
      case BottomBarRole.patient:
        switch (index) {
          case 0:
            return '/patient-dashboard';
          case 1:
            return '/appointment-booking';
          case 2:
            return '/prescription-management';
          case 3:
            return '/health-records';
          default:
            return '';
        }

      case BottomBarRole.doctor:
        switch (index) {
          case 0:
            return '/doctor-dashboard';
          case 1:
            return '/patient-dashboard'; // Doctor's patient list view
          case 2:
            return '/appointment-booking'; // Doctor's schedule view
          case 3:
            return '/health-records'; // Analytics/reports view
          default:
            return '';
        }

      case BottomBarRole.admin:
        switch (index) {
          case 0:
            return '/doctor-dashboard'; // Admin dashboard
          case 1:
            return '/patient-dashboard'; // User management
          case 2:
            return '/health-records'; // Reports view
          case 3:
            return '/prescription-management'; // Settings view
          default:
            return '';
        }
    }
  }

  void _provideFeedback() {
    // Add subtle haptic feedback for better user experience
    // This helps elderly users confirm their touch was registered
    try {
      // Note: In a real app, you would use HapticFeedback.lightImpact()
      // For now, we'll just add a comment as haptic feedback requires platform channels
      // HapticFeedback.lightImpact();
    } catch (e) {
      // Silently handle any haptic feedback errors
    }
  }
}

/// Enum for different user roles that determine navigation options
enum BottomBarRole {
  patient,
  doctor,
  admin,
}
