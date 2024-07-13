import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_front/camera_tasks/camera_screen.dart';
import 'package:flutter_front/screens/outdoor_options.dart';
import 'package:flutter_front/screens/text_recognation.dart';
import 'package:flutter_front/texts.dart';
import 'package:flutter_front/tts_helper.dart';

class Details extends StatefulWidget {
  const Details({Key? key}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final TtsHelper _ttsHelper = TtsHelper();

  @override
  void dispose() {
    // Stop TTS helper when the widget is disposed
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
          child: Image.asset('assets/smallLogo.png', fit: BoxFit.contain),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOptionButton(
              text: AppTexts.indoorButton,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CameraScreen(choosenModel: "Indoor"),
                ),
              ),
            ),
            const SizedBox(height: 18),
            _buildOptionButton(
              text: AppTexts.outdoorButton,
              onPressed: () => _navigateTo(
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OutdoorOptions(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            _buildOptionButton(
              text: AppTexts.textButton,
              onPressed: () => _navigateTo(
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TextRecognitionScreen(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateTo(VoidCallback onPressed) {
    // Navigate to the specified page after the second tap
    onPressed();
  }

  Widget _buildOptionButton(
      {required String text, required VoidCallback onPressed}) {
    return GestureDetector(
      onTap: () {
        // Speak the text on single tap
        _ttsHelper.speak(text);
      },
      onDoubleTap: () {
        // Trigger the onPressed function on double tap
        onPressed();
      },
      child: SizedBox(
        width: 390,
        height: 180,
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
