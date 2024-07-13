import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_front/screens/home_screen.dart';
import 'package:flutter_front/stepsRecognation/walk.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TutorialScreen extends StatelessWidget {
  TutorialScreen({super.key});

  Future<void> _checkFirstTime(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('firstTime') ?? true;
    if (!isFirstTime) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    }
  }

  Future<void> _setFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('firstTime', false);
  }

  final List<PageViewModel> pages = [
    PageViewModel(
      title: 'Indoor & Outdoor',
      body:
          'Empowerment at your fingertips. Our app grants you the freedom to choose between indoor and outdoor, allowing you to tailor your usage based on specific preferences and needs.',
      image: Center(
        child: Image.asset('assets/navigation.png'),
      ),
      decoration: const PageDecoration(
        pageColor: Color(0xFFDCEEFD),
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    PageViewModel(
      title: 'Text Recognition',
      body:
          'read text in your surroundings, or a document.then you can hear it',
      image: Center(
        child: Image.asset('assets/textRecognation.png'),
      ),
      decoration: const PageDecoration(
        pageColor: Color(0xFFDCEEFD),
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    PageViewModel(
      title: 'Object Detection',
      body:
          ' identifies the presence of various objects in the users surroundings and provides a verbal description of them, ensuring trust and safety. ',
      image: Center(
        child: Image.asset('assets/objectDetection.png'),
      ),
      decoration: const PageDecoration(
        pageColor: Color(0xFFDCEEFD),
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    PageViewModel(
      title: 'Localization and guidance',
      body:
          'Determine the users location, then know his destination and guide him to it via voice commands',
      image: Center(
        child: Image.asset('assets/guide.png'),
      ),
      decoration: const PageDecoration(
        pageColor: Color(0xFFDCEEFD),
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    _checkFirstTime(
        context); // Check if it's the first time the app is launched
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFDCEEFD), // Center align the title
        title: SizedBox(
          // Use SizedBox to set the size of the title
          width: 100, // Adjust the width as needed
          height: 100, // Adjust the height as needed
          child: Image.asset(
            'assets/smallLogo.png',
            fit: BoxFit.contain, // Ensure the image fits within the SizedBox
          ),
        ),
      ),
      body: IntroductionScreen(
        pages: pages,
        dotsDecorator: const DotsDecorator(
          size: Size(10, 10),
          color: Color(0xFFDCEEFD),
          activeSize: Size.square(10),
          activeColor: Colors.blue,
        ),
        showDoneButton: true,
        done: const Text(
          'Done',
          style: TextStyle(
            fontSize: 20,
            color: Colors.blue,
          ),
        ),
        showSkipButton: true,
        skip: const Text(
          'Skip',
          style: TextStyle(
            fontSize: 20,
            color: Colors.blue,
          ),
        ),
        showNextButton: true,
        next: const Icon(
          Icons.arrow_forward,
          size: 25,
          color: Colors.blue,
        ),
        onDone: () => onDone(context),
        curve: Curves.bounceOut,
      ),
    );
  }

  void onDone(context) async {
    _setFirstTime(); // Set that the tutorial has been completed
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Walk()));
  }
}
