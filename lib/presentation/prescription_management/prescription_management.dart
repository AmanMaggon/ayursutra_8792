import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../../widgets/custom_tab_bar.dart';
import './widgets/prescription_card_widget.dart';
import './widgets/prescription_fab_widget.dart';
import './widgets/prescription_header_widget.dart';
import './widgets/quick_actions_widget.dart';

class PrescriptionManagement extends StatefulWidget {
  const PrescriptionManagement({super.key});

  @override
  State<PrescriptionManagement> createState() => _PrescriptionManagementState();
}

class _PrescriptionManagementState extends State<PrescriptionManagement>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;
  int _currentBottomIndex = 2;
  bool _globalReminderEnabled = true;

  // Mock data for prescriptions
  final List<Map<String, dynamic>> _activePrescriptions = [
    {
      "id": 1,
      "medicineName": "Ashwagandha Churna",
      "doctorName": "Dr. Rajesh Sharma",
      "status": "Current",
      "dosageTimes": ["Morning", "Evening"],
      "instructions": "Take with warm milk, 30 minutes before meals",
      "remainingQuantity": 15,
      "totalQuantity": 30,
      "refillDate": "15 Jan 2025",
      "isRefillDue": false,
      "reminderEnabled": true,
      "ayurvedicProperties": "Adaptogenic herb for stress relief and immunity",
      "dietaryRestrictions": "Avoid with alcohol and caffeine",
    },
    {
      "id": 2,
      "medicineName": "Triphala Tablets",
      "doctorName": "Dr. Priya Nair",
      "status": "Refill Needed",
      "dosageTimes": ["Night"],
      "instructions": "Take 2 tablets with warm water before bedtime",
      "remainingQuantity": 3,
      "totalQuantity": 60,
      "refillDate": "08 Jan 2025",
      "isRefillDue": true,
      "reminderEnabled": true,
      "ayurvedicProperties": "Digestive tonic and detoxifier",
      "dietaryRestrictions": "Take 2 hours after dinner",
    },
    {
      "id": 3,
      "medicineName": "Brahmi Ghrita",
      "doctorName": "Dr. Suresh Kumar",
      "status": "Current",
      "dosageTimes": ["Morning", "Afternoon"],
      "instructions": "Take 1 teaspoon with warm water",
      "remainingQuantity": 8,
      "totalQuantity": 20,
      "refillDate": "20 Jan 2025",
      "isRefillDue": false,
      "reminderEnabled": false,
      "ayurvedicProperties": "Brain tonic for memory enhancement",
      "dietaryRestrictions": "Avoid spicy foods during treatment",
    },
  ];

  final List<Map<String, dynamic>> _prescriptionHistory = [
    {
      "id": 4,
      "medicineName": "Chyawanprash",
      "doctorName": "Dr. Rajesh Sharma",
      "completedDate": "20 Dec 2024",
      "duration": "30 days",
      "effectiveness": 4.5,
      "notes": "Improved immunity and energy levels",
    },
    {
      "id": 5,
      "medicineName": "Arjuna Capsules",
      "doctorName": "Dr. Meera Patel",
      "completedDate": "15 Dec 2024",
      "duration": "45 days",
      "effectiveness": 4.0,
      "notes": "Good for heart health maintenance",
    },
  ];

  final List<Map<String, dynamic>> _reminderSchedule = [
    {
      "id": 1,
      "medicineName": "Ashwagandha Churna",
      "time": "08:00 AM",
      "frequency": "Daily",
      "enabled": true,
    },
    {
      "id": 2,
      "medicineName": "Ashwagandha Churna",
      "time": "08:00 PM",
      "frequency": "Daily",
      "enabled": true,
    },
    {
      "id": 3,
      "medicineName": "Triphala Tablets",
      "time": "10:00 PM",
      "frequency": "Daily",
      "enabled": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Prescription Management",
        variant: AppBarVariant.primary,
      ),
      body: Column(
        children: [
          if (_currentTabIndex == 0) ...[
            PrescriptionHeaderWidget(
              prescriptionCount: _activePrescriptions.length,
              reminderEnabled: _globalReminderEnabled,
              onReminderToggle: _toggleGlobalReminder,
            ),
          ],
          CustomTabBar(
            tabs: const ["Active", "History", "Reminders"],
            currentIndex: _currentTabIndex,
            onTap: (index) {
              _tabController.animateTo(index);
            },
            variant: TabBarVariant.primary,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActiveTab(),
                _buildHistoryTab(),
                _buildRemindersTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _currentTabIndex == 0
          ? PrescriptionFabWidget(
              onPressed: _uploadPrescription,
            )
          : null,
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomIndex,
        onTap: _onBottomNavTap,
        role: BottomBarRole.patient,
      ),
    );
  }

  Widget _buildActiveTab() {
    return RefreshIndicator(
      onRefresh: _refreshPrescriptions,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 1.h, bottom: 10.h),
              itemCount: _activePrescriptions.length,
              itemBuilder: (context, index) {
                final prescription = _activePrescriptions[index];
                return Dismissible(
                  key: Key(prescription["id"].toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 4.w),
                    margin:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    decoration: BoxDecoration(
                      color: Colors.red.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'delete',
                          color: Colors.red,
                          size: 24,
                        ),
                        Text(
                          "Remove",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  confirmDismiss: (direction) =>
                      _confirmRemovePrescription(prescription),
                  child: PrescriptionCardWidget(
                    prescription: prescription,
                    onTap: () => _showPrescriptionDetails(prescription),
                    onReminderToggle: () => _togglePrescriptionReminder(index),
                    onFindChemist: () => _findNearbyChemist(prescription),
                    onMarkTaken: () => _markDoseTaken(prescription),
                    onSkipDose: () => _skipDose(prescription),
                    onContactDoctor: () => _contactDoctor(prescription),
                  ),
                );
              },
            ),
          ),
          QuickActionsWidget(
            onMarkTaken: () => _markDoseTaken(_activePrescriptions.first),
            onSkipDose: () => _skipDose(_activePrescriptions.first),
            onContactDoctor: () => _contactDoctor(_activePrescriptions.first),
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: _prescriptionHistory.length,
      itemBuilder: (context, index) {
        final history = _prescriptionHistory[index];
        return Card(
          margin: EdgeInsets.only(bottom: 2.h),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        history["medicineName"] as String,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "COMPLETED",
                        style: TextStyle(
                          color: Colors.green.shade700,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  "Dr. ${history["doctorName"]}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.7),
                        fontSize: 12.sp,
                      ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'calendar_today',
                      color: Theme.of(context).colorScheme.primary,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      "Completed: ${history["completedDate"]}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 11.sp,
                          ),
                    ),
                    SizedBox(width: 4.w),
                    CustomIconWidget(
                      iconName: 'schedule',
                      color: Theme.of(context).colorScheme.primary,
                      size: 16,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      "Duration: ${history["duration"]}",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 11.sp,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'star',
                      color: Colors.amber,
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      "${history["effectiveness"]}/5.0",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 11.sp,
                          ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        history["notes"] as String,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 11.sp,
                              fontStyle: FontStyle.italic,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRemindersTab() {
    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: _reminderSchedule.length,
      itemBuilder: (context, index) {
        final reminder = _reminderSchedule[index];
        return Card(
          margin: EdgeInsets.only(bottom: 2.h),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder["medicineName"] as String,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14.sp,
                                ),
                      ),
                      SizedBox(height: 0.5.h),
                      Row(
                        children: [
                          CustomIconWidget(
                            iconName: 'schedule',
                            color: Theme.of(context).colorScheme.primary,
                            size: 16,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            "${reminder["time"]} • ${reminder["frequency"]}",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 12.sp,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: reminder["enabled"] as bool,
                  onChanged: (value) => _toggleReminderSchedule(index, value),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toggleGlobalReminder() {
    setState(() {
      _globalReminderEnabled = !_globalReminderEnabled;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _globalReminderEnabled
              ? "Medicine reminders enabled"
              : "Medicine reminders disabled",
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _togglePrescriptionReminder(int index) {
    setState(() {
      _activePrescriptions[index]["reminderEnabled"] =
          !(_activePrescriptions[index]["reminderEnabled"] as bool);
    });
  }

  void _toggleReminderSchedule(int index, bool value) {
    setState(() {
      _reminderSchedule[index]["enabled"] = value;
    });
  }

  Future<void> _refreshPrescriptions() async {
    await Future.delayed(const Duration(seconds: 2));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Prescriptions updated"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _uploadPrescription() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        height: 40.h,
        child: Column(
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              "Upload Prescription",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: _buildUploadOption(
                    context,
                    'camera_alt',
                    'Take Photo',
                    'Capture prescription with camera',
                    () => Navigator.pop(context),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: _buildUploadOption(
                    context,
                    'photo_library',
                    'From Gallery',
                    'Select from photo gallery',
                    () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            _buildUploadOption(
              context,
              'description',
              'Manual Entry',
              'Enter prescription details manually',
              () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadOption(
    BuildContext context,
    String iconName,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            CustomIconWidget(
              iconName: iconName,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
            SizedBox(height: 1.h),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
            ),
            SizedBox(height: 0.5.h),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10.sp,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showPrescriptionDetails(Map<String, dynamic> prescription) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        height: 80.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
              margin: EdgeInsets.only(left: 38.w, bottom: 3.h),
            ),
            Text(
              prescription["medicineName"] as String,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              "Prescribed by ${prescription["doctorName"]}",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.7),
                    fontSize: 12.sp,
                  ),
            ),
            SizedBox(height: 3.h),
            _buildDetailSection("Ayurvedic Properties",
                prescription["ayurvedicProperties"] as String),
            SizedBox(height: 2.h),
            _buildDetailSection(
                "Instructions", prescription["instructions"] as String),
            SizedBox(height: 2.h),
            _buildDetailSection("Dietary Restrictions",
                prescription["dietaryRestrictions"] as String),
            SizedBox(height: 3.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  CustomIconWidget(
                    iconName: 'qr_code',
                    color: Theme.of(context).colorScheme.primary,
                    size: 80,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "QR Code for Chemist Verification",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                  ),
                  Text(
                    "Show this to your chemist for authentic medicine",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 11.sp,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.7),
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
              ),
        ),
        SizedBox(height: 0.5.h),
        Text(
          content,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12.sp,
                height: 1.4,
              ),
        ),
      ],
    );
  }

  Future<bool?> _confirmRemovePrescription(Map<String, dynamic> prescription) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove Prescription"),
        content: Text(
          "Are you sure you want to remove ${prescription["medicineName"]} from your active prescriptions?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Remove"),
          ),
        ],
      ),
    );
  }

  void _findNearbyChemist(Map<String, dynamic> prescription) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            "Finding chemists near you for ${prescription["medicineName"]}"),
        action: SnackBarAction(
          label: "View Map",
          onPressed: () {},
        ),
      ),
    );
  }

  void _markDoseTaken(Map<String, dynamic> prescription) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Marked ${prescription["medicineName"]} as taken"),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _skipDose(Map<String, dynamic> prescription) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Skipped dose for ${prescription["medicineName"]}"),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _contactDoctor(Map<String, dynamic> prescription) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Contact Doctor"),
        content: Text(
            "Contact ${prescription["doctorName"]} regarding ${prescription["medicineName"]}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Calling doctor...")),
              );
            },
            child: const Text("Call"),
          ),
        ],
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/patient-dashboard');
        break;
      case 1:
        Navigator.pushNamed(context, '/appointment-booking');
        break;
      case 2:
        // Current screen - do nothing
        break;
      case 3:
        Navigator.pushNamed(context, '/health-records');
        break;
    }
  }
}
