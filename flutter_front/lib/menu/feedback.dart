import 'package:flutter/material.dart';
import 'package:flutter_front/tts_helper.dart'; // Import your TTS helper

class FeedBack extends StatefulWidget {
  const FeedBack({super.key});

  @override
  State<FeedBack> createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  final TtsHelper _ttsHelper = TtsHelper(); // Instantiate TTS helper

  @override
  void dispose() {
    // Stop speaking when navigating away from the page
    _ttsHelper.stopSpeaking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDCEEFD),
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 400,
              height: 280,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset('assets/circle.png'),
                  GestureDetector(
                    onTap: () {
                      // Use the TTS helper to read the text aloud when tapped
                      _ttsHelper.speak(
                        'If you have any feedback or suggestions about the application, please feel free to contact us at SeeSafe@gmail.com.',
                      );
                    },
                    child: const Text(
                      'If you have any feedback \n or suggestions about the \napplication, please feel\n free to contact us at\n SeeSafe@gmail.com.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF2EA8ED),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Color(0xFF2EA8ED),
        height: 60,
        child: SizedBox(
          height: 20,
          child: Center(
            child: Text(
              'Feedback',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
