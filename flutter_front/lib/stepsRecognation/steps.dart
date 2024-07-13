import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';

class Steps {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String status = '?';
  int steps = 0;
  int initSteps = 0;

  void onStepCount(StepCount event) {
    if(initSteps == 0 && event.steps != 0)  initSteps = event.steps;
    steps = event.steps;
    print("step count event: $steps\n");
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    status = event.status;
    print("state change event: $status\n");
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    status = 'Pedestrian Status not available';
    print(status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    // setState(() {
      steps = -1;
    // });
  }

  void initPlatformState() async{
    if (await Permission.activityRecognition.request().isGranted){
      print("pedometer permissions granted");
      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      _pedestrianStatusStream
          .listen(onPedestrianStatusChanged)
          .onError(onPedestrianStatusError);

      _stepCountStream = Pedometer.stepCountStream;
      _stepCountStream.listen(onStepCount).onError(onStepCountError);
      initSteps = 0;
    }else{
      print("no permissions granted");
    }
    
    // if (!mounted) return;
    print("status: $status, steps: $steps");
  }
}
