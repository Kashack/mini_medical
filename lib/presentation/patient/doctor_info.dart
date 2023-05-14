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
      backgroundColor: Colors.white,
      appBar: AppBar(
      ),
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

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                    snapshot.data!.get('profilePicUrl'),
                                  ),
                                  fit: BoxFit.cover)),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dr. ${snapshot.data!.get('fullname')}',
                              style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 24),
                            ),
                            Text(
                              snapshot.data!.get('specialization'),
                              style: const TextStyle(color: Colors.black),
                            ),
                          ],
                        )
                      ],
                    ),
                    Container(
                      height: 100,
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: MyConstant.mainColor)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(Icons.people_alt),
                              Text(
                                '3000 +',
                                style: TextStyle(
                                    color: MyConstant.mainColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Patient',
                                style: TextStyle(),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(Icons.person),
                              Text(
                                '10 +',
                                style: TextStyle(
                                    color: MyConstant.mainColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Years of experience',
                                style: TextStyle(),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(Icons.message),
                              Text(
                                '100 + ',
                                style: TextStyle(
                                    color: MyConstant.mainColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Reviews',
                                style: TextStyle(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'About',
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Text(
                        snapshot.data!.get('description'),
                        style: const TextStyle(fontSize: 16,),
                        softWrap: true,
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
                                  doctorUid: snapshot.data!.id, reSchedule: false),));
                        },
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
