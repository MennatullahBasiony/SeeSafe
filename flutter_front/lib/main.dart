import 'package:flutter/material.dart';
import 'package:flutter_front/screens/splash_screen.dart';
import 'package:flutter_front/search_places_screen.dart';
import 'package:flutter_front/stepsRecognation/walk.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
