import 'dart:convert';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as Im;
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_front/camera_tasks/box_painter.dart';
import 'package:flutter_front/camera_tasks/image_process.dart' as img_processor;
import 'package:flutter_front/camera_tasks/calcDistance.dart'
    as dist_calculator;


class CameraScreen extends StatefulWidget {
  String choosenModel;
  final bool navigateToMap;
  final LatLng? start;
  final LatLng? destination;
  CameraScreen({super.key, this.choosenModel = "", this.navigateToMap = false, this.start, this.destination});

  @override
  State<CameraScreen> createState() => _CameraScreenState(choosenOption: choosenModel);
}

class _CameraScreenState extends State<CameraScreen> {
  bool isWorking = false;
  int sendCount = 0;
  List<CameraDescription>? cameras;
  CameraController? cameraController;
  CameraImage? imgCamera;
  Uint8List? img_mem;
  Im.Image? imageFromCam;
  Map<String, dynamic>? predicted_bboxes;
  bool prediction_received = false;
  List<String> predictedClasses = [];
  List<List<double>> bboxXYWH = [];
  var img_process;
  String choosenOption = "";
  _CameraScreenState({this.choosenOption = ""});

  @override
  void initState()
  {
    super.initState();
    print("#####---- $choosenOption -------########");
    img_process = choosenOption == "Indoor"? img_processor.Image_Process(URL: 'http://192.168.162.86:5000/api/indoor') : img_processor.Image_Process(URL: 'http://192.168.162.86:5000/api/outdoor');
    initializeCamera();
  }

  void initializeCamera() async 
  {  
    cameras = await availableCameras();
    if(cameras!.isNotEmpty)
    {
      // setState(() {
        cameraController = CameraController(
          cameras![0], // Assuming the first camera is the one we want to use.
          ResolutionPreset.medium,
          imageFormatGroup: ImageFormatGroup.yuv420, 
           
        );
      // });
    }

    await cameraController!.initialize().then((value) 
    {
      if(!mounted)  return;
      setState(()
      {
        cameraController?.startImageStream((image) async => await img_process.processImage(image));
      });
    });
  }

  void launchGoogleMaps() async {
    if (widget.start != null && widget.destination != null) {
      final url =
          'https://www.google.com/maps/dir/?api=1&origin=${widget.start!.latitude},${widget.start!.longitude}&destination=${widget.destination!.latitude},${widget.destination!.longitude}&travelmode=walking';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }
  }

  // Widget
  @override
  Widget build(BuildContext context) {
     // Dimensions your model expects
    final modelWidth = 640.0;
    final modelHeight = 448.0;
  
    // Get the actual size of the CameraPreview
    final previewWidth = MediaQuery.of(context).size.width;
    final previewHeight = MediaQuery.of(context).size.height;

    // Scalling factor
    double scaleX = previewWidth /modelWidth;
    double scaleY = previewHeight /modelHeight;

    final deviceRatio = previewWidth/previewHeight;

    if (cameraController == null || !cameraController!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    else{
      // Calculate scale factors
    double scale = cameraController!.value.aspectRatio *deviceRatio ;
    
    if (scale < 1) scale = 1/scale;
      return Scaffold(
        // scale: scale,
        body: Center(
          child: Stack(
            children: [
                CameraPreview(cameraController!),
              if (predicted_bboxes != null )...[
                    CustomPaint(
                      painter: BoPainter(scaleX: scaleX, scaleY: scaleY, detectedObjects: predicted_bboxes),
                    ),
              ],
            ],
          ),
        )
      );
    }
  }

  @override
  void dispose() {
    cameraController?.dispose();
    super.dispose();
  }
}
