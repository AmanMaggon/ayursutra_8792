import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterChipsRow extends StatefulWidget {
  final Function(String, bool) onFilterChanged;

  const FilterChipsRow({
    super.key,
    required this.onFilterChanged,
  });

  @override
  State<FilterChipsRow> createState() => _FilterChipsRowState();
}

class _FilterChipsRowState extends State<FilterChipsRow> {
  final Map<String, bool> _selectedFilters = {
    'Near Me': false,
    'Available Today': false,
    'Video Consultation': false,
    'Ayurvedic Specialties': false,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 8.h,
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedFilters.keys.length,
        separatorBuilder: (context, index) => SizedBox(width: 2.w),
        itemBuilder: (context, index) {
          final filterKey = _selectedFilters.keys.elementAt(index);
          final isSelected = _selectedFilters[filterKey] ?? false;

          return FilterChip(
            label: Text(
              filterKey,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurface,
              ),
            ),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                _selectedFilters[filterKey] = selected;
              });
              widget.onFilterChanged(filterKey, selected);
            },
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            selectedColor: AppTheme.lightTheme.colorScheme.primary,
            checkmarkColor: AppTheme.lightTheme.colorScheme.onPrimary,
            side: BorderSide(
              color: isSelected
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
              width: 1.0,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      ),
    );
  }
}
