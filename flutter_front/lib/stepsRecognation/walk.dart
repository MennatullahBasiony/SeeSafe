import 'package:flutter/material.dart';
import 'package:flutter_front/stepsRecognation/run.dart';
import 'package:flutter_front/tts_helper.dart';
import 'package:flutter_front/stepsRecognation/steps.dart';

class Walk extends StatefulWidget {
  const Walk({Key? key}) : super(key: key);
  static int walkStepsCount = 0;
  static int distanceWalked = 4;
  @override
  State<Walk> createState() => _WalkState();
}

class _WalkState extends State<Walk> {
  final TtsHelper _ttsHelper = TtsHelper();
  Steps stepsCounter = Steps();
  int initSteps = 0, finalSteps = 0, totalSteps = 0;  

  @override
  void initState() {
    _ttsHelper.speak("help the application to learn your walking pattern");
    super.initState();
    stepsCounter.initPlatformState();
  }

 

  Widget buildButton({
    required String text,
    required String speechText,
    required Function() onTap,
    required Function() onDoubleTap,
  }) {
    return GestureDetector(
      onTap: () async {
        await _ttsHelper.speak(speechText);
        onTap();
      },
      onDoubleTap: onDoubleTap,
      child: SizedBox(
        width: 380,
        height: 200,
        child: ElevatedButton(
          onPressed: null,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 82, 83, 83)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 165, 168, 170),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.directions_walk,
              size: 140,
              color: Color.fromARGB(255, 26, 26, 26),
            ),
            const SizedBox(height: 30),
            buildButton(
              text: 'Start Walking',
              speechText: 'Please start walking at a steady and normal pace for 4 meters exactly to help the application recognize your typical steps.',
              onTap: () {
                // Action on single tap for Start Walking
                _ttsHelper.speak('Click to start walking.');
                stepsCounter.initSteps = 0;
                stepsCounter.steps = 0;
              },
              onDoubleTap: () {
                setState(() {
                  initSteps = stepsCounter.initSteps;
                });
                print("init steps at start: $initSteps");
              },
            ),
            const SizedBox(height: 20),
            buildButton(
              text: 'End Walking',
              speechText: 'End walking.',
              onTap: () {
                // Action on single tap for End Walking
                _ttsHelper.speak('Click to declare walking ended');
              },
              onDoubleTap: () {
                setState(() {
                  initSteps = stepsCounter.initSteps;
                  finalSteps = stepsCounter.steps;
                  totalSteps = finalSteps - initSteps;
                  Walk.walkStepsCount = totalSteps;
                });
                print("*** init steps: $initSteps, final steps: $finalSteps, total steps: $totalSteps ***");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Run()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
