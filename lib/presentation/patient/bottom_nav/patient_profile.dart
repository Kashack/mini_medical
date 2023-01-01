import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meni_medical/components/constant.dart';
import 'package:meni_medical/components/my_dropdownbutton.dart';
import 'package:meni_medical/components/text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientProfile extends StatefulWidget {
  @override
  State<PatientProfile> createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? fullName;
  DateTime? dob;
  String? email;
  String? phoneNumber;
  String? gender;
  List genderList = ['--Select--', 'Male', 'Female'];
  bool editProfile = false;

  @override
  Widget build(BuildContext context) {
    final Stream<DocumentSnapshot> userStream =
        _firestore.collection('users').doc(_auth.currentUser!.uid).snapshots();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  editProfile = !editProfile;
                });
              },
              icon: Icon(
                Icons.edit,
                color: MyConstant.mainColor,
              ))
        ],
        title: Text('Edit Profile', style: TextStyle(color: Colors.black)),
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
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: MyTextField(
                        labelText: 'First Name',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Full Name';
                          }
                          return null;
                        },
                        enable: editProfile,
                        initialText: snapshot.data!.get('fullname'),
                        onchanged: (value) => fullName = value,
                        inputType: TextInputType.text,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: MyTextField(
                        labelText: 'email',
                        enable: false,
                        initialText: snapshot.data!.get('email'),
                        inputType: TextInputType.text,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: MyTextField(
                        labelText: 'Date of Birth',
                        readOnly: true,
                        enable: editProfile,
                        suffix_icon: IconButton(
                          onPressed: () {
                            if (editProfile) {
                              showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1920),
                                lastDate: DateTime.now(),
                              );
                            }
                          },
                          icon: Icon(Icons.calendar_month_outlined,
                              color: editProfile
                                  ? MyConstant.mainColor
                                  : Colors.grey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: MyDropdownButton(
                        enable: editProfile,
                        itemList: genderList,
                        labelText: Text('Gender'),
                        callback: (value) => gender = value,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: MyTextField(
                        labelText: 'Phone Number',
                        enable: editProfile,
                        textLimit: 11,
                        initialText: getSnap.containsKey('phoneNumber') ? snapshot.data!.get('phoneNumber'): "",
                        onchanged: (value) => phoneNumber = value,
                        inputType: TextInputType.number,
                      ),
                    ),
                    Visibility(
                      visible: editProfile,
                      maintainSize: false,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OutlinedButton(
                              onPressed: () {},
                              child: Text('Cancel'),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            MaterialButton(
                              onPressed: () {},
                              color: MyConstant.mainColor,
                              child: Text(
                                'Update',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ));
          }),
    );
  }
}
