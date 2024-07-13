import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_front/tts_helper.dart';
import '../stepsRecognation/run.dart';
import '../stepsRecognation/walk.dart';

class DistanceFromCamera{
  double focalLength = .29;  // in mm
  double img_width = 640.0; // model width
  double bbox_width = 0.0;
  double horiResMM = 0.0;
  double hfov;
  double distance = 0.0;
  double pixelTOMM = 0.2645833333;
  double horsiMM = 169.33333;
  double halfHFOV = 0.0;
  double distanceToMarble = 0;
  double diameterDetectedMarble = 0.0;
  double minDist = 10000.0;
  List<double> distList = [];
  List<String> objOrderedByDist = [];

  DistanceFromCamera(this.img_width, this.focalLength)
  : hfov = atan(img_width / (focalLength * 2)) * 2;
  

  List<String> calcDistanceFromCam (Map<String, dynamic>? predictedBBoxes)
  {
    horiResMM = img_width * pixelTOMM / 2;
    distList.clear();
    if (predictedBBoxes != null){
      for (var i = 0; i < predictedBBoxes.length; i++) 
      {
        var box = predictedBBoxes['box$i'];
        bbox_width = box['xywh'][2];
        diameterDetectedMarble = bbox_width / 2;
        diameterDetectedMarble *= pixelTOMM;
        distance = (focalLength * horiResMM) / diameterDetectedMarble;
        distanceToMarble = (distance * pixelTOMM);  
        distList.add(distanceToMarble);
        predictedBBoxes['box$i']['distance'] = distanceToMarble;
        print("in calc distance for ${predictedBBoxes['box$i']['className']}");
      }
      sortDist(distList, predictedBBoxes);
      return objOrderedByDist;
    }
    return objOrderedByDist;
  }

  void sortDist(List<double>list, Map<String, dynamic>? predictedBBoxes)
  {
    if (list.length > 0)
    {
      int listLength = list.length;
      list.sort();
      objOrderedByDist.clear();
      for(int i = 0; i < listLength; i ++)
      {
        if(list[i] < 200)
        {
          for(int j = 0; j < listLength; j ++)
          {
            if(predictedBBoxes!['box$j']['distance'] == list[i]) objOrderedByDist.add(predictedBBoxes['box$j']["className"]);
          }
        }
      }
      minDist = list[0];
    }
  }

  double minDistCalculated(){
    return minDist;
  }

}