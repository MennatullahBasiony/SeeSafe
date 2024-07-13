// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_front/camera_tasks/camera_screen.dart';
// import 'package:http/http.dart' as http;
// import 'package:image/image.dart' as Im;
// import 'dart:async';
// import 'package:flutter_front/camera_tasks/box_painter.dart';
// import 'package:flutter_front/camera_tasks/image_process.dart' as img_processor;
// import 'package:flutter_front/camera_tasks/calcDistance.dart' as dist_calculator;


// class CameraScreenInBg {
//   bool isWorking = false;
//   int sendCount = 0;
//   List<CameraDescription>? cameras;
//   CameraController? cameraController;
//   CameraImage? imgCamera;
//   Uint8List? img_mem;
//   Im.Image? imageFromCam;
//   Map<String, dynamic>? predicted_bboxes;
//   bool prediction_received = false;
//   List<String> predictedClasses = [];
//   List<List<double>> bboxXYWH = [];
//   var img_process = img_processor.Image_Process(URL: 'http://192.168.1.2:5000/api/uploadImage');

//   CameraScreenInBg.create():
//     initializeCamera();

//   void initializeCamera() async 
//   {  
//     cameras = await availableCameras();
//     if(cameras!.isNotEmpty)
//     {
//       // setState(() {
//         cameraController = CameraController(
//           cameras![0], // Assuming the first camera is the one we want to use.
//           ResolutionPreset.medium,
//           imageFormatGroup: ImageFormatGroup.yuv420, 
           
//         );
//       // });
//     }

//     await cameraController!.initialize().then((value) 
//     {
//       if(!mounted)  return;
//       setState(()
//       {
//         cameraController?.startImageStream((image) async => await img_process.processImage(image));
//       });
//     });
//   }

//   // Widget
//   @override
//   Widget build(BuildContext context) {
//      // Dimensions your model expects
//     final modelWidth = 640.0;
//     final modelHeight = 448.0;
  
//     // Get the actual size of the CameraPreview
//     final previewWidth = MediaQuery.of(context).size.width;
//     final previewHeight = MediaQuery.of(context).size.height;

//     // Scalling factor
//     double scaleX = previewWidth /modelWidth;
//     double scaleY = previewHeight /modelHeight;

//     final deviceRatio = previewWidth/previewHeight;

//     if (cameraController == null || !cameraController!.value.isInitialized) {
//       return Center(child: CircularProgressIndicator());
//     }
//     else{
//       // Calculate scale factors
//     double scale = cameraController!.value.aspectRatio *deviceRatio ;
    
//     if (scale < 1) scale = 1/scale;
//       return Scaffold(
//         // scale: scale,
//         body: Center(
//           child: Stack(
//             children: [
//                 CameraPreview(cameraController!),
//               if (predicted_bboxes != null )...[
//                     CustomPaint(
//                       painter: BoPainter(scaleX: scaleX, scaleY: scaleY, detectedObjects: predicted_bboxes),
//                     ),
//               ],
//             ],
//           ),
//         )
//       );
//     }
//   }

//   @override
//   void dispose() {
//     cameraController?.dispose();
//     super.dispose();
//   }
// }
