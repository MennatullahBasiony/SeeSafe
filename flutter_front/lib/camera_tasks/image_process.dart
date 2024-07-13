import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as Im;
import 'package:http/http.dart' as http;
import 'package:flutter_front/camera_tasks/calcDistance.dart' as dist_calculator;
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_front/tts_helper.dart';
import '../stepsRecognation/run.dart';
import '../stepsRecognation/walk.dart';

class Image_Process
{
  bool isWorking = false;
  static int sendCount = 0;
  Im.Image? imageFromCam;
  String URL = 'http://192.168.142.87:5000/api/uploadImage';
  Map<String, dynamic>? predicted_bboxes;
  List<String> predictedClasses = [];
  List<dynamic>? calcDistanceResults;
  List<String> objOrderedByDist = [];
  int stepsPerDistanceMeasured = ((Walk.walkStepsCount + Run.runStepsCount) /2).toInt();
  dist_calculator.DistanceFromCamera distanceCalculator = dist_calculator.DistanceFromCamera(720.0, 24.0);
  final TtsHelper _ttsHelper = TtsHelper();
  
  Image_Process({this.URL='http://192.168.142.87:5000/api/uploadImage'});

  Future<void> processImage(CameraImage image) async 
  {
    if (!isWorking) 
    {
      if(sendCount % 20 == 0)
      {
        isWorking = true;
        try 
        {
          String base64Img = await convertYUV420ToBase64Image(image);
          await sendImage(base64Img);
          await sayObjs(objOrderedByDist);
          objOrderedByDist.clear();
        } catch (e) {
          print('Error processing image: $e');
        }
        isWorking = false;

        sendCount = 0;
      }
      sendCount += 1;
    }
  }

  Future<void> sendImage(String base64Img) async 
  {
    try 
    {
      var response = await http.post(
        Uri.parse(URL),
        body: base64Img,
        headers: {'Content-type': 'application/json', 'Accept': 'application/json'},
      );

      if (response.statusCode == 200) 
      {
        print('Image sent successfully');
        var responseData = jsonDecode(response.body);
        if(responseData != null && responseData is String)
        {
          print(responseData);
            predicted_bboxes= null;
        }
        else if (responseData != null && responseData is! String) 
        {
            
          predicted_bboxes = responseData;
          objOrderedByDist = distanceCalculator.calcDistanceFromCam(predicted_bboxes);
          print("obj ordered by dist: $objOrderedByDist");

          for (var i = 0; i < predicted_bboxes!.length; i++) 
          {
            var box = predicted_bboxes!['box$i'];
            if (box != null) 
            {
              predictedClasses.add(box['className']);
            }
          }

          predictedClasses.clear();
        }
      } else {
        print('Failed to send image');
      }
    } catch (e) {
      print('Error sending image: $e');
    }
  }

  Future<void> sayObjs(List<String>objs) async{
    if (objs == null || objs.isEmpty) return;
    List<String> countList = [];

    int count = 0;
    for (String obj in objs){
      count = 0;
      for (int i = 0; i < objs.length; i++) {
        if (objs[i] == obj)
        { 
          count++;
        }
      }
      if(countList.contains("${count} ${obj}")) continue;
      if(count == 1)
      {
        countList.add("$obj");
        continue;
      } 
      countList.add("${count} ${obj}");
    }
    print("count list: $countList");

    for (String obj in countList)
    {
      print("currently spoken word ${obj}");
      await _ttsHelper.speak(obj);
    }
    double minDist = distanceCalculator.minDistCalculated();
    print("walk steps count: ${Walk.walkStepsCount}, run steps count ${Run.runStepsCount}");
    int nSteps = (((7 * minDist) /40).round()).toInt();
    if(nSteps > 0)  await _ttsHelper.speak("you have $nSteps steps to collide");
    print("nSteps: $nSteps, minDist: $minDist");
  }

  String convertYUV420ToBase64Image(CameraImage cameraImage) {
    final imageWidth = cameraImage.width;
    final imageHeight = cameraImage.height;

    final yBuffer = cameraImage.planes[0].bytes;
    final uBuffer = cameraImage.planes[1].bytes;
    final vBuffer = cameraImage.planes[2].bytes;

    final int yRowStride = cameraImage.planes[0].bytesPerRow;
    final int yPixelStride = cameraImage.planes[0].bytesPerPixel!;

    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel!;

    final image = Im.Image(imageWidth, imageHeight);

    for (int h = 0; h < imageHeight; h++) {
      int uvh = (h / 2).floor();

      for (int w = 0; w < imageWidth; w++) {
        int uvw = (w / 2).floor();

        final yIndex = (h * yRowStride) + (w * yPixelStride);

        // Y plane should have positive values belonging to [0...255]
        final int y = yBuffer[yIndex];

        // U/V Values are subsampled i.e. each pixel in U/V chanel in a
        // YUV_420 image act as chroma value for 4 neighbouring pixels
        final int uvIndex = (uvh * uvRowStride) + (uvw * uvPixelStride);

        // U/V values ideally fall under [-0.5, 0.5] range. To fit them into
        // [0, 255] range they are scaled up and centered to 128.
        // Operation below brings U/V values to [-128, 127].
        final int u = uBuffer[uvIndex];
        final int v = vBuffer[uvIndex];

        // Compute RGB values per formula above.
        int r = (y + v * 1436 / 1024 - 179).round();
        int g = (y - u * 46549 / 131072 + 44 - v * 93604 / 131072 + 91).round();
        int b = (y + u * 1814 / 1024 - 227).round();

        r = r.clamp(0, 255);
        g = g.clamp(0, 255);
        b = b.clamp(0, 255);

        final int argbIndex = h * imageWidth + w;

        image.data[argbIndex] = 0xff000000 |
            ((b << 16) & 0xff0000) |
            ((g << 8) & 0xff00) |
            (r & 0xff);
      }
    }
    Uint8List jpg_img = Uint8List.fromList(Im.encodeJpg(image));
    String base64Img = base64Encode(jpg_img);
    return base64Img;
  }
}

