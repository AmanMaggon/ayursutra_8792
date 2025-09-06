import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DoctorSearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final VoidCallback onVoiceSearch;

  const DoctorSearchBar({
    super.key,
    required this.onSearchChanged,
    required this.onVoiceSearch,
  });

  @override
  State<DoctorSearchBar> createState() => _DoctorSearchBarState();
}

class _DoctorSearchBarState extends State<DoctorSearchBar> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: widget.onSearchChanged,
        style: TextStyle(
          fontSize: 16.sp,
          color: AppTheme.lightTheme.colorScheme.onSurface,
        ),
        decoration: InputDecoration(
          hintText: 'Search doctors, specialization, or location...',
          hintStyle: TextStyle(
            fontSize: 16.sp,
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.6),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'search',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
          ),
          suffixIcon: GestureDetector(
            onTap: widget.onVoiceSearch,
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'mic',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: AppTheme.lightTheme.colorScheme.primary,
              width: 2.0,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          filled: true,
          fillColor: AppTheme.lightTheme.colorScheme.surface,
        ),
      ),
    );
  }
}
