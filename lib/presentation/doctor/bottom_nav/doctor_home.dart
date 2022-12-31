import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meni_medical/presentation/home_page.dart';

import '../../../components/constant.dart';

class DoctorHome extends StatelessWidget {
  const DoctorHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Center(
          child: Text(
            'Mini Medical App',
            style: TextStyle(
              color: MyConstant.mainColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Column(
        children: [],
      ),
    );
  }
}
