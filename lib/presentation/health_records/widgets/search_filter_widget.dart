import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SearchFilterWidget extends StatefulWidget {
  final String searchQuery;
  final String selectedCategory;
  final DateTimeRange? dateRange;
  final Function(String) onSearchChanged;
  final Function(String) onCategoryChanged;
  final Function(DateTimeRange?) onDateRangeChanged;
  final VoidCallback onClearFilters;

  const SearchFilterWidget({
    super.key,
    required this.searchQuery,
    required this.selectedCategory,
    this.dateRange,
    required this.onSearchChanged,
    required this.onCategoryChanged,
    required this.onDateRangeChanged,
    required this.onClearFilters,
  });

  @override
  State<SearchFilterWidget> createState() => _SearchFilterWidgetState();
}

class _SearchFilterWidgetState extends State<SearchFilterWidget> {
  final TextEditingController _searchController = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();
  bool _isRecording = false;
  bool _hasRecordPermission = false;

  final List<String> _categories = [
    'All',
    'Lab Reports',
    'Prescriptions',
    'X-Rays',
    'MRI',
    'CT Scan',
    'Blood Test',
    'Consultation',
    'Insurance',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery;
    _checkRecordPermission();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _checkRecordPermission() async {
    final hasPermission = await _audioRecorder.hasPermission();
    setState(() {
      _hasRecordPermission = hasPermission;
    });
  }

  Future<void> _startVoiceSearch() async {
    if (!_hasRecordPermission) {
      final hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Microphone permission required for voice search'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
      setState(() {
        _hasRecordPermission = true;
      });
    }

    try {
      if (_isRecording) {
        final path = await _audioRecorder.stop();
        setState(() {
          _isRecording = false;
        });

        if (path != null) {
          // In a real app, you would send this to a speech-to-text service
          // For now, we'll show a placeholder message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Voice search recorded. Processing...'),
              duration: Duration(seconds: 2),
            ),
          );

          // Simulate voice recognition result
          await Future.delayed(const Duration(seconds: 1));
          _searchController.text = 'blood test results';
          widget.onSearchChanged(_searchController.text);
        }
      } else {
        await _audioRecorder.start(const RecordConfig(),
            path: 'voice_search.m4a');
        setState(() {
          _isRecording = true;
        });
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Voice search failed. Please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search bar with voice input
          Container(
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: widget.onSearchChanged,
              style: AppTheme.lightTheme.textTheme.bodyLarge,
              decoration: InputDecoration(
                hintText: 'Search medical records...',
                hintStyle: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.outline,
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'search',
                    color: AppTheme.lightTheme.colorScheme.outline,
                    size: 20,
                  ),
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Voice search button
                    GestureDetector(
                      onTap: _startVoiceSearch,
                      child: Container(
                        padding: EdgeInsets.all(2.w),
                        margin: EdgeInsets.only(right: 2.w),
                        decoration: BoxDecoration(
                          color: _isRecording
                              ? AppTheme.lightTheme.colorScheme.error
                                  .withValues(alpha: 0.1)
                              : AppTheme.lightTheme.colorScheme.primary
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: CustomIconWidget(
                          iconName: _isRecording ? 'stop' : 'mic',
                          color: _isRecording
                              ? AppTheme.lightTheme.colorScheme.error
                              : AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                    ),

                    // Clear search button
                    if (_searchController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          widget.onSearchChanged('');
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 3.w),
                          child: CustomIconWidget(
                            iconName: 'clear',
                            color: AppTheme.lightTheme.colorScheme.outline,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Category filters
          SizedBox(
            height: 6.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = widget.selectedCategory == category;

                return Container(
                  margin: EdgeInsets.only(right: 2.w),
                  child: FilterChip(
                    label: Text(
                      category,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                        fontWeight:
                            isSelected ? FontWeight.w500 : FontWeight.w400,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (_) => widget.onCategoryChanged(category),
                    backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                    selectedColor: AppTheme.lightTheme.colorScheme.primary,
                    checkmarkColor: AppTheme.lightTheme.colorScheme.onPrimary,
                    side: BorderSide(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                  ),
                );
              },
            ),
          ),

          SizedBox(height: 2.h),

          // Date range and additional filters
          Row(
            children: [
              // Date range picker
              Expanded(
                child: GestureDetector(
                  onTap: _showDateRangePicker,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'date_range',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            widget.dateRange != null
                                ? '${_formatDate(widget.dateRange!.start)} - ${_formatDate(widget.dateRange!.end)}'
                                : 'Select date range',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: widget.dateRange != null
                                  ? AppTheme.lightTheme.colorScheme.onSurface
                                  : AppTheme.lightTheme.colorScheme.outline,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(width: 2.w),

              // Clear filters button
              GestureDetector(
                onTap: widget.onClearFilters,
                child: Container(
                  padding: EdgeInsets.all(2.h),
                  decoration: BoxDecoration(
                    color: AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.lightTheme.colorScheme.error
                          .withValues(alpha: 0.3),
                    ),
                  ),
                  child: CustomIconWidget(
                    iconName: 'clear_all',
                    color: AppTheme.lightTheme.colorScheme.error,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          // Recording indicator
          if (_isRecording)
            Container(
              margin: EdgeInsets.only(top: 2.h),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.error
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 2.w,
                    height: 2.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Recording... Tap to stop',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _showDateRangePicker() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: widget.dateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: AppTheme.lightTheme.colorScheme,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      widget.onDateRangeChanged(picked);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
