import 'package:flutter/material.dart';
import 'package:meni_medical/presentation/patient/specialist_doctor.dart';

class SpecialistButton extends StatelessWidget {
  final String image;
  final String categoryText;

  const SpecialistButton({
    Key? key, required this.image, required this.categoryText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) =>
            SpecialistDoctorPage(specialization: categoryText),));
      },
      child: Container(
        margin: EdgeInsets.all(5),
        padding: EdgeInsets.all(10),
        height: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Expanded(child: Image.asset(image, fit: BoxFit.contain)),
            Text(categoryText, style: TextStyle(fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}