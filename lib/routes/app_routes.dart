import 'package:flutter/material.dart';
import '../presentation/prescription_management/prescription_management.dart';
import '../presentation/patient_dashboard/patient_dashboard.dart';
import '../presentation/appointment_booking/appointment_booking.dart';
import '../presentation/health_records/health_records.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/doctor_dashboard/doctor_dashboard.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String prescriptionManagement = '/prescription-management';
  static const String patientDashboard = '/patient-dashboard';
  static const String appointmentBooking = '/appointment-booking';
  static const String healthRecords = '/health-records';
  static const String login = '/login-screen';
  static const String doctorDashboard = '/doctor-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    prescriptionManagement: (context) => const PrescriptionManagement(),
    patientDashboard: (context) => const PatientDashboard(),
    appointmentBooking: (context) => const AppointmentBooking(),
    healthRecords: (context) => const HealthRecords(),
    login: (context) => const LoginScreen(),
    doctorDashboard: (context) => const DoctorDashboard(),
    // TODO: Add your other routes here
  };
}
