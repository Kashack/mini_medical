import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:meni_medical/data/notification_api.dart';
import 'package:meni_medical/firebase_options.dart';
import 'package:meni_medical/presentation/home_page.dart';
import 'package:meni_medical/presentation/onboarding/onboarding_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'components/constant.dart';
import 'presentation/doctor/doctor_bio.dart';
import 'presentation/authentication/sign_in.dart';

bool? isDoctor = false;
bool? fillBio = false;
bool? initScreen = true;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationApi.init();
  // await Workmanager().initialize(
  //   callbackDispatcher,
  // );
  SharedPreferences? prefs = await SharedPreferences.getInstance();
  isDoctor = prefs.getBool('isDoctor');
  fillBio = prefs.getBool('fillBio');
  initScreen = await prefs.getBool('isFirstTime');
  await prefs.setBool('isFirstTime', false);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.light(primary:  MyConstant.mainColor),
          appBarTheme: AppBarTheme(
            elevation: 0,
            color: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          )
      ),
      home: initScreen == true || initScreen == null
          ? OnboardingPage()
          : MainPage(),
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
          if (snapshot.hasData) {
            return isDoctor == false || isDoctor == null
                ? HomePage(
                    isDoctor: false,
                  )
                : fillBio == false
                    ? DoctorBioPage()
                    : HomePage(isDoctor: true);
          } else {
            return SignInPage();
          }
        },
      ),
    );
  }
}
