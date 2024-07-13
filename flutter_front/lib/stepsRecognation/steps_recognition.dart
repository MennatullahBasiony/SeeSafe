// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:pedometer/pedometer.dart';
// import 'package:permission_handler/permission_handler.dart';

// class StepsRecognition extends StatefulWidget {
//   const StepsRecognition({super.key});

//   @override
//   State<StepsRecognition> createState() => _StepsRecognitionState();
// }

// class _StepsRecognitionState extends State<StepsRecognition> {
//   late Stream<StepCount> _stepCountStream;
//   late Stream<PedestrianStatus> _pedestrianStatusStream;
//   String _status = '?';
//   int _steps = 0;
//   bool walkFinish = false;

//   @override
//   void initState(){
//     super.initState();
//     initPlatformState();
//   }

//   void onStepCount(StepCount event) {
//     print("step count event: $event\n");
//     setState(() {
//       _steps = event.steps;
//     });
//   }

//   void onPedestrianStatusChanged(PedestrianStatus event) {
//     print("state change event: $event\n");
//     setState(() {
//       _status = event.status;
//     });
//   }

//   void onPedestrianStatusError(error) {
//     print('onPedestrianStatusError: $error');
//     setState(() {
//       _status = 'Pedestrian Status not available';
//     });
//     print(_status);
//   }

//   void onStepCountError(error) {
//     print('onStepCountError: $error');
//     setState(() {
//       _steps = -1;
//     });
//   }

//   void initPlatformState() async{
//     if (await Permission.activityRecognition.request().isGranted){
//       print("permissions granted");
//       _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
//       _pedestrianStatusStream
//           .listen(onPedestrianStatusChanged)
//           .onError(onPedestrianStatusError);

//       _stepCountStream = Pedometer.stepCountStream;
//       _stepCountStream.listen(onStepCount).onError(onStepCountError);
//     }else{
//       print("no permissions granted");
//     }
//     print("status: $_status, steps: $_steps");
    
//     if (!mounted) return;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 165, 168, 170),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if(walkFinish == true) ...[
//               Icon(
//                 Icons.directions_walk, // Icon of a person walking
//                 size: 160, // Adjust the size of the icon as needed
//                 color: Color.fromARGB(255, 26, 26, 26), // Color of the icon
//               ),
//               SizedBox(height: 20), // Adding space between the icon and text
//               Text(
//                 'Please walk for 2 meters at a steady and normal pace to help the application recognize your typical steps.',
//                 textAlign: TextAlign.center, // Aligning text to the center
//                 style: TextStyle(
//                   color: Color.fromARGB(255, 26, 26, 26), // Color of the icon
//                   fontWeight: FontWeight.bold,
//                   fontSize: 15, // Making text bold
//                 ),
//               ),
//             ],
            
//             ElevatedButton(
//               onPressed: () async => {
//                 if(await stepsCounter != 0){
//                   setState(() {
//                     initSteps = stepsCounter.steps;
//                     print("init steps: $initSteps");
//                   }),
//                 },
//               },
//               child: Text('Start'),
//             ),
//             ElevatedButton(
//               onPressed: () => {
//                 setState(() {
//                   finalSteps = stepsCounter.steps;
//                 }),
//                 print("final steps: $finalSteps"),
//               },
//               child: Text('Finish'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }