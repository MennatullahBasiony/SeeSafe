import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_front/search_places_screen.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_front/camera_tasks/camera_screen.dart';

class Outdoor extends StatefulWidget {
  const Outdoor({Key? key}) : super(key: key);

  @override
  _OutdoorState createState() => _OutdoorState();
}

class _OutdoorState extends State<Outdoor> {
  final SpeechToText _speech = SpeechToText();
  String _text = "Hold button and start speaking";
  bool _isListening = false;
  Timer? _listeningTimer;

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
          children: <Widget>[
            SizedBox(
              width: 200,
              height: 200,
              child: FloatingActionButton(
                onPressed: _listenAndNavigate,
                backgroundColor: Colors.white,
                elevation: 0,
                heroTag: null,
                shape: CircleBorder(),
                child: Icon(
                  _isListening ? Icons.mic : Icons.mic_none,
                  size: 80,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              _text,
              style: TextStyle(
                fontSize: 24,
                color: _isListening ? Colors.black87 : Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _listenAndNavigate() async {
    CameraScreen();
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListening = true;
          _text = "Listening...";
        });
        _speech.listen(
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
            });
            _startDelayedNavigation();
          },
        );

        _listeningTimer = Timer(Duration(seconds: 15), () {
          _stopListening();
        });
      }
    } else {
      _stopListening();
    }
  }

  void _stopListening() {
    setState(() {
      _isListening = false;
      _text = "Hold button and start speaking";
    });
    _speech.stop();

    if (_listeningTimer != null) {
      _listeningTimer!.cancel();
      _listeningTimer = null;
    }
  }

  void _startDelayedNavigation() {
    Future.delayed(Duration(seconds: 2), () {
      if (_text.isNotEmpty) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPolylineScreen(searchQuery: _text),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }
}
