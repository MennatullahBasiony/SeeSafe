import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_front/screens/specific_place.dart';
import 'package:flutter_front/camera_tasks/camera_screen.dart';
import 'package:flutter_front/texts.dart';
import 'package:flutter_front/tts_helper.dart';

class OutdoorOptions extends StatefulWidget {
  const OutdoorOptions({super.key});

  @override
  State<OutdoorOptions> createState() => _OutdoorOptionsState();
}

class _OutdoorOptionsState extends State<OutdoorOptions> {
 final TtsHelper _ttsHelper = TtsHelper(); // Initialize the TTS helper

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
            _buildButton(
              AppTexts.walk,
               () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => CameraScreen(choosenModel: "Outdoor")),
              ),
            ),
            const SizedBox(height: 40),
            _buildButton(
              AppTexts.specificPlace,
              () => Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const Outdoor()),
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
              AppTexts.outdoorButton,
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

  // Function to build buttons with GestureDetector
  Widget _buildButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: () {
        // Speak the button text on single tap
        _ttsHelper.speak(text);
      },
      onDoubleTap: () {
        // Trigger the onPressed function on double tap
        onPressed();
      },
      child: SizedBox(
        width: 400,
        height: 200,
        child: ElevatedButton(
          onPressed: null,
          style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(const Color(0xFF2EA8ED)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

