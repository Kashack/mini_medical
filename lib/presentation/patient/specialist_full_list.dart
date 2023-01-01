import 'package:flutter/material.dart';
import 'package:meni_medical/components/specialist_button.dart';

class SpecialistFullList extends StatelessWidget {
  const SpecialistFullList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text('Specialist List',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24),),
              ),
              Expanded(
                child: GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  children: const [
                    SpecialistButton(image: 'assets/images/allergist.png',
                      categoryText: 'Allergist',),
                    SpecialistButton(image: 'assets/images/cardiologist.png',
                      categoryText: 'Cardiologist',),
                    SpecialistButton(image: 'assets/images/dentist.png',
                      categoryText: 'Dentist',),
                    SpecialistButton(image: 'assets/images/dermatologist.png',
                      categoryText: 'Dermatologist',),
                    SpecialistButton(image: 'assets/images/gynecologist.png',
                      categoryText: 'Gynecologist',),
                    SpecialistButton(image: 'assets/images/neurologist.png',
                      categoryText: 'Neurologist',),
                    SpecialistButton(image: 'assets/images/optician.png',
                      categoryText: 'Optician',),
                    SpecialistButton(image: 'assets/images/psychiatrist.png',
                      categoryText: 'Psychiatrists',),
                    SpecialistButton(image: 'assets/images/pediatrician.png',
                      categoryText: 'Pediatricians',),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
