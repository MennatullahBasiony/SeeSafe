import 'package:flutter/material.dart';
import 'package:flutter_front/menu/about_us.dart';
import 'package:flutter_front/menu/emergency_call.dart';
import 'package:flutter_front/menu/feedback.dart';
import 'package:flutter_front/menu/privacy_policy.dart';
import 'package:flutter_front/menu/settings.dart';
import 'package:flutter_front/texts.dart';
import 'package:flutter_front/tts_helper.dart';

class MenuList extends StatelessWidget {
  const MenuList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      child: ListView(
        children: [
          _buildListTile(
            context: context,
            icon: Icons.settings,
            text: AppTexts.settings,
            screen: const Settings(),
          ),
          _buildListTile(
            context: context,
            icon: Icons.feedback,
            text: AppTexts.feedback,
            screen: const FeedBack(),
          ),
          _buildListTile(
            context: context,
            icon: Icons.privacy_tip,
            text: AppTexts.privacyPolicy,
            screen: PrivacyPolicy(),
          ),
          _buildListTile(
            context: context,
            icon: Icons.person,
            text: AppTexts.aboutUs,
            screen: const AboutUs(),
          ),
          _buildListTile(
            context: context,
            icon: Icons.call,
            text: AppTexts.emergencyCall,
            screen: const EmergencyCall(),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Widget screen,
  }) {
    // Use GestureDetector to handle single and double taps
    return GestureDetector(
      onTap: () {
        // Read the text aloud on single tap
        TtsHelper().speak(text);
      },
      onDoubleTap: () {
        // Navigate to the desired screen on double tap
        _navigateToScreen(context, screen);
      },
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        title: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Function to navigate to the desired screen
  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.of(context).pop(); // Close the drawer
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }
}
