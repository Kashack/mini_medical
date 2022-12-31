import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meni_medical/presentation/doctor/doctor_bio.dart';
import 'package:meni_medical/presentation/home_page.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var context;

  Authentication(BuildContext context) {
    this.context = context;
  }

  Future<bool> SigninAuthentication(
      {required String email, required String password}) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await _auth
          .signInWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        final docRef = _firestore.collection("users").doc(value.user!.uid);
        docRef.get().then(
              (DocumentSnapshot doc) async {
                if(doc.exists){
                  final isDoctor = doc['isDoctor'];
                  prefs.setBool('isDoctor', isDoctor);
                  if(isDoctor){
                    final fillBio = doc['fillBio'];
                    prefs.setBool('fillBio', fillBio);
                    if(fillBio){
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(isDoctor: isDoctor,),
                          ),
                          ModalRoute.withName('/'));
                    }else{
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DoctorBioPage(),
                          ),
                          (route) => false,
                      );
                    }
                  }else{
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(isDoctor: isDoctor,),
                        ),
                        ModalRoute.withName('/'));
                  }
                }
              },
              onError: (e) => print("Error getting document: $e"),
            );
      });
    } on FirebaseAuthException catch (e) {
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

  Future<bool> PatientCreateAnAccount(
      {required String fullname,
      required String email,
      required String password}) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        try {
          _firestore.collection('users').doc(_auth.currentUser!.uid).set({
            'fullname': fullname,
            'email': email,
            'isDoctor': false,
          }).then((value) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(isDoctor: false),
                ),
                ModalRoute.withName('/'));
          });
        } on FirebaseException catch (e) {
          if (e.code == "network-request-failed") {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Network error')));
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('${e.code}')));
          }
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == "network-request-failed") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Network error')));
      } else if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Email already in use')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${e.code}')));
      }
    }
    return false;
  }

  Future<bool> DoctorCreateAnAccount({
    required String fullname,
    required String email,
    required String password,
    required String specialization,
    required String phoneNumber,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    try {
      await _auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        try {
          _firestore.collection('users').doc(_auth.currentUser!.uid).set({
            'fullname': 'Dr. ${fullname}',
            'email': email,
            'specialization': specialization,
            'phoneNumber': phoneNumber,
            'fillBio': false,
            'isDoctor': true,
          }).then((value) async {
            await prefs.setBool('isDoctor', true);
            await prefs.setBool('fillBio', false);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorBioPage(),
                ),
                ModalRoute.withName('/'));
          });
        } on FirebaseException catch (e) {
          if (e.code == "network-request-failed") {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Network error')));
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('${e.code}')));
          }
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == "network-request-failed") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Network error')));
      } else if (e.code == "email-already-in-use") {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Email already in use')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('${e.code}')));
      }
    }
    return false;
  }
}
