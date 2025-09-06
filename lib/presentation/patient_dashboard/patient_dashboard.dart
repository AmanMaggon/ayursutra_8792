import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this import

import '../../core/app_export.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/action_cards_widget.dart';
import './widgets/dashboard_header_widget.dart';
import './widgets/health_progress_widget.dart';
import './widgets/recent_prescriptions_widget.dart';
import './widgets/upcoming_appointments_widget.dart';
import 'widgets/action_cards_widget.dart';
import 'widgets/dashboard_header_widget.dart';
import 'widgets/health_progress_widget.dart';
import 'widgets/recent_prescriptions_widget.dart';
import 'widgets/upcoming_appointments_widget.dart';

class PatientDashboard extends StatefulWidget {
  const PatientDashboard({super.key});

  @override
  State<PatientDashboard> createState() => _PatientDashboardState();
}

class _PatientDashboardState extends State<PatientDashboard>
    with TickerProviderStateMixin {
  int _currentBottomNavIndex = 0;
  bool _isRefreshing = false;

  // Mock data
  final List<Map<String, dynamic>> _upcomingAppointments = [
    {
      "id": 1,
      "doctorName": "Dr. Rajesh Kumar",
      "doctorImage":
          "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400&h=400&fit=crop&crop=face",
      "specialty": "Ayurvedic Physician",
      "date": DateTime.now().add(const Duration(days: 2)),
      "time": "10:30 AM",
      "status": "confirmed",
      "phone": "+91 98765 43210"
    },
    {
      "id": 2,
      "doctorName": "Dr. Priya Sharma",
      "doctorImage":
          "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400&h=400&fit=crop&crop=face",
      "specialty": "Panchakarma Specialist",
      "date": DateTime.now().add(const Duration(days: 5)),
      "time": "2:00 PM",
      "status": "pending",
      "phone": "+91 98765 43211"
    },
    {
      "id": 3,
      "doctorName": "Dr. Amit Patel",
      "doctorImage":
          "https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=400&h=400&fit=crop&crop=face",
      "specialty": "Herbal Medicine Expert",
      "date": DateTime.now().add(const Duration(days: 7)),
      "time": "11:00 AM",
      "status": "confirmed",
      "phone": "+91 98765 43212"
    }
  ];

  final List<Map<String, dynamic>> _recentPrescriptions = [
    {
      "id": 1,
      "doctorName": "Dr. Rajesh Kumar",
      "prescribedDate": DateTime.now().subtract(const Duration(days: 3)),
      "reminderEnabled": true,
      "medicines": [
        {
          "name": "Ashwagandha Churna",
          "dosage": "1 tsp twice daily",
          "status": "active"
        },
        {
          "name": "Triphala Tablets",
          "dosage": "2 tablets before bed",
          "status": "active"
        },
        {
          "name": "Brahmi Ghrita",
          "dosage": "1/2 tsp with warm milk",
          "status": "pending"
        }
      ]
    },
    {
      "id": 2,
      "doctorName": "Dr. Priya Sharma",
      "prescribedDate": DateTime.now().subtract(const Duration(days: 10)),
      "reminderEnabled": false,
      "medicines": [
        {
          "name": "Chyawanprash",
          "dosage": "1 tbsp daily morning",
          "status": "completed"
        },
        {
          "name": "Giloy Juice",
          "dosage": "30ml twice daily",
          "status": "completed"
        }
      ]
    }
  ];

  final List<Map<String, dynamic>> _healthData = [
    {
      "date": DateTime.now().subtract(const Duration(days: 6)),
      "weight": 68.0,
      "bp_systolic": 118,
      "bp_diastolic": 78,
      "sugar": 92
    },
    {
      "date": DateTime.now().subtract(const Duration(days: 5)),
      "weight": 68.2,
      "bp_systolic": 120,
      "bp_diastolic": 80,
      "sugar": 95
    },
    {
      "date": DateTime.now().subtract(const Duration(days: 4)),
      "weight": 68.1,
      "bp_systolic": 119,
      "bp_diastolic": 79,
      "sugar": 93
    },
    {
      "date": DateTime.now().subtract(const Duration(days: 3)),
      "weight": 68.3,
      "bp_systolic": 121,
      "bp_diastolic": 81,
      "sugar": 96
    },
    {
      "date": DateTime.now().subtract(const Duration(days: 2)),
      "weight": 68.4,
      "bp_systolic": 120,
      "bp_diastolic": 80,
      "sugar": 94
    },
    {
      "date": DateTime.now().subtract(const Duration(days: 1)),
      "weight": 68.5,
      "bp_systolic": 120,
      "bp_diastolic": 80,
      "sugar": 95
    }
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface.withValues(alpha: 0.95),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: colorScheme.primary,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: DashboardHeaderWidget(
                userName: "Ramesh Gupta",
                weatherTip:
                    "Winter season calls for warm foods and herbal teas. Include ginger and turmeric in your daily routine for better immunity.",
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 3.h),
            ),
            SliverToBoxAdapter(
              child: ActionCardsWidget(
                onBookConsultation: () =>
                    Navigator.pushNamed(context, '/appointment-booking'),
                onViewPrescriptions: () =>
                    Navigator.pushNamed(context, '/prescription-management'),
                onFindDoctors: () =>
                    Navigator.pushNamed(context, '/appointment-booking'),
                onHealthRecords: () =>
                    Navigator.pushNamed(context, '/health-records'),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 4.h),
            ),
            SliverToBoxAdapter(
              child: UpcomingAppointmentsWidget(
                appointments: _upcomingAppointments,
                onReschedule: _handleRescheduleAppointment,
                onCancel: _handleCancelAppointment,
                onCallDoctor: _handleCallDoctor,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 4.h),
            ),
            SliverToBoxAdapter(
              child: RecentPrescriptionsWidget(
                prescriptions: _recentPrescriptions,
                onReminderToggle: _handleReminderToggle,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 4.h),
            ),
            SliverToBoxAdapter(
              child: HealthProgressWidget(
                healthData: _healthData,
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 10.h),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _handleBottomNavTap,
        role: BottomBarRole.patient,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleEmergencyContact,
        backgroundColor: Colors.red.shade600,
        foregroundColor: Colors.white,
        child: CustomIconWidget(
          iconName: 'emergency',
          color: Colors.white,
          size: 28,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Health data refreshed successfully'),
          backgroundColor: Theme.of(context).colorScheme.primary,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _handleBottomNavTap(int index) {
    setState(() {
      _currentBottomNavIndex = index;
    });

    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        Navigator.pushNamed(context, '/appointment-booking');
        break;
      case 2:
        Navigator.pushNamed(context, '/prescription-management');
        break;
      case 3:
        Navigator.pushNamed(context, '/health-records');
        break;
    }
  }

  void _handleRescheduleAppointment(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Reschedule Appointment',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Would you like to reschedule your appointment with ${appointment['doctorName']}?',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/appointment-booking');
            },
            child: const Text('Reschedule'),
          ),
        ],
      ),
    );
  }

  void _handleCancelAppointment(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cancel Appointment',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to cancel your appointment with ${appointment['doctorName']}?',
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _upcomingAppointments
                    .removeWhere((apt) => apt['id'] == appointment['id']);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Appointment cancelled successfully'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _handleCallDoctor(Map<String, dynamic> appointment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Call Doctor',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact ${appointment['doctorName']}',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Phone: ${appointment['phone']}',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Calling doctor...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            icon: CustomIconWidget(
              iconName: 'phone',
              color: Colors.white,
              size: 16,
            ),
            label: const Text('Call Now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _handleReminderToggle(Map<String, dynamic> prescription, bool enabled) {
    setState(() {
      prescription['reminderEnabled'] = enabled;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          enabled
              ? 'Medicine reminders enabled'
              : 'Medicine reminders disabled',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleEmergencyContact() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'emergency',
              color: Colors.red,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              'Emergency Contact',
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose emergency contact:',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'local_hospital',
                color: Colors.red,
                size: 24,
              ),
              title: const Text('Emergency Services'),
              subtitle: const Text('108'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Calling emergency services...'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'person',
                color: Colors.blue,
                size: 24,
              ),
              title: const Text('Family Doctor'),
              subtitle: const Text('Dr. Rajesh Kumar'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Calling family doctor...'),
                    backgroundColor: Colors.blue,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'family_restroom',
                color: Colors.green,
                size: 24,
              ),
              title: const Text('Emergency Contact'),
              subtitle: const Text('Suresh Gupta (Son)'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Calling emergency contact...'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}