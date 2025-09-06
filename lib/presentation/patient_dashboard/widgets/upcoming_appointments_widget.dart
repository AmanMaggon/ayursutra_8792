import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class UpcomingAppointmentsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> appointments;
  final Function(Map<String, dynamic>) onReschedule;
  final Function(Map<String, dynamic>) onCancel;
  final Function(Map<String, dynamic>) onCallDoctor;

  const UpcomingAppointmentsWidget({
    super.key,
    required this.appointments,
    required this.onReschedule,
    required this.onCancel,
    required this.onCallDoctor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (appointments.isEmpty) {
      return _buildEmptyState(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Appointments',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/appointment-booking');
                },
                child: Text(
                  'View All',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 20.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            itemCount: appointments.length > 3 ? 3 : appointments.length,
            separatorBuilder: (context, index) => SizedBox(width: 3.w),
            itemBuilder: (context, index) {
              final appointment = appointments[index];
              return _buildAppointmentCard(context, appointment);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAppointmentCard(
      BuildContext context, Map<String, dynamic> appointment) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final DateTime appointmentDate = appointment['date'] as DateTime;
    final String status = appointment['status'] as String;

    Color statusColor = colorScheme.primary;
    if (status == 'confirmed') {
      statusColor = Colors.green;
    } else if (status == 'pending') {
      statusColor = Colors.orange;
    } else if (status == 'cancelled') {
      statusColor = Colors.red;
    }

    return GestureDetector(
      onLongPress: () => _showQuickActions(context, appointment),
      child: Container(
        width: 70.w,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(3.w),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.w),
                    image: DecorationImage(
                      image: NetworkImage(appointment['doctorImage'] as String),
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
                        appointment['doctorName'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        appointment['specialty'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w400,
                          color: colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.w),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(1.w),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w500,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'calendar_today',
                  color: colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  '${appointmentDate.day}/${appointmentDate.month}/${appointmentDate.year}',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'access_time',
                  color: colorScheme.primary,
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  appointment['time'] as String,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => onReschedule(appointment),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 2.w),
                      side: BorderSide(color: colorScheme.primary, width: 1),
                    ),
                    child: Text(
                      'Reschedule',
                      style: GoogleFonts.inter(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                GestureDetector(
                  onTap: () => onCallDoctor(appointment),
                  child: Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(1.w),
                    ),
                    child: CustomIconWidget(
                      iconName: 'phone',
                      color: Colors.green,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'event_available',
            color: colorScheme.onSurface.withValues(alpha: 0.5),
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'No Upcoming Appointments',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            'Book your first consultation with an Ayurvedic doctor',
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/appointment-booking');
            },
            child: Text('Book Appointment'),
          ),
        ],
      ),
    );
  }

  void _showQuickActions(
      BuildContext context, Map<String, dynamic> appointment) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.w)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .outline
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(1.w),
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Quick Actions',
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3.h),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'schedule',
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                title: Text('Reschedule'),
                onTap: () {
                  Navigator.pop(context);
                  onReschedule(appointment);
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'phone',
                  color: Colors.green,
                  size: 24,
                ),
                title: Text('Call Doctor'),
                onTap: () {
                  Navigator.pop(context);
                  onCallDoctor(appointment);
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'cancel',
                  color: Colors.red,
                  size: 24,
                ),
                title: Text('Cancel Appointment'),
                onTap: () {
                  Navigator.pop(context);
                  onCancel(appointment);
                },
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }
}