import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_front/screens/home_screen.dart';
import 'package:flutter_front/screens/tutorialScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({Key? key}) : super(key: key);
  

  Future<void> _requestPermissions(BuildContext context) async {


    // Request permission for GPS
    PermissionStatus gpsStatus = await Permission.locationWhenInUse.request();
    // Request permission for WiFi
    PermissionStatus wifiStatus = await Permission.location.request();
    // Request permission for camera
    PermissionStatus cameraStatus = await Permission.camera.request();
    // Request permission for microphone
    PermissionStatus micStatus = await Permission.microphone.request();
    


    // Check if all permissions are granted
    if (gpsStatus.isGranted &&
        wifiStatus.isGranted &&
        cameraStatus.isGranted &&
        micStatus.isGranted ) {
      _storePermissionInfo(); // Store permission info once granted
      // Navigate to the tutorial screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TutorialScreen()),
      );
    } else {
      // Permissions are not granted, show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Some permissions are not granted!'),
        ),
      );
    }
  }

  Future<void> _storePermissionInfo() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    await sharedPref.setBool('permissionsGranted', true);
  }

  Future<bool> _checkPermissionsStatus() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getBool('permissionsGranted') ?? false; // false if null 
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkPermissionsStatus(),
      builder: (context, snapshot) { // snapshots hold the results of the _checkPermissionsStatus()
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          if (snapshot.data == true) {
            return const HomeScreen();
          } else {
            // Permissions are not granted, show the permission screen
            return Scaffold(
              backgroundColor: const Color(0xFFDCEEFD),
              body: Center(
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  margin: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Permission Request",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      const Text(
                        "To optimize your app experience, we kindly ask for access to GPS, Wi-Fi, mobile data, microphone, camera, and gallery.\n\nGranting these permissions ensures seamless functionality and enhanced features. Do not worry! Your privacy is our priority.",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => _requestPermissions(context),
                            child: const Text('Allow'),
                          ),
                          const SizedBox(width: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              // Show message to request permission again
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'We need permission so the app can work.'),
                                ),
                              );
                            },
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
      },
    );
  }
}
