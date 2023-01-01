import 'package:flutter/material.dart';
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
        title: Text('Home Page',style: TextStyle(color: Colors.black)),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // TextField(
              //   enabled: false,
              //   decoration: InputDecoration(
              //     hintText: 'Search your specialist?',
              //     filled: true,
              //     enabledBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(20),
              //         borderSide: BorderSide(style: BorderStyle.none)),
              //     focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(20),
              //         borderSide: BorderSide(style: BorderStyle.none)),
              //     suffixIcon: Icon(
              //       Icons.search,
              //     ),
              //   ),
              // ),
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
                    onPressed: () {},
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
