import 'package:flutter/material.dart';
import 'package:flutter_front/menu/privacy_policy.dart';
import 'package:flutter_front/stepsRecognation/walk.dart';
import 'package:flutter_front/tts_helper.dart'; // Import the TtsHelper class
import 'package:flutter_front/texts.dart'; // Import the AppTexts class

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TtsHelper _ttsHelper = TtsHelper();
  double _pitchValue = 1.0; // Initial pitch value
  double _speechSpeedValue = 1.0; // Initial speech speed value
  double _volumeValue = 1.0; // Initial volume value
  String _selectedSetting = '';

  get range => null; // Initial selected setting

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
      bottomNavigationBar: const BottomAppBar(
        color: Color(0xFF2EA8ED),
        height: 60,
        child: SizedBox(
          height: 20,
          child: Center(
            child: Text(
              'Settings',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          _buildSettingItem(AppTexts.volume, '0 - 100', _volumeValue, (value) {
            setState(() {
              _volumeValue = value;
            });
            _ttsHelper.setVolume(value); // Update volume
            _ttsHelper.speak("Volume set to ${value.toStringAsFixed(2)}");
          }),
          _buildSettingItem(AppTexts.pitch, '0.5 - 2.0', _pitchValue, (value) {
            setState(() {
              _pitchValue = value;
            });
            _ttsHelper.setPitch(value); // Update pitch
            _ttsHelper.speak("Pitch set to ${value.toStringAsFixed(2)}");
          }),
          _buildSettingItem(
              AppTexts.speechSpeed, '0.5 - 2.0', _speechSpeedValue, (value) {
            setState(() {
              _speechSpeedValue = value;
            });
            _ttsHelper.setSpeed(value); // Update speech speed
            _ttsHelper.speak("Speech speed set to ${value.toStringAsFixed(2)}");
          }),
          _buildSettingItem(AppTexts.privacyPolicy, 'Options', null, (_) {}),
          _buildSettingItem("Update steps pattern", 'Options', null, (_) {}),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    String text,
    String range,
    double? value,
    Function(double) onChanged,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: GestureDetector(
            onTap: () {
              if (text == AppTexts.privacyPolicy) {
                _ttsHelper.speak("Privacy Policy"); // Read the privacy policy
              } else if (text == "Update steps pattern") {
                _ttsHelper.speak("Update steps pattern"); // Read the upgrade steps pattern
              } else {
                _selectedSetting = text;
                _ttsHelper.speak(text);
              }
            },
            onDoubleTap: () {
              if (text == AppTexts.privacyPolicy) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrivacyPolicy(),
                  ),
                );
              } else if (text == "Update steps pattern") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Walk(), // Navigate to WalkScreen
                  ),
                );
              } else {
                _selectedSetting = text;
                _showSettingDialog(context, text, value, onChanged);
              }
            },
            child: Container(
              color: _selectedSetting == text
                  ? Colors.grey.withOpacity(0.5)
                  : null,
              child: ListTile(
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        text,
                        style: const TextStyle(
                          color: Color(0xFF0071B1),
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.navigate_next,
                      color: Color(0xFF0071B1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Divider(
          color: Color(0xFFADD8F0),
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
      ],
    );
  }

  void _showSettingDialog(BuildContext context, String text, double? value,
      Function(double) onChanged) {
    String currentValue =
        "Current value: ${value?.toStringAsFixed(2) ?? '1.0'}";
    String startText = '';
    String endText = '';

    if (text == AppTexts.volume) {
      startText = 'Start: 0';
      endText = 'End: 100';
    } else if (text == AppTexts.pitch || text == AppTexts.speechSpeed) {
      startText = 'Start: 0.5';
      endText = 'End: 2.0';
    }

    void speakCurrentValue() {
      _ttsHelper.speak(currentValue);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(text),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (text == AppTexts.volume ||
                      text == AppTexts.pitch ||
                      text == AppTexts.speechSpeed)
                    SizedBox(
                      height: 150,
                      child: Column(
                        children: [
                          Slider(
                            value: value ?? 1.0,
                            min: text == AppTexts.volume ? 0.0 : 0.5,
                            max: text == AppTexts.volume ? 1.0 : 2.0,
                            onChanged: (newValue) {
                              setState(() {
                                value = newValue;
                                currentValue =
                                    "Current value: ${newValue.toStringAsFixed(2)}";
                                onChanged(newValue);
                                speakCurrentValue(); // Read the current value
                              });
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                startText,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                currentValue,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                endText,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              actions: [
                Container(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                      child: Text('OK', style: TextStyle(fontSize: 18.0)),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
