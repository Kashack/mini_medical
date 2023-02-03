import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meni_medical/components/constant.dart';
import 'package:meni_medical/components/custom_button.dart';
import 'package:meni_medical/presentation/patient/book_appointment.dart';

class DoctorInfo extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final documentPath;

  DoctorInfo({required this.documentPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot>(
            future: _firestore.collection('users').doc(documentPath).get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Container(
                  //   height: 100,
                  //   child: CachedNetworkImage(
                  //     imageUrl: snapshot.data!.get('profilePicUrl'),
                  //   ),
                  // ),
                  Container(
                    height: 200,
                    width: 200,
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                            image: CachedNetworkImageProvider(
                              snapshot.data!.get('profilePicUrl'),
                            ),
                            fit: BoxFit.cover)),
                  ),
                  Text(
                    'Dr. ${snapshot.data!.get('fullname')}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    snapshot.data!.get('specialization'),
                    style: TextStyle(color: Colors.grey.shade200),
                  ),
                  Text(
                    'About',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        snapshot.data!.get('description'),
                        style: TextStyle(fontSize: 16,),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 8,
                      ),
                    ),
                  ),

                  Container(
                    height: 100,
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: MyConstant.mainColor)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.people_alt),
                            Text(
                              '3000 +',
                              style: TextStyle(
                                  color: MyConstant.mainColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Patient',
                              style: TextStyle(),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.person),
                            Text(
                              '10 +',
                              style: TextStyle(
                                  color: MyConstant.mainColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Years of experience',
                              style: TextStyle(),
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.message),
                            Text(
                              '100 + ',
                              style: TextStyle(
                                  color: MyConstant.mainColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Reviews',
                              style: TextStyle(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      buttonText: 'Make an Appointment',
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            context) =>
                            BookAppointmentPage(
                                doctorUid: snapshot.data!.id, re_schedule: false),));
                      },
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
