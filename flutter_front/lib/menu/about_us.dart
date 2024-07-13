import 'package:flutter/material.dart';
import 'package:flutter_front/texts.dart'; // Import the text constants
import 'package:flutter_front/tts_helper.dart'; // Import the TTS helper

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  final TtsHelper _ttsHelper = TtsHelper(); // Initialize TTS helper

  final List<Map<String, String>> sections = [
    {
      'id': 'introduction',
      'title': AppTexts.introductionTitle,
      'content': AppTexts.introductionContent,
    },
    {
      'id': 'vision',
      'title': AppTexts.visionTitle,
      'content': AppTexts.visionContent,
    },
    {
      'id': 'who_we_are',
      'title': AppTexts.whoWeAreTitle,
      'content': AppTexts.whoWeAreContent,
    },
    {
      'id': 'join_us',
      'title': AppTexts.joinUsTitle,
      'content': AppTexts.joinUsContent,
    },
  ];

  @override
  void dispose() {
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
      body: ListView.builder(
        itemCount: sections.length,
        itemBuilder: (context, index) {
          final section = sections[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => _ttsHelper.speak(section['title']!),
                  child: Text(
                    section['title']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: GestureDetector(
                  onTap: () => _ttsHelper.speak(section['content']!),
                  child: Text(
                    section['content']!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              SizedBox(height: index == sections.length - 1 ? 8 : 10),
            ],
          );
        },
      ),
      bottomNavigationBar: const BottomAppBar(
        color: Color(0xFF2EA8ED),
        height: 60,
        child: SizedBox(
          height: 20,
          child: Center(
            child: Text(
              'About Us',
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
