import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meni_medical/presentation/doctor/appointment_page/upcoming_appointment.dart';
import 'package:meni_medical/presentation/home_page.dart';

import '../../../components/constant.dart';

class DoctorHome extends StatelessWidget {
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
        title: Center(
          child: Text(
            'Mini Medical App',
            style: TextStyle(
              color: MyConstant.mainColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StreamBuilder(
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
              return Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                snapshot.data!.get('profilePicUrl'),
                              ),
                              fit: BoxFit.cover)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(snapshot.data!.get('fullname'),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20)),
                          Text(snapshot.data!.get('email')),
                          Text(
                            snapshot.data!.get('description'),
                            overflow: TextOverflow.fade,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Appointments',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: DoctorUpcomingAppointment())
        ],
      )
    );
  }
}
