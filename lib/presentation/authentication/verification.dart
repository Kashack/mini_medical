import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meni_medical/presentation/home_page.dart';

import '../../components/custom_button.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  bool isEmailVerified = false;
  Timer? timer;
  bool canResendEmail = false;

  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if(!isEmailVerified){
      sendVerificationEmail();
      timer = Timer.periodic(Duration(seconds: 3),(timer) => checkEmailVerified(),);
    }
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async{
    try{
      final user = FirebaseAuth.instance.currentUser;
      await user!.sendEmailVerification();
      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(Duration(seconds: 10));
      setState(() {
        canResendEmail = true;
      });

    }catch (e){
      print('send: ${e.toString()}');
    }
  }
  @override
  Widget build(BuildContext context) {
    return isEmailVerified ? HomePage(isDoctor: false,) : Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {  },
                  padding: EdgeInsets.all(15),
                  color: Color(0x74F9A84D),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Color(0x74F9A84D)),

                  ),
                  icon: Icon(
                    CupertinoIcons.chevron_left,
                    color: Color(0xffDA6317),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Enter 4-digit\nVerification code',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 50),
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Code send to your email. This code will expired in 01:30',
                  ),
                ),
                Expanded(
                  child: SizedBox(),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CustomButton(
                    buttonText: 'Resend Email',
                    onPressed: () {
                      canResendEmail ? sendVerificationEmail() : null;
                    },
                  ),
                )
              ],
            ),
          ),

        ),
      ),
    );
  }
}
