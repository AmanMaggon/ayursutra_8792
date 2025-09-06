import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/appointment_type_sheet.dart';
import './widgets/booking_confirmation_dialog.dart';
import './widgets/doctor_card.dart';
import './widgets/doctor_profile_sheet.dart';
import './widgets/doctor_search_bar.dart';
import './widgets/filter_chips_row.dart';

class AppointmentBooking extends StatefulWidget {
  const AppointmentBooking({super.key});

  @override
  State<AppointmentBooking> createState() => _AppointmentBookingState();
}

class _AppointmentBookingState extends State<AppointmentBooking> {
  String _searchQuery = '';
  final Map<String, bool> _activeFilters = {};
  String? _selectedDate;
  String? _selectedTime;
  String? _selectedAppointmentType;
  Map<String, dynamic>? _selectedDoctor;

  // Mock data for doctors
  final List<Map<String, dynamic>> _doctors = [
    {
      "id": 1,
      "name": "Dr. Rajesh Sharma",
      "qualification": "BAMS, MD (Ayurveda)",
      "specialization": "Panchakarma Specialist",
      "specializations": [
        "Panchakarma",
        "Digestive Disorders",
        "Stress Management",
        "Skin Diseases"
      ],
      "experience": 15,
      "rating": 4.8,
      "reviewCount": 324,
      "consultationFee": 500,
      "nextAvailable": "Today 4:00 PM",
      "profileImage":
          "https://images.unsplash.com/photo-1612349317150-e413f6a5b16d?w=400&h=400&fit=crop&crop=face",
      "recentReviews": [
        {
          "patientName": "Priya Patel",
          "rating": 5,
          "comment":
              "Excellent treatment for my digestive issues. Dr. Sharma's approach is very holistic and effective."
        },
        {
          "patientName": "Amit Kumar",
          "rating": 4,
          "comment":
              "Very knowledgeable doctor. The Panchakarma treatment helped me a lot with stress relief."
        }
      ]
    },
    {
      "id": 2,
      "name": "Dr. Meera Nair",
      "qualification": "BAMS, PhD (Ayurveda)",
      "specialization": "Women's Health",
      "specializations": [
        "Women's Health",
        "Fertility Treatment",
        "Hormonal Balance",
        "Pregnancy Care"
      ],
      "experience": 12,
      "rating": 4.9,
      "reviewCount": 256,
      "consultationFee": 600,
      "nextAvailable": "Tomorrow 10:00 AM",
      "profileImage":
          "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400&h=400&fit=crop&crop=face",
      "recentReviews": [
        {
          "patientName": "Sunita Devi",
          "rating": 5,
          "comment":
              "Dr. Meera helped me through my pregnancy with natural Ayurvedic remedies. Highly recommended!"
        },
        {
          "patientName": "Kavya Reddy",
          "rating": 5,
          "comment":
              "Excellent treatment for hormonal imbalance. Very caring and knowledgeable doctor."
        }
      ]
    },
    {
      "id": 3,
      "name": "Dr. Arjun Singh",
      "qualification": "BAMS, MS (Ayurveda Surgery)",
      "specialization": "Joint & Bone Care",
      "specializations": [
        "Orthopedic Ayurveda",
        "Joint Pain",
        "Arthritis",
        "Sports Injuries"
      ],
      "experience": 18,
      "rating": 4.7,
      "reviewCount": 412,
      "consultationFee": 550,
      "nextAvailable": "Dec 8, 2:30 PM",
      "profileImage":
          "https://images.unsplash.com/photo-1582750433449-648ed127bb54?w=400&h=400&fit=crop&crop=face",
      "recentReviews": [
        {
          "patientName": "Ramesh Gupta",
          "rating": 5,
          "comment":
              "Amazing results for my knee pain. Dr. Arjun's treatment is very effective without any side effects."
        },
        {
          "patientName": "Sanjay Mehta",
          "rating": 4,
          "comment":
              "Good experience with joint pain treatment. Natural approach works better than allopathic medicines."
        }
      ]
    },
    {
      "id": 4,
      "name": "Dr. Lakshmi Iyer",
      "qualification": "BAMS, MD (Kayachikitsa)",
      "specialization": "Diabetes & Metabolism",
      "specializations": [
        "Diabetes Care",
        "Metabolic Disorders",
        "Weight Management",
        "Lifestyle Diseases"
      ],
      "experience": 14,
      "rating": 4.6,
      "reviewCount": 298,
      "consultationFee": 450,
      "nextAvailable": "Dec 9, 11:00 AM",
      "profileImage":
          "https://images.unsplash.com/photo-1594824388853-e4d5d9b5b3d3?w=400&h=400&fit=crop&crop=face",
      "recentReviews": [
        {
          "patientName": "Vijay Sharma",
          "rating": 5,
          "comment":
              "Dr. Lakshmi helped me control my diabetes naturally. Her diet recommendations are very practical."
        },
        {
          "patientName": "Neha Agarwal",
          "rating": 4,
          "comment":
              "Effective weight management program. Lost 8 kg in 3 months with her guidance."
        }
      ]
    },
    {
      "id": 5,
      "name": "Dr. Kiran Joshi",
      "qualification": "BAMS, MD (Shalakya Tantra)",
      "specialization": "ENT & Eye Care",
      "specializations": ["ENT Disorders", "Eye Care", "Sinusitis", "Migraine"],
      "experience": 10,
      "rating": 4.5,
      "reviewCount": 187,
      "consultationFee": 400,
      "nextAvailable": "Dec 10, 3:00 PM",
      "profileImage":
          "https://images.unsplash.com/photo-1607990281513-2c110a25bd8c?w=400&h=400&fit=crop&crop=face",
      "recentReviews": [
        {
          "patientName": "Ravi Patel",
          "rating": 4,
          "comment":
              "Good treatment for chronic sinusitis. Dr. Kiran's approach is very systematic and effective."
        },
        {
          "patientName": "Pooja Singh",
          "rating": 5,
          "comment":
              "Excellent results for my migraine problem. Natural treatment without any side effects."
        }
      ]
    }
  ];

  List<Map<String, dynamic>> get _filteredDoctors {
    List<Map<String, dynamic>> filtered = _doctors;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((doctor) {
        final name = (doctor['name'] as String).toLowerCase();
        final specialization =
            (doctor['specialization'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || specialization.contains(query);
      }).toList();
    }

    // Apply active filters
    if (_activeFilters['Available Today'] == true) {
      filtered = filtered.where((doctor) {
        final nextAvailable = doctor['nextAvailable'] as String;
        return nextAvailable.contains('Today');
      }).toList();
    }

    if (_activeFilters['Video Consultation'] == true) {
      // In a real app, this would filter doctors who offer video consultation
      // For now, we'll show all doctors as they all support video consultation
    }

    if (_activeFilters['Ayurvedic Specialties'] == true) {
      // All doctors in our mock data are Ayurvedic specialists
    }

    if (_activeFilters['Near Me'] == true) {
      // In a real app, this would use location services to filter nearby doctors
      // For now, we'll show all doctors
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Book Appointment',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.lightTheme.colorScheme.onSurface,
          ),
        ),
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        elevation: 1.0,
        shadowColor: AppTheme.lightTheme.colorScheme.shadow,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back_ios',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: AppTheme.lightTheme.colorScheme.primary,
              size: 24,
            ),
            onPressed: _showFilterOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          DoctorSearchBar(
            onSearchChanged: (query) {
              setState(() {
                _searchQuery = query;
              });
            },
            onVoiceSearch: _handleVoiceSearch,
          ),

          // Filter Chips
          FilterChipsRow(
            onFilterChanged: (filter, isSelected) {
              setState(() {
                _activeFilters[filter] = isSelected;
              });
            },
          ),

          // Doctors List
          Expanded(
            child: _filteredDoctors.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.only(bottom: 2.h),
                    itemCount: _filteredDoctors.length,
                    itemBuilder: (context, index) {
                      final doctor = _filteredDoctors[index];
                      return DoctorCard(
                        doctor: doctor,
                        onTap: () => _showDoctorProfile(doctor),
                        onBookNow: () => _showDoctorProfile(doctor),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              color: AppTheme.lightTheme.colorScheme.onSurface
                  .withValues(alpha: 0.4),
              size: 64,
            ),
            SizedBox(height: 2.h),
            Text(
              'No doctors found',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.7),
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your search or filters to find more doctors.',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppTheme.lightTheme.colorScheme.onSurface
                    .withValues(alpha: 0.6),
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _activeFilters.clear();
                });
              },
              child: Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }

  void _handleVoiceSearch() {
    // In a real app, this would implement voice search functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voice search feature coming soon'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Options',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Additional filter options will be available in the next update.',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.7),
                ),
              ),
              SizedBox(height: 3.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close'),
                ),
              ),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  void _showDoctorProfile(Map<String, dynamic> doctor) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DoctorProfileSheet(
          doctor: doctor,
          onTimeSlotSelected: (date, time) {
            setState(() {
              _selectedDate = date;
              _selectedTime = time;
              _selectedDoctor = doctor;
            });
            _showAppointmentTypeSelection(doctor, date, time);
          },
        );
      },
    );
  }

  void _showAppointmentTypeSelection(
      Map<String, dynamic> doctor, String date, String time) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AppointmentTypeSheet(
          doctor: doctor,
          selectedDate: date,
          selectedTime: time,
          onAppointmentTypeSelected: (type, typeData) {
            setState(() {
              _selectedAppointmentType = type;
            });
            _processBooking(doctor, date, time, type, typeData);
          },
        );
      },
    );
  }

  void _processBooking(
    Map<String, dynamic> doctor,
    String date,
    String time,
    String appointmentType,
    Map<String, dynamic> typeData,
  ) {
    // Simulate booking process
    final bookingId =
        'AYR${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';

    final bookingDetails = {
      'bookingId': bookingId,
      'doctorName': doctor['name'],
      'date': date,
      'time': time,
      'appointmentType': appointmentType,
      'fee': typeData['price'],
      'doctorImage': doctor['profileImage'],
    };

    // Show confirmation dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BookingConfirmationDialog(
          bookingDetails: bookingDetails,
          onAddToCalendar: () {
            Navigator.pop(context);
            _addToCalendar(bookingDetails);
          },
          onViewAppointments: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, '/patient-dashboard');
          },
        );
      },
    );
  }

  void _addToCalendar(Map<String, dynamic> bookingDetails) {
    // In a real app, this would integrate with device calendar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Appointment added to calendar successfully'),
        backgroundColor: AppTheme.lightTheme.colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
