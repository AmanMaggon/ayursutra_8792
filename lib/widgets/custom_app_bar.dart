import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Custom AppBar widget for the Ayurvedic healthcare application
/// Provides consistent navigation and branding across all screens
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final bool centerTitle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double elevation;
  final AppBarVariant variant;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.centerTitle = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation = 1.0,
    this.variant = AppBarVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Color effectiveBackgroundColor;
    Color effectiveForegroundColor;

    switch (variant) {
      case AppBarVariant.primary:
        effectiveBackgroundColor = backgroundColor ?? colorScheme.surface;
        effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;
        break;
      case AppBarVariant.transparent:
        effectiveBackgroundColor = backgroundColor ?? Colors.transparent;
        effectiveForegroundColor = foregroundColor ?? colorScheme.onSurface;
        break;
      case AppBarVariant.branded:
        effectiveBackgroundColor = backgroundColor ?? colorScheme.primary;
        effectiveForegroundColor = foregroundColor ?? colorScheme.onPrimary;
        break;
    }

    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: effectiveForegroundColor,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: effectiveBackgroundColor,
      foregroundColor: effectiveForegroundColor,
      elevation: elevation,
      shadowColor: colorScheme.shadow,
      leading: leading ?? (showBackButton ? _buildBackButton(context) : null),
      actions: actions ?? _buildDefaultActions(context),
      iconTheme: IconThemeData(
        color: colorScheme.primary,
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: colorScheme.primary,
        size: 24,
      ),
    );
  }

  Widget? _buildBackButton(BuildContext context) {
    if (!Navigator.of(context).canPop()) return null;

    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_rounded),
      onPressed: () => Navigator.of(context).pop(),
      tooltip: 'Back',
    );
  }

  List<Widget> _buildDefaultActions(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    // Don't show actions on login screen
    if (currentRoute == '/login-screen') {
      return [];
    }

    return [
      // Notification icon for healthcare alerts
      IconButton(
        icon: Stack(
          children: [
            const Icon(Icons.notifications_outlined),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  borderRadius: BorderRadius.circular(6),
                ),
                constraints: const BoxConstraints(
                  minWidth: 12,
                  minHeight: 12,
                ),
                child: Text(
                  '3',
                  style: GoogleFonts.inter(
                    color: Theme.of(context).colorScheme.onError,
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        onPressed: () {
          // Navigate to notifications or show notification panel
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Notifications feature coming soon'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        tooltip: 'Notifications',
      ),

      // Profile/Settings menu
      PopupMenuButton<String>(
        icon: const Icon(Icons.account_circle_outlined),
        tooltip: 'Profile Menu',
        onSelected: (value) => _handleMenuSelection(context, value),
        itemBuilder: (context) => [
          const PopupMenuItem(
            value: 'profile',
            child: ListTile(
              leading: Icon(Icons.person_outline),
              title: Text('Profile'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const PopupMenuItem(
            value: 'settings',
            child: ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text('Settings'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const PopupMenuItem(
            value: 'help',
            child: ListTile(
              leading: Icon(Icons.help_outline),
              title: Text('Help & Support'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const PopupMenuDivider(),
          const PopupMenuItem(
            value: 'logout',
            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text('Logout', style: TextStyle(color: Colors.red)),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    ];
  }

  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'profile':
        // Navigate to profile screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile screen coming soon'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 'settings':
        // Navigate to settings screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings screen coming soon'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 'help':
        // Navigate to help screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Help & Support coming soon'),
            duration: Duration(seconds: 2),
          ),
        );
        break;
      case 'logout':
        _showLogoutDialog(context);
        break;
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Logout',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        content: Text(
          'Are you sure you want to logout?',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/login-screen',
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Enum for different AppBar variants
enum AppBarVariant {
  primary,
  transparent,
  branded,
}
