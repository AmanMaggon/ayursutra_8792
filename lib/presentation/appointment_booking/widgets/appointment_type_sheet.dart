import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppointmentTypeSheet extends StatefulWidget {
  final Map<String, dynamic> doctor;
  final String selectedDate;
  final String selectedTime;
  final Function(String, Map<String, dynamic>) onAppointmentTypeSelected;

  const AppointmentTypeSheet({
    super.key,
    required this.doctor,
    required this.selectedDate,
    required this.selectedTime,
    required this.onAppointmentTypeSelected,
  });

  @override
  State<AppointmentTypeSheet> createState() => _AppointmentTypeSheetState();
}

class _AppointmentTypeSheetState extends State<AppointmentTypeSheet> {
  String? selectedType;

  final List<Map<String, dynamic>> appointmentTypes = [
    {
      'type': 'In-Person',
      'icon': 'local_hospital',
      'price': 500,
      'duration': '30 mins',
      'description':
          'Visit doctor at clinic for physical examination and consultation',
      'benefits': [
        'Physical examination',
        'Pulse diagnosis',
        'Herbal medicine prescription'
      ],
    },
    {
      'type': 'Video Consultation',
      'icon': 'video_call',
      'price': 300,
      'duration': '20 mins',
      'description': 'Online consultation from comfort of your home',
      'benefits': [
        'Convenient from home',
        'Digital prescription',
        'Follow-up consultation'
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20.0)),
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
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 3.h),
                  _buildAppointmentSummary(),
                  SizedBox(height: 3.h),
                  _buildAppointmentTypes(),
                  SizedBox(height: 3.h),
                  _buildPaymentMethods(),
                  SizedBox(height: 3.h),
                  _buildBookingButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Appointment Type',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          'Choose the type of consultation that suits you best',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentSummary() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appointment Summary',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: CustomImageWidget(
                    imageUrl: widget.doctor['profileImage'] as String,
                    width: 12.w,
                    height: 12.w,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.doctor['name'] as String,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      '${widget.selectedDate} at ${widget.selectedTime}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.lightTheme.colorScheme.onSurface
                            .withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentTypes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Consultation Type',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        ...appointmentTypes.map((type) {
          final isSelected = selectedType == type['type'];

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedType = type['type'] as String;
              });
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 2.h),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                  width: isSelected ? 2.0 : 1.0,
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
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: CustomIconWidget(
                          iconName: type['icon'] as String,
                          color: isSelected
                              ? AppTheme.lightTheme.colorScheme.onPrimary
                              : AppTheme.lightTheme.colorScheme.onSurface,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  type['type'] as String,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme
                                        .lightTheme.colorScheme.onSurface,
                                  ),
                                ),
                                Text(
                                  '₹${type['price']}',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${type['duration']} consultation',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: AppTheme.lightTheme.colorScheme.onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    type['description'] as String,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      color: AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.8),
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  ...((type['benefits'] as List).cast<String>()).map((benefit) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 0.5.h),
                      child: Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'check_circle',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            benefit,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Methods',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
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
            children: [
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'credit_card',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Credit/Debit Cards',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'account_balance_wallet',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'UPI & Digital Wallets',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'local_hospital',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Insurance Claims',
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

  Widget _buildBookingButton() {
    final canBook = selectedType != null;
    final selectedTypeData = appointmentTypes.firstWhere(
      (type) => type['type'] == selectedType,
      orElse: () => {},
    );

    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: canBook
            ? () {
                widget.onAppointmentTypeSelected(
                    selectedType!, selectedTypeData);
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
          canBook
              ? 'Proceed to Payment - ₹${selectedTypeData['price']}'
              : 'Select Appointment Type',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
