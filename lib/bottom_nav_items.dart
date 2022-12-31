import 'package:meni_medical/presentation/doctor/bottom_nav/doctor_appointment.dart';
import 'package:meni_medical/presentation/doctor/bottom_nav/doctor_home.dart';
import 'package:meni_medical/presentation/patient/bottom_nav/patient_appointment.dart';
import 'package:meni_medical/presentation/patient/bottom_nav/patient_profile.dart';
import 'package:meni_medical/presentation/user_profile.dart';

import 'presentation/doctor/bottom_nav/doctor_profile.dart';
import 'presentation/patient/bottom_nav/patient_home.dart';

List patientNavigationPages = [
  PatientHome(),
  PatientAppointment(),
  UserProfile(isDoctor: false),
];

List doctorNavigationPages = [
  DoctorHome(),
  DoctorAppointment(),
  UserProfile(isDoctor: true),
];