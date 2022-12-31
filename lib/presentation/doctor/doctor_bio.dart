import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meni_medical/components/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/text_form_field.dart';
import '../../data/database_helper.dart';
import '../sign_in.dart';

class DoctorBioPage extends StatefulWidget {
  @override
  State<DoctorBioPage> createState() => _DoctorBioPageState();
}

class _DoctorBioPageState extends State<DoctorBioPage> {
  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();

  File? filePath;
  bool _isLoading = false;
  String? description;

  @override
  Widget build(BuildContext context) {
    DatabaseHelper dbHelper = DatabaseHelper(context);
    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Doctor Bio',
                            style: TextStyle(
                                color: Color(0xFF555FD2),
                                fontSize: 30,
                                fontWeight: FontWeight.bold)),
                      ),
                      GestureDetector(
                        child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.white,
                            backgroundImage:
                                filePath == null ? null : FileImage(filePath!),
                            child: filePath == null
                                ? Icon(Icons.camera_alt_outlined)
                                : null),
                        onTap: () async {
                          final pickedFile =
                              await _picker.pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            setState(() {
                              filePath = File(pickedFile.path);
                            });
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: MyTextField(
                          maxLines: 10,
                          inputType: TextInputType.multiline,
                          labelText: 'Describe yourself',
                          hintText: '....',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some description';
                            }
                          },
                          onchanged: (value) => description = value,
                        ),
                      ),
                      //Working Days
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MaterialButton(
                            onPressed: () async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.clear();
                              FirebaseAuth.instance.signOut();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignInPage(),
                                  ),
                                  (route) => false);
                            },
                            child: Text('SignOut'),
                          ),
                          CustomButton(
                            buttonText: 'Complete',
                            onPressed: () async {
                              setState(() {
                                _isLoading = true;
                              });
                              FocusScope.of(context).unfocus();
                              if (_formKey.currentState!.validate()) {
                                if (filePath != null) {
                                  bool check = await dbHelper.saveDoctorBio(filePath!,description!);
                                  setState(() {
                                    _isLoading = check;
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Insert an Image'),
                                    ),
                                  );
                                }
                              }
                            },
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        if (_isLoading)
          const Opacity(
            opacity: 0.8,
            child: ModalBarrier(
              dismissible: false,
              color: Colors.black12,
            ),
          ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          )
      ],
    );
  }
}
