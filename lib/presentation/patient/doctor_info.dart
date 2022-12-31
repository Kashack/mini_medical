import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meni_medical/components/custom_button.dart';

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
              children: [
                Container(
                  child: CachedNetworkImage(
                    imageUrl: snapshot.data!.get('profilePicUrl'),
                  ),
                ),
                Text('Dr. ${snapshot.data!.get('fullname')}',style: TextStyle(fontWeight: FontWeight.bold),),
                Text(snapshot.data!.get('specialization'),style: TextStyle(color: Colors.grey.shade200),),
                Text('About',style: TextStyle(fontWeight: FontWeight.bold),),
                Text(snapshot.data!.get('description')),
                Row(
                  children: [

                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    buttonText: 'Make an Appointment',
                    onPressed: () {},
                  ),
                )
              ],
            );
          }
        ),
      ),
    );
  }
}
