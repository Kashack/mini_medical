import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CancelledAppointment extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> upcomingStream = _firestore
        .collection('appointments')
        .where('userUid', isEqualTo: _auth.currentUser!.uid)
        .where('appointment_status', isEqualTo: 'Cancelled')
        .orderBy('appointment_start')
        .snapshots();
    return Scaffold(
      body: StreamBuilder(
        stream: upcomingStream,
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
          if (snapshot.hasData && snapshot.data!.docs.isEmpty == false) {
            return ListView(
              children: snapshot.data!.docs
                  .map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    DateTime dateTime = data['appointment_end'].toDate();
                    String formattedDate = DateFormat.MMMEd().format(dateTime);
                    String formattedTime = DateFormat.jm().format(dateTime);
                    return StreamBuilder(
                        stream: _firestore
                            .collection('users')
                            .doc(data['doctor_uid'])
                            .snapshots(),
                        builder: (context, snapshots) {
                          if (snapshots.hasError) {
                            return Center(
                                child: const Text('Something went wrong'));
                          }
                          if (snapshots.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return Container(
                            height: 120,
                            margin: EdgeInsets.all(16),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              children: [
                                Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                            snapshots.data!
                                                .get('profilePicUrl'),
                                          ),
                                          fit: BoxFit.cover)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        'Dr. ${snapshots.data!.get('fullname')}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(data['appointment_status'],
                                          style: TextStyle(color: Colors.red)),
                                      Text(
                                          ' ${formattedDate} | ${formattedTime}'),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  })
                  .toList()
                  .cast(),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
              ),
              Text(
                'You don\'t have any cancelled appointment yet',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );
  }
}
