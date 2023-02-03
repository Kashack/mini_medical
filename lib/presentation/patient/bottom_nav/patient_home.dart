import 'package:flutter/material.dart';
import 'package:meni_medical/presentation/patient/custome_search_delegate.dart';
import 'package:meni_medical/presentation/patient/doctor_full_list.dart';
import 'package:meni_medical/presentation/patient/specialist_full_list.dart';

import '../../../components/specialist_button.dart';
import '../doctor_list.dart';

class PatientHome extends StatelessWidget {
  const PatientHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Home Page', style: TextStyle(color: Colors.black)),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Specialist Doctor',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SpecialistFullList(),
                          ));
                    },
                    child: Text(
                      'see all',
                      style: TextStyle(
                        color: Color(0xFF555FD2),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: const [
                  Expanded(
                    child: SpecialistButton(
                      image: 'assets/images/allergist.png',
                      categoryText: 'Allergist',
                    ),
                  ),
                  Expanded(
                    child: SpecialistButton(
                      image: 'assets/images/cardiologist.png',
                      categoryText: 'Cardiologist',
                    ),
                  ),
                  Expanded(
                    child: SpecialistButton(
                      image: 'assets/images/dentist.png',
                      categoryText: 'Dentist',
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Doctors',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorFullList(),
                        ),
                      );
                    },
                    child: Text(
                      'see all',
                      style: TextStyle(
                        color: Color(0xFF555FD2),
                      ),
                    ),
                  ),
                ],
              ),
              DoctorList()
            ],
          ),
        ),
      ),
    );
  }
}
