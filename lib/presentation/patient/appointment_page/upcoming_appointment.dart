import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meni_medical/components/appointmentShimmer.dart';
import 'package:meni_medical/components/constant.dart';
import 'package:meni_medical/data/notification_api.dart';
import 'package:meni_medical/presentation/patient/book_appointment.dart';

class UpcomingAppointment extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final Stream<QuerySnapshot> upcomingStream = _firestore
        .collection('appointments')
        .where('userUid', isEqualTo: _auth.currentUser!.uid)
        .where('appointment_status', isEqualTo: 'Upcoming')
        .orderBy('appointment_start')
        .snapshots();
    return Scaffold(
      body: StreamBuilder(
        stream: upcomingStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.connectionState == ConnectionState.none) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data!.docs.isEmpty == false) {
            return ListView(
              children: snapshot.data!.docs
                  .map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    DateTime startDateTime = data['appointment_start'].toDate();
                    DateTime endDateTime = data['appointment_end'].toDate();
                    String formattedDate =
                        DateFormat.MMMEd().format(startDateTime);
                    String formattedTime =
                        DateFormat.jm().format(startDateTime);
                    if (startDateTime.isBefore(now) || startDateTime == now) {
                      try {
                        _firestore
                            .collection('appointments')
                            .doc(document.id)
                            .update({'appointment_status': 'Ongoing'});
                      } on FirebaseException catch (e) {
                        if (e.code == "network-request-failed") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Network failed'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${e.code}')));
                        }
                      }
                    }
                    if (endDateTime.isBefore(now) || endDateTime == now) {
                      try {
                        _firestore
                            .collection('appointments')
                            .doc(document.id)
                            .update({'appointment_status': 'Completed'});
                      } on FirebaseException catch (e) {
                        if (e.code == "network-request-failed") {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Network failed'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${e.code}')));
                        }
                      }
                    }
                    return StreamBuilder(
                        stream: _firestore
                            .collection('users')
                            .doc(data['doctor_uid'])
                            .snapshots(),
                        builder: (context, snapshots) {
                          if (snapshots.hasError) {
                            return const ShimmerLoading();
                          }
                          if (snapshots.connectionState ==
                              ConnectionState.waiting) {
                            return const ShimmerLoading();
                          }
                          if (startDateTime.isAfter(now) ||
                              startDateTime == now) {
                            NotificationApi.showScheduleNotification(
                                id: 2,
                                scheduleDate: startDateTime,
                                title: snapshots.data!.get('fullname'),
                                body: 'Start Cosultation',
                                payload: '');
                          }
                          return Container(
                            height: 160,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 80,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            image: DecorationImage(
                                                image:
                                                    CachedNetworkImageProvider(
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
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(data['appointment_status']),
                                            Text(
                                                ' ${formattedDate} | ${formattedTime}')
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    OutlinedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text('Cancel Appointment'),
                                              titleTextStyle:
                                                  const TextStyle(color: Colors.red),
                                              content: const Text(
                                                  'Are u sure u want Cancel the appointment'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20))),
                                                  child: const Text('Back'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    try {
                                                      _firestore
                                                          .collection(
                                                              'appointments')
                                                          .doc(document.id)
                                                          .update({
                                                        'appointment_status':
                                                            'Cancelled'
                                                      }).then((value) {
                                                        Navigator.pop(context);
                                                      });
                                                    } on FirebaseException catch (e) {
                                                      if (e.code ==
                                                          "network-request-failed") {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                                'Network failed'),
                                                          ),
                                                        );
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(
                                                                    '${e.code}')));
                                                      }
                                                    }
                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20))),
                                                  child: const Text('Confirm'),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                              color: MyConstant.mainColor)),
                                      child: Text(
                                        'Cancel Appointment',
                                        style: TextStyle(
                                            color: MyConstant.mainColor),
                                      ),
                                    ),
                                    MaterialButton(
                                      child: const Text('Re - schedule',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      onPressed: () {
                                        print(document.id);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BookAppointmentPage(
                                                      doctorUid: data['doctor_uid'],
                                                      reSchedule: true,
                                                    appointmentUid: document.id,
                                                  ),
                                            ));
                                      },
                                      color: MyConstant.mainColor,
                                    )
                                  ],
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
              const SizedBox(
                width: double.infinity,
              ),
              const Text(
                'You don\'t have an appointment yet',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          );
        },
      ),
    );
  }
}
