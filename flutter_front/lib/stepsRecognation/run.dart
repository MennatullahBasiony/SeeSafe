import 'package:flutter/material.dart';
import 'package:flutter_front/screens/home_screen.dart';
import 'package:flutter_front/tts_helper.dart';
import 'package:flutter_front/stepsRecognation/steps.dart';


class Run extends StatefulWidget {
  static int runStepsCount = 0;
  static int distanceRan = 4;
  Run({Key? key}) : super(key: key);

  @override
  State<Run> createState() => _RunState();
}

class _RunState extends State<Run> {
  final TtsHelper _ttsHelper = TtsHelper();
  Steps stepsCounter = Steps();
  int initSteps = 0, finalSteps = 0, totalSteps = 0;

  @override
  void initState() {
    _ttsHelper.speak("help the application to learn your running pattern");
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
            backgroundColor: MaterialStateProperty.all<Color>(
                const Color.fromARGB(255, 82, 83, 83)),
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
              Icons.directions_run_rounded,
              size: 140,
              color: Color.fromARGB(255, 26, 26, 26),
            ),
            const SizedBox(height: 30),
            buildButton(
              text: 'Start Walking Fast',
              speechText:
                  'Please walk fast for 4 meters to witness the efficiency of your every stride',
              onTap: () {
                // Action on single tap for Start Walking
                stepsCounter.initSteps = 0;
                stepsCounter.steps = 0;
                _ttsHelper.speak('Click to start walking fast.');
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
              text: 'End Walking Fast',
              speechText: 'End Walking Fast',
              onTap: () {
                // Action on single tap for End Running
                _ttsHelper.speak('Click to declare walking fast ended');
              },
              onDoubleTap: () {
                setState(() {
                  initSteps = stepsCounter.initSteps;
                  finalSteps = stepsCounter.steps;
                  totalSteps = finalSteps - initSteps;
                  Run.runStepsCount = totalSteps;
                });
                print("init steps: $initSteps, final steps: $finalSteps, total steps: $totalSteps");
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
