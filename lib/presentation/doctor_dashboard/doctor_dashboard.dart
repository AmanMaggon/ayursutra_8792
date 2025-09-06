import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/custom_tab_bar.dart';
import './widgets/appointment_card_widget.dart';
import './widgets/compliance_status_widget.dart';
import './widgets/management_card_widget.dart';
import './widgets/patient_interaction_widget.dart';
import './widgets/voice_notes_widget.dart';

class DoctorDashboard extends StatefulWidget {
  const DoctorDashboard({super.key});

  @override
  State<DoctorDashboard> createState() => _DoctorDashboardState();
}

class _DoctorDashboardState extends State<DoctorDashboard>
    with TickerProviderStateMixin {
  int _currentBottomIndex = 0;
  int _currentTabIndex = 0;
  bool _isAvailable = true;
  late TabController _tabController;

  // Mock data for doctor dashboard
  final Map<String, dynamic> doctorInfo = {
    "name": "Dr. Rajesh Kumar",
    "specialization": "Ayurvedic Physician",
    "experience": "15 years",
    "rating": 4.8,
    "todayAppointments": 12,
    "completedToday": 8,
  };

  final List<Map<String, dynamic>> todayAppointments = [
    {
      "id": 1,
      "patientName": "Priya Sharma",
      "time": "10:30 AM",
      "type": "consultation",
      "status": "scheduled",
      "age": 45,
      "condition": "Chronic joint pain - Ayurvedic treatment required",
      "isUrgent": false,
    },
    {
      "id": 2,
      "patientName": "Ramesh Gupta",
      "time": "11:00 AM",
      "type": "follow_up",
      "status": "in_progress",
      "age": 62,
      "condition": "Diabetes management with Ayurvedic medicines",
      "isUrgent": true,
    },
    {
      "id": 3,
      "patientName": "Sunita Devi",
      "time": "11:30 AM",
      "type": "consultation",
      "status": "scheduled",
      "age": 38,
      "condition": "Digestive issues and stress management",
      "isUrgent": false,
    },
    {
      "id": 4,
      "patientName": "Vikram Singh",
      "time": "12:00 PM",
      "type": "emergency",
      "status": "scheduled",
      "age": 55,
      "condition": "Severe migraine - immediate consultation needed",
      "isUrgent": true,
    },
  ];

  final List<Map<String, dynamic>> recentInteractions = [
    {
      "id": 1,
      "patientName": "Meera Patel",
      "type": "prescription",
      "time": "Yesterday 4:30 PM",
      "status": "completed",
      "notes": "Prescribed Triphala and Ashwagandha for stress relief",
    },
    {
      "id": 2,
      "patientName": "Arjun Reddy",
      "type": "consultation",
      "time": "Yesterday 3:15 PM",
      "status": "completed",
      "notes": "Initial consultation for respiratory issues",
    },
    {
      "id": 3,
      "patientName": "Kavita Joshi",
      "type": "follow_up",
      "time": "Yesterday 2:00 PM",
      "status": "completed",
      "notes": "Follow-up for skin condition treatment progress",
    },
  ];

  final Map<String, dynamic> complianceData = {
    "status": "compliant",
    "lastUpdated": "06 Sep 2025",
    "certificationsCount": 3,
    "ayushCompliant": true,
    "digitalSignature": true,
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: _currentTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomIndex = index;
    });
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentTabIndex = index;
    });
    _tabController.animateTo(index);
  }

  void _toggleAvailability() {
    setState(() {
      _isAvailable = !_isAvailable;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isAvailable
              ? 'You are now available for consultations'
              : 'You are now unavailable for new consultations',
        ),
        backgroundColor: _isAvailable ? Colors.green : Colors.orange,
      ),
    );
  }

  void _onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dashboard data refreshed'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showQuickPrescriptionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quick Prescription'),
        content: const Text('Quick prescription creation feature coming soon'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _handleAppointmentAction(
      String action, Map<String, dynamic> appointment) {
    String message = '';
    switch (action) {
      case 'start':
        message = 'Starting consultation with ${appointment['patientName']}';
        break;
      case 'reschedule':
        message = 'Rescheduling appointment for ${appointment['patientName']}';
        break;
      case 'history':
        message = 'Viewing history for ${appointment['patientName']}';
        break;
      case 'call':
        message = 'Calling ${appointment['patientName']}';
        break;
      case 'reminder':
        message = 'Sending reminder to ${appointment['patientName']}';
        break;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _handleVoiceRecording(String recordingPath) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice note saved: ${recordingPath.split('/').last}'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: CustomAppBar(
        title: 'Doctor Dashboard',
        variant: AppBarVariant.primary,
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'search',
              color: colorScheme.primary,
              size: 6.w,
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search feature coming soon')),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _onRefresh(),
        child: Column(
          children: [
            // Doctor Info Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 8.w,
                        backgroundColor:
                            colorScheme.primary.withValues(alpha: 0.1),
                        child: CustomIconWidget(
                          iconName: 'person',
                          color: colorScheme.primary,
                          size: 8.w,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctorInfo['name'] as String,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSurface,
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Text(
                              doctorInfo['specialization'] as String,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                            SizedBox(height: 0.5.h),
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'star',
                                  color: Colors.amber,
                                  size: 4.w,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  '${doctorInfo['rating']} • ${doctorInfo['experience']}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            '${doctorInfo['todayAppointments']}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: colorScheme.primary,
                            ),
                          ),
                          Text(
                            'Today',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Availability Status',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Switch(
                        value: _isAvailable,
                        onChanged: (_) => _toggleAvailability(),
                        activeColor: Colors.green,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        _isAvailable ? 'Available' : 'Unavailable',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _isAvailable ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tab Navigation
            CustomTabBar(
              tabs: const [
                'Dashboard',
                'Patients',
                'Schedule',
                'Prescriptions'
              ],
              currentIndex: _currentTabIndex,
              onTap: _onTabChanged,
              variant: TabBarVariant.primary,
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDashboardTab(),
                  _buildPatientsTab(),
                  _buildScheduleTab(),
                  _buildPrescriptionsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showQuickPrescriptionDialog,
        tooltip: 'Quick Prescription',
        child: CustomIconWidget(
          iconName: 'add',
          color: colorScheme.onPrimary,
          size: 7.w,
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomIndex,
        onTap: _onBottomNavTap,
        role: BottomBarRole.doctor,
      ),
    );
  }

  Widget _buildDashboardTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Management Cards
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Practice Management',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 25.h,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              children: [
                SizedBox(
                  width: 45.w,
                  child: ManagementCardWidget(
                    title: "Today's Appointments",
                    iconName: 'calendar_today',
                    count: todayAppointments.length,
                    subtitle: '${doctorInfo['completedToday']} completed',
                    onTap: () => _onTabChanged(2),
                    showBadge: true,
                    badgeText: '2 urgent',
                    badgeColor: colorScheme.error,
                  ),
                ),
                SizedBox(
                  width: 45.w,
                  child: ManagementCardWidget(
                    title: 'Pending Consultations',
                    iconName: 'video_call',
                    count: 5,
                    subtitle: 'Telemedicine sessions',
                    iconColor: colorScheme.secondary,
                    onTap: () => _onTabChanged(1),
                  ),
                ),
                SizedBox(
                  width: 45.w,
                  child: ManagementCardWidget(
                    title: 'Prescription Requests',
                    iconName: 'medication',
                    count: 8,
                    subtitle: 'Requiring attention',
                    iconColor: colorScheme.tertiary,
                    onTap: () => _onTabChanged(3),
                    showBadge: true,
                    badgeText: 'New',
                    badgeColor: colorScheme.secondary,
                  ),
                ),
                SizedBox(
                  width: 45.w,
                  child: ManagementCardWidget(
                    title: 'Patient Records',
                    iconName: 'folder',
                    count: 156,
                    subtitle: 'Case history review',
                    iconColor: Colors.green,
                    onTap: () =>
                        Navigator.pushNamed(context, '/health-records'),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Voice Notes Widget
          VoiceNotesWidget(
            onRecordingComplete: _handleVoiceRecording,
          ),

          SizedBox(height: 3.h),

          // Recent Patient Interactions
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Recent Patient Interactions',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: recentInteractions.length,
            itemBuilder: (context, index) {
              return PatientInteractionWidget(
                interaction: recentInteractions[index],
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Viewing details for ${recentInteractions[index]['patientName']}',
                      ),
                    ),
                  );
                },
              );
            },
          ),

          SizedBox(height: 3.h),

          // Government Compliance Status
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              'Compliance Status',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: 2.h),
          ComplianceStatusWidget(complianceData: complianceData),

          SizedBox(height: 10.h), // Bottom padding for FAB
        ],
      ),
    );
  }

  Widget _buildPatientsTab() {
    return const Center(
      child: Text('Patients Tab - Coming Soon'),
    );
  }

  Widget _buildScheduleTab() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    "Today's Schedule",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                Text(
                  '${todayAppointments.length} appointments',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 2.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: todayAppointments.length,
            itemBuilder: (context, index) {
              return AppointmentCardWidget(
                appointment: todayAppointments[index],
                onStartConsultation: () =>
                    _handleAppointmentAction('start', todayAppointments[index]),
                onReschedule: () => _handleAppointmentAction(
                    'reschedule', todayAppointments[index]),
                onViewHistory: () => _handleAppointmentAction(
                    'history', todayAppointments[index]),
                onCallPatient: () =>
                    _handleAppointmentAction('call', todayAppointments[index]),
                onSendReminder: () => _handleAppointmentAction(
                    'reminder', todayAppointments[index]),
              );
            },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildPrescriptionsTab() {
    return const Center(
      child: Text('Prescriptions Tab - Coming Soon'),
    );
  }
}
