import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meni_medical/components/constant.dart';
import 'package:meni_medical/presentation/patient/book_appointment.dart';

import 'doctor_info.dart';

class SpecialistDoctorPage extends StatelessWidget {
  SpecialistDoctorPage({Key? key, required this.specialization})
      : super(key: key);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String specialization;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> specialistStream = _firestore
        .collection('users')
        .where('isDoctor', isEqualTo: true)
        .where('specialization', isEqualTo: specialization)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text(specialization,style: TextStyle(color: Colors.black),),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream: specialistStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          if (snapshot.hasData && snapshot.data!.docs.isEmpty == false){
            return ListView(
              children: snapshot.data!.docs
                  .map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DoctorInfo(documentPath: document.id),
                          ));
                    },
                    tileColor: Colors.white,
                    // leading: CachedNetworkImage(
                    //     imageUrl: data['profilePicUrl'], fit: BoxFit.contain),
                    leading: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        data['profilePicUrl'],
                      ),
                    ),
                    title: Text(data['fullname']),
                    subtitle: Text(data['specialization']),
                    trailing: TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookAppointmentPage(doctorUid: document.id,reSchedule: false  ,),
                            ));
                      },
                      style: OutlinedButton.styleFrom(
                          backgroundColor: MyConstant.mainColor),
                      child: Text(
                        'Book',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              })
                  .toList()
                  .cast(),
            );
          }
          return Center(child: Text('No Doctor on this Section Yest'));
        },
      ),
    );
  }
}
