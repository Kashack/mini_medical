import 'package:flutter/material.dart';
import 'package:meni_medical/components/my_dropdownbutton.dart';
import 'package:meni_medical/data/authentication.dart';

import '../../components/custom_button.dart';
import '../../components/text_form_field.dart';
import 'sign_in.dart';

class DoctorSignUpPage extends StatefulWidget {
  const DoctorSignUpPage({Key? key}) : super(key: key);

  @override
  State<DoctorSignUpPage> createState() => _DoctorSignUpPageState();
}

class _DoctorSignUpPageState extends State<DoctorSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? name;
  String? password;
  String? phoneNumber;
  String? specialization;
  String? Nationality;
  String? confirmPassword;
  bool _isLoading = false;
  bool _isObsecure = true;
  bool _isObsecureConfirm = true;

  @override
  Widget build(BuildContext context) {
    Authentication authentication = Authentication(context);
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
                      SizedBox(
                        height: 24,
                      ),
                      Text('Welcome!',
                          style: TextStyle(
                              color: Color(0xFF555FD2),
                              fontSize: 30,
                              fontWeight: FontWeight.bold)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: MyTextField(
                          labelText: 'Full Name',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your Full Name';
                            }
                            return null;
                          },
                          onchanged: (value) => name = value,
                          inputType: TextInputType.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: MyTextField(
                          labelText: 'Email Address',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                          onchanged: (value) => email = value,
                          inputType: TextInputType.emailAddress,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: MyTextField(
                          labelText: 'Phone Number',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your PhoneNumber';
                            }
                            return null;
                          },
                          onchanged: (value) => phoneNumber = value,
                          inputType: TextInputType.number,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Specialization',
                          style: TextStyle(
                            color: Color(0xFF555FD2),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      MyDropdownButton(
                          itemList: SpecializationList,
                          callback: (value) => specialization = SpecializationList[value]
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: MyTextField(
                          labelText: 'Password',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          onchanged: (value) => password = value,
                          suffix_icon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObsecure = !_isObsecure;
                              });
                            },
                            icon: _isObsecure == true
                                ? Icon(
                                    Icons.visibility_off,
                                    color: Colors.black,
                                  )
                                : Icon(
                                    Icons.visibility,
                                    color: Colors.black,
                                  ),
                          ),
                          isObscureText: _isObsecure,
                          inputType: TextInputType.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: MyTextField(
                          labelText: 'Confirm Password',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value != password) {
                              return 'Password does not match';
                            }
                            return null;
                          },
                          onchanged: (value) => confirmPassword = value,
                          suffix_icon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isObsecureConfirm = !_isObsecureConfirm;
                              });
                            },
                            icon: _isObsecureConfirm == true
                                ? Icon(
                                    Icons.visibility_off,
                                    color: Colors.black,
                                  )
                                : Icon(
                                    Icons.visibility,
                                    color: Colors.black,
                                  ),
                          ),
                          isObscureText: _isObsecureConfirm,
                          inputType: TextInputType.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomButton(
                          buttonText: 'Sign Up',
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });
                              bool check =
                                  await authentication.DoctorCreateAnAccount(
                                email: email!,
                                password: password!,
                                fullname: name!,
                                specialization: specialization!,
                                phoneNumber: phoneNumber!,
                              );
                              setState(() {
                                _isLoading = check;
                              });
                            }else{
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInPage(),
                            ),
                            (route) => false,
                          );
                        },
                        child: Text(
                          'Already have an account? - Sign In',
                          style: TextStyle(
                            color: Color(0xFF555FD2),
                          ),
                        ),
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
List SpecializationList = [
  '--Select--',
  'Allergist',
  'Dermatologist',
  'Gynecologist',
  'Cardiologist',
  'Neurologist',
  'Dentist',
  'Optician',
  'Psychiatrists',
  'Pediatricians'
];
