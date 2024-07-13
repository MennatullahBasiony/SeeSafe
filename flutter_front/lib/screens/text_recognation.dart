import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_front/tts_helper.dart'; // Import the TtsHelper class

class TextRecognitionScreen extends StatefulWidget {
  const TextRecognitionScreen({Key? key}) : super(key: key);

  @override
  _TextRecognitionScreenState createState() => _TextRecognitionScreenState();
}

class _TextRecognitionScreenState extends State<TextRecognitionScreen> {
  File? _image;
  String recognizedText = '';
  bool isLoading = false;
  final ImagePicker _imagePicker = ImagePicker();
  final TtsHelper _ttsHelper = TtsHelper(); // Create an instance of TtsHelper

  late final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  @override
  void dispose() {
    // Dispose of the text recognizer to free up resources
    _textRecognizer.close();
    // Stop speaking when leaving the page
    _ttsHelper.stopSpeaking();
    super.dispose();
  }

  Future<PermissionStatus> requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (status != PermissionStatus.granted) {
      return await Permission.camera.request();
    }
    return status;
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      PermissionStatus permissionStatus = PermissionStatus.granted;
      if (source == ImageSource.camera) {
        permissionStatus = await requestCameraPermission();
      }

      if (permissionStatus == PermissionStatus.granted) {
        final pickedFile = await _imagePicker.pickImage(source: source);
        if (pickedFile != null) {
          setState(() {
            _image = File(pickedFile.path);
          });
          await recognizeTextFromImage();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Permission denied. Unable to access the camera.')));
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> recognizeTextFromImage() async {
    if (_image == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final inputImage = InputImage.fromFilePath(_image!.path); //InputImage is a data structure used by Firebase ML Kit to represent an image for processing.
      final RecognizedText text =
          await _textRecognizer.processImage(inputImage);
      setState(() {
        recognizedText = text.text;
      });
      // Speak the recognized text
      _ttsHelper.speak(recognizedText);
    } catch (e) {
      print('Error recognizing text: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_image != null)
              Image.file(
                _image!,
                height: 200,
                fit: BoxFit.cover,
              )
            else
              const SizedBox(height: 20),
            if (isLoading) const CircularProgressIndicator(),
            if (!isLoading && recognizedText.isNotEmpty)
              Text(
                recognizedText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xFF2EA8ED),
        height: 130,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                // Speak the message for gallery using TtsHelper
                _ttsHelper.speak("Get the image from gallery");
              },
              onDoubleTap: () {
                // Pick the image from gallery on double-tap
                pickImage(ImageSource.gallery);
              },
              child: const IconColumn(
                icon: Icons.photo_library,
                label: 'Gallery',
              ),
            ),
            GestureDetector(
              onTap: () {
                // Speak the message for camera using TtsHelper
                _ttsHelper.speak("Get the image from camera");
              },
              onDoubleTap: () {
                // Pick the image from camera on double-tap
                pickImage(ImageSource.camera);
              },
              child: const IconColumn(
                icon: Icons.camera,
                label: 'Camera',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IconColumn extends StatelessWidget {
  final IconData icon;
  final String label;

  const IconColumn({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {},
          icon: Icon(
            icon,
            color: Colors.white,
            size: 70,
          ),
        ),
        Text(label),
      ],
    );
  }
}
