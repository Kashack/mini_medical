import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:meni_medical/data/notification_api.dart';
import '../bottom_nav_items.dart';

class HomePage extends StatefulWidget {
  bool isDoctor;

  HomePage({required this.isDoctor});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectindex = 0;
  String? mtoken;
  FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    requestPermisssion();
    getToken();
    infoMessage();
  }

  void infoMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }

      NotificationApi.showNotification(
        id: 0,
        title: message.notification?.title,
        body: message.notification?.body,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: widget.isDoctor == false
          ? patientNavigationPages[_selectindex]
          : doctorNavigationPages[_selectindex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16.0),
        child: BottomNavigationBar(
          currentIndex: _selectindex,
          onTap: (value) => setState(() {
            _selectindex = value;
          }),
          elevation: 2,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          showUnselectedLabels: false,
          // type: BottomNavigationBarType.shifting,
          selectedItemColor: Colors.black,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home, color: Color(0xFF555FD2)),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              activeIcon: Icon(Icons.calendar_month, color: Color(0xFF555FD2)),
              label: 'Appointment',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person, color: Color(0xFF555FD2)),
              label: 'user',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getToken() async {
    await _messaging.getToken().then((token) {
      setState(() {
        mtoken = token;
        print('My Token is $mtoken');
      });
      saveToken(token!);
    });
  }

  void saveToken(String token) async {
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'token': token,
    });
  }

  Future<void> requestPermisssion() async {
    NotificationSettings settings = await _messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User decline the permission');
    }
  }
}
