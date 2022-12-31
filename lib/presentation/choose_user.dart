import 'package:flutter/material.dart';
import 'package:meni_medical/presentation/doctor/doctor_sign_up.dart';
import 'package:meni_medical/presentation/patient/patient_sign_up.dart';

import '../components/custom_button.dart';

class ChooseUserPage extends StatelessWidget {
  const ChooseUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomButton(
              buttonText: 'Patient',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientSignUp(),
                  ),
                );
              },
            ),
            SizedBox(
              height: 10,
            ),
            CustomButton(
              buttonText: 'Doctor',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorSignUpPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
