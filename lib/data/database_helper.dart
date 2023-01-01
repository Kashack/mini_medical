import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meni_medical/presentation/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  var context;

  DatabaseHelper(BuildContext context) {
    this.context = context;
  }
  Future update(File picPath) async {
    final filePath = 'doc_picture/profile_${_auth.currentUser!.uid}';
    final prefs = await SharedPreferences.getInstance();
    try{
      await _storage.ref(filePath).putFile(picPath).then((value) {
        value.ref.getDownloadURL().then((valueUrl) {
          _firestore.collection('users').doc(_auth.currentUser!.uid).update({
            'profilePicUrl': valueUrl,
          });
        }, onError: (e) => print("Error getting document: $e"));
      });
    }on FirebaseException catch (e) {
      if (e.code == "network-request-failed") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Network failed'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${e.code}')));
      }
    }
  }
  Future<bool> saveDoctorBio(File picPath, String description) async {
    final filePath = 'doc_picture/profile_${_auth.currentUser!.uid}';
    final prefs = await SharedPreferences.getInstance();
    try {
      await _storage.ref(filePath).putFile(picPath).then((value) {
        value.ref.getDownloadURL().then((valueUrl) {
          _firestore.collection('users').doc(_auth.currentUser!.uid).update({
            'description': description,
            'fillBio': true,
            'profilePicUrl': valueUrl,
          }).then((value) async {
            await prefs.setBool('fillBio', true);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(isDoctor: true),
              ),
              (route) => false,
            );
          }, onError: (e) => print("Error getting document: $e"));
        }, onError: (e) => print("Error getting document: $e"));
      });
    } on FirebaseException catch (e) {
      if (e.code == "network-request-failed") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Network failed'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${e.code}')));
      }
    }
    return false;
  }

  Future<bool> createAnAppointment(
      {required DateTime appointmentStart,
      required DateTime appointmentEnd,
      required String patientFullName,
      required String patientGender,
      required String patientAge,
      required String doctorUid,
      required String patientProblem}) async {
    try {
      await _firestore.collection('appointments').add({
        'doctor_uid': doctorUid,
        'userUid': _auth.currentUser!.uid,
        'appointment_start': appointmentStart,
        'appointment_end': appointmentEnd,
        'appointment_status': 'Upcoming',
        'patient_fullname': patientFullName,
        'patient_gender': patientGender,
        'patient_age': patientAge,
        'patient_problem': patientProblem,
      }).then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(isDoctor: false),
            ),
            (route) => false);
      });
    } on FirebaseException catch (e) {
      if (e.code == "network-request-failed") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Network failed'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${e.code}')));
      }
      return false;
    }
    return false;
  }


}
