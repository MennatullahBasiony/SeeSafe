import 'package:flutter_tts/flutter_tts.dart';

class TtsHelper {
  // Singleton pattern to create only one instance of FlutterTts
  static final TtsHelper _instance = TtsHelper._internal();
  factory TtsHelper() => _instance;

  final FlutterTts _flutterTts = FlutterTts();

  double _volume = 1.0; // Initial volume value
  double _pitch = 1.0; // Initial pitch value
  double _speechSpeed = 0.4; // Initial speech speed value

  TtsHelper._internal() {
    // Set up FlutterTts with desired language, speech rate, volume, and pitch
    _initTts();
  }

  void _initTts() async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setSpeechRate(_speechSpeed);
    await _flutterTts.setVolume(_volume);
    await _flutterTts.setPitch(_pitch);
  }

  // Method to speak text using FlutterTts
  Future<void> speak(String text) async {
    await _flutterTts.awaitSpeakCompletion(true);
    await _flutterTts.speak(text);
  }

   Future<void> setTtsLanguage(String text) async {
    if (RegExp(r'[\u0600-\u06FF]').hasMatch(text)) {
      // If the text contains Arabic characters, set the language to Arabic
      await _flutterTts.setLanguage("ar");
    } else {
      // Otherwise, set the language to English
      await _flutterTts.setLanguage("en-US");
    }
  }

  // // Method to stop speaking
  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
  }

  // Method to set volume
  Future<void> setVolume(double volume) async {
    if (volume >= 0 && volume <= 1) {
      _volume = volume;
      await _flutterTts.setVolume(volume);
    }
  }

  // Method to set pitch
  Future<void> setPitch(double pitch) async {
    if (pitch >= 0.5 && pitch <= 2) {
      _pitch = pitch;
      await _flutterTts.setPitch(pitch);
    }
  }

  // Method to set speech speed
  Future<void> setSpeed(double speed) async {
    if (speed >= 0.5 && speed <= 2) {
      _speechSpeed = speed;
      await _flutterTts.setSpeechRate(speed);
    }
  }
}
