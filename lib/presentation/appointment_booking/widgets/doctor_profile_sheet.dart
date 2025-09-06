import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DoctorProfileSheet extends StatefulWidget {
  final Map<String, dynamic> doctor;
  final Function(String, String) onTimeSlotSelected;

  const DoctorProfileSheet({
    super.key,
    required this.doctor,
    required this.onTimeSlotSelected,
  });

  @override
  State<DoctorProfileSheet> createState() => _DoctorProfileSheetState();
}

class _DoctorProfileSheetState extends State<DoctorProfileSheet> {
  String? selectedDate;
  String? selectedTime;

  final List<String> availableDates = [
    'Today, Dec 6',
    'Tomorrow, Dec 7',
    'Dec 8, 2024',
    'Dec 9, 2024',
    'Dec 10, 2024',
  ];

  final Map<String, List<String>> timeSlots = {
    'Morning': [
      '09:00 AM',
      '09:30 AM',
      '10:00 AM',
      '10:30 AM',
      '11:00 AM',
      '11:30 AM'
    ],
    'Evening': [
      '04:00 PM',
      '04:30 PM',
      '05:00 PM',
      '05:30 PM',
      '06:00 PM',
      '06:30 PM'
    ],
  };

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(20.0)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: EdgeInsets.symmetric(vertical: 1.h),
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: EdgeInsets.all(4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDoctorHeader(),
                      SizedBox(height: 3.h),
                      _buildSpecializationsSection(),
                      SizedBox(height: 3.h),
                      _buildExperienceSection(),
                      SizedBox(height: 3.h),
                      _buildReviewsSection(),
                      SizedBox(height: 3.h),
                      _buildDateSelection(),
                      SizedBox(height: 3.h),
                      _buildTimeSlotSelection(),
                      SizedBox(height: 3.h),
                      _buildBookingButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDoctorHeader() {
    return Row(
      children: [
        Container(
          width: 25.w,
          height: 25.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              width: 1.0,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.0),
            child: CustomImageWidget(
              imageUrl: widget.doctor['profileImage'] as String,
              width: 25.w,
              height: 25.w,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.doctor['name'] as String,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                widget.doctor['qualification'] as String,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'star',
                    color: Colors.amber,
                    size: 18,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '${widget.doctor['rating']} (${widget.doctor['reviewCount']} reviews)',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecializationsSection() {
    final specializations =
        (widget.doctor['specializations'] as List).cast<String>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Specializations',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: specializations.map((specialization) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.3),
                  width: 1.0,
                ),
              ),
              child: Text(
                specialization,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildExperienceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Experience',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          '${widget.doctor['experience']} years of experience in Ayurvedic medicine and holistic healthcare. Specialized in treating chronic conditions through traditional Ayurvedic practices.',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.8),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    final reviews =
        (widget.doctor['recentReviews'] as List).cast<Map<String, dynamic>>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Reviews',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        ...reviews.take(2).map((review) {
          return Container(
            margin: EdgeInsets.only(bottom: 2.h),
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
                width: 1.0,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      review['patientName'] as String,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: List.generate(5, (index) {
                        return CustomIconWidget(
                          iconName: index < (review['rating'] as int)
                              ? 'star'
                              : 'star_border',
                          color: Colors.amber,
                          size: 14,
                        );
                      }),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  review['comment'] as String,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.7),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Date',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        SizedBox(
          height: 6.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: availableDates.length,
            separatorBuilder: (context, index) => SizedBox(width: 2.w),
            itemBuilder: (context, index) {
              final date = availableDates[index];
              final isSelected = selectedDate == date;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = date;
                    selectedTime = null; // Reset time selection
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.lightTheme.colorScheme.primary
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                      width: 1.0,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      date,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.onPrimary
                            : AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotSelection() {
    if (selectedDate == null) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Time Slot',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        ...timeSlots.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.key,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 1.h),
              Wrap(
                spacing: 2.w,
                runSpacing: 1.h,
                children: entry.value.map((time) {
                  final isSelected = selectedTime == time;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTime = time;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 4.w, vertical: 1.5.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        time,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 2.h),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildBookingButton() {
    final canBook = selectedDate != null && selectedTime != null;

    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: canBook
            ? () {
                widget.onTimeSlotSelected(selectedDate!, selectedTime!);
                Navigator.pop(context);
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canBook
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          foregroundColor: canBook
              ? AppTheme.lightTheme.colorScheme.onPrimary
              : AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          elevation: canBook ? 2.0 : 0.0,
        ),
        child: Text(
          'Continue Booking',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
