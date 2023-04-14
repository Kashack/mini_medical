import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meni_medical/components/constant.dart';
import 'package:meni_medical/components/custom_button.dart';
import 'package:meni_medical/presentation/authentication/sign_in.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late PageController _pageViewController;
  double currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(initialPage: 0)..addListener(() {
        setState(() {
          currentPage = _pageViewController.page!;
        });
      });
    ;
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // double progress = _pageViewController.hasClients ? _pageViewController.page ?? 0 : 0;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageViewController,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return onboard_slides[index];
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: indicator(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomButton(
                    buttonText: currentPage == 2 ? 'Start' : 'Next',
                    onPressed: () {
                      if (_pageViewController.page != 2) {
                        _pageViewController.animateToPage(
                            _pageViewController.page!.toInt() + 1,
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease);
                      } else {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInPage(),
                            ),
                            (route) => false);
                      }
                    }),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> onboard_slides = slides
      .map((item) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: SvgPicture.asset(
                  item['image'],
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(item['section'],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(
                  item['section2'],
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ))
      .toList();

  List<Widget> indicator() => List<Widget>.generate(
      slides.length,
      (index) => Container(
            margin: EdgeInsets.symmetric(horizontal: 3.0),
            height: currentPage.round() == index ? 20 : 10,
            width: currentPage.round() == index ? 20 : 10,
            decoration: BoxDecoration(
                color: currentPage.round() == index
                    ? MyConstant.mainColor
                    : Color(0x80555FD2),
                borderRadius: BorderRadius.circular(30)),
          ));
}

const List slides = [
  {
    'image': 'assets/icons/illustration.svg',
    'section': 'Thousands of doctors',
    'section2':
        'Access thousands of doctors instantly.You can easily contact with the doctors and contact for your needs.'
  },
  {
    'image': 'assets/icons/illustration2.svg',
    'section': 'Live Chat with doctors',
    'section2':
        'Easily connect with doctor and start chat for your better treatment & prescription.'
  },
  {
    'image': 'assets/icons/illustration3.svg',
    'section': 'Easy appointment',
    'section2':
        'Book an appointment with doctor.Chat with doctor via appoinment letter & get consultant.'
  },
];
