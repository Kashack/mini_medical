import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meni_medical/data/notification_api.dart';
import 'package:meni_medical/firebase_options.dart';
import 'package:meni_medical/presentation/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/doctor/doctor_bio.dart';
import 'presentation/sign_in.dart';

bool? isDoctor = false;
bool? fillBio = false;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationApi.init();
  SharedPreferences? prefs = await SharedPreferences.getInstance();
  isDoctor = prefs.getBool('isDoctor');
  fillBio = prefs.getBool('fillBio');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.white,
          iconTheme: IconThemeData(
              color: Colors.black
          ),
        )
      ),
      home: MainPage(),
    );
  }
}
class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return isDoctor == false || isDoctor == null ? HomePage(isDoctor: false,)
                : fillBio == false ? DoctorBioPage() : HomePage(isDoctor: true);
          }else{
            return SignInPage();
          }
        },
      ),
    );
  }
}