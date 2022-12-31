import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../sign_in.dart';

class PatientProfile extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userStream =
        _firestore.collection('users').doc(_auth.currentUser!.uid).snapshots();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('My Profile', style: TextStyle(color: Colors.black)),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: userStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: const Text('Something went wrong'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.connectionState == ConnectionState.none) {
              return Center(child: CircularProgressIndicator());
            }
            Map getSnap = snapshot.data!.data() as Map<String, dynamic>;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [

                ],
              )
            );
          }),
    );
  }
}
