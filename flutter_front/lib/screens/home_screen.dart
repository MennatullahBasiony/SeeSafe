import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_front/menu/menuOptions.dart';
import 'package:flutter_front/screens/details_screen.dart';
import 'package:flutter_front/tts_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TtsHelper _ttsHelper = TtsHelper(); // Initialize the TTS helper

  int _tapCount = 0;

  void _handleTap() {
    setState(() {
      _tapCount++;
      if (_tapCount == 1) {
        _ttsHelper.speak('Please tap 3 times to select between indoor, outdoor or text');
      }  // Stop speaking when tapped 3 times
      else if (_tapCount == 3) {
         _ttsHelper.stopSpeaking();
        // Navigate to another page when tapped 3 times
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Details()),
        ).then((_) {
          // Reset tap count when returning from other page
          _tapCount = 0;
        });
      }
    });
  }

  @override
  void dispose() {
    // Stop the TTS helper from speaking when navigating away from the page
    _ttsHelper.stopSpeaking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MenuList(),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFDCEEFD),
        title: SizedBox(
          width: 100,
          height: 100,
          child: Image.asset(
            'assets/smallLogo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFDCEEFD),
            ),
            child: GestureDetector(
              onTap: _handleTap,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    height: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image(
                          image: AssetImage('assets/circle.png'),
                        ),
                        Text(
                          'Please tap 3 times\n to select between \n indoor/outdoor/text',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF2EA8ED),
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
