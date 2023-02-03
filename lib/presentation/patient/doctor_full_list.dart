import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:meni_medical/components/constant.dart';
import 'package:meni_medical/presentation/patient/book_appointment.dart';
import 'package:meni_medical/presentation/patient/doctor_info.dart';

class DoctorFullList extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _storageRef = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> specialistStream = _firestore
        .collection('users')
        .where('isDoctor', isEqualTo: true)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctor List", style: TextStyle(color: Colors.black)),
      ),
      body: StreamBuilder(
        stream: specialistStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          }
          if (snapshot.connectionState == ConnectionState.none) {
            return Center(child: CircularProgressIndicator());
          }
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

                  leading: data['profilePicUrl'] == null ? Container(
                  height: 50,
                  width: 50,
                  decoration:  BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                  ),
                ) : Container(
                    height: 50,
                    width: 50,
                    decoration:  BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              data['profilePicUrl'],
                            ),
                            fit: BoxFit.cover
                        )
                    ),
                  ),
                  title: Text(data['fullname']),
                  subtitle: Text(data['specialization']),
                  trailing: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookAppointmentPage(doctorUid: document.id,re_schedule: false  ,),
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
            }).toList().cast(),
          );
        },
      ),
    );
  }
}
