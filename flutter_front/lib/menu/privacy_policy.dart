import 'package:flutter/material.dart';
import 'package:flutter_front/texts.dart';
import 'package:flutter_front/tts_helper.dart'; // Import the TtsHelper class

class PrivacyPolicy extends StatefulWidget {
  // Constructor
  PrivacyPolicy({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  // Instantiate the TtsHelper singleton
  final TtsHelper _ttsHelper = TtsHelper();

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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVerticalSpace(5),
            _buildText(AppTexts.lastUpdated, fontWeight: FontWeight.bold),
            _buildVerticalSpace(5),
            _buildText(AppTexts.welcome, fontWeight: FontWeight.bold),
            _buildVerticalSpace(8),
            _buildSectionTitle(AppTexts.infoWeCollect),
            _buildSubTitle(AppTexts.personalInfo, fontWeight: FontWeight.bold),
            _buildSubTitle(AppTexts.cameraMic, fontWeight: FontWeight.bold),
            _buildParagraph(AppTexts.cameraMicDesc),
            _buildSubTitle(AppTexts.gallery, fontWeight: FontWeight.bold),
            _buildParagraph(AppTexts.galleryDesc),
            _buildSubTitle(AppTexts.gps, fontWeight: FontWeight.bold),
            _buildParagraph(AppTexts.gpsDesc),
            _buildSubTitle(AppTexts.consent, fontWeight: FontWeight.bold),
            _buildParagraph(AppTexts.consentDesc),
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
              AppTexts.privacyPolicyTitle,
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

  // Build text with tap-to-speak functionality
  Widget _buildText(String text,
      {FontWeight fontWeight = FontWeight.normal, double fontSize = 12.0}) {
    return GestureDetector(
      onTap: () =>
          _ttsHelper.speak(text), // Use the TtsHelper to speak the text
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.black,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      ),
    );
  }

  // Build a section title
  Widget _buildSectionTitle(String title) {
    return _buildText(title, fontWeight: FontWeight.bold);
  }

  // Build a subtitle with optional font weight
  Widget _buildSubTitle(String subTitle,
      {FontWeight fontWeight = FontWeight.normal}) {
    return _buildText(subTitle, fontWeight: fontWeight, fontSize: 14.0);
  }

  // Build a paragraph of text with a smaller font size
  Widget _buildParagraph(String text) {
    return _buildText(text, fontSize: 10.5);
  }

  // Function to create vertical space
  Widget _buildVerticalSpace(double height) {
    return SizedBox(height: height);
  }
}
