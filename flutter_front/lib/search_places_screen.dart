import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_front/camera_tasks/camera_screen.dart';
import 'package:flutter_front/screens/specific_place.dart';
import 'package:flutter_front/tts_helper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_front/Model/Polyline_response.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchPolylineScreen extends StatefulWidget {
    final String searchQuery;
  const SearchPolylineScreen({Key? key, required this.searchQuery})
      : super(key: key);

  @override
  State<SearchPolylineScreen> createState() => _SearchPolylineScreenState();
}

const kGoogleApiKey =
    "AIzaSyDFFPwP1Wh6ELP9FebgOVGPmR-TGxObWD0"; // Replace with your Google Maps API Key
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _SearchPolylineScreenState extends State<SearchPolylineScreen> {
  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(31.2001, 29.9187), // Alexandria, Egypt
    zoom: 10,
  );

  final Completer<GoogleMapController> _controller = Completer();

  String totalDistance = "";
  String totalTime = "";

  LatLng? currentLocation;
  LatLng? destinationLocation;

  Set<Polyline> polylinePoints = {};
  Set<Marker> markersList = {};

  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  Timer? _debounce;

  final TtsHelper _ttsHelper = TtsHelper(); // Initialize the TTS helper

  @override
  void initState() {
    super.initState();
    _ttsHelper.speak(
        " we navigate to search screen to search about ${widget.searchQuery}");
    _searchController.text = widget.searchQuery;
    _searchController.addListener(_onSearchChanged);
    _setCurrentLocation();
    _searchPlaces(widget.searchQuery);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    _ttsHelper.stopSpeaking(); // Stop TTS when the screen is disposed of
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _searchPlaces(_searchController.text);
    });
  }

  Future<void> _searchPlaces(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$kGoogleApiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _searchResults = data['results'];
      });
    } else {
      setState(() {
        _searchResults = [];
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> displayPrediction(dynamic place) async {
    final lat = place['geometry']['location']['lat'];
    final lng = place['geometry']['location']['lng'];
    final placeName = place['name'];
    final placeAddress = place['formatted_address'];

    // Set TTS language based on the place name and address
    await _ttsHelper.setTtsLanguage("$placeName $placeAddress");

    // Read the place information using TTS
    await _ttsHelper
        .speak("Selected Place: $placeName. Address: $placeAddress.");

    // Display prediction information in a Snackbar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          "Selected Place: $placeName\nAddress: $placeAddress\nLatitude: $lat, Longitude: $lng"),
    ));
  }

 void launchNavigation(LatLng start, LatLng destination) async {
  await _ttsHelper.stopSpeaking();
  _ttsHelper.speak(
      "We will open the camera to start detect the objects infront of you also google map application will start guiding you to ${widget.searchQuery}");

  // Navigate to CameraScreen
  bool? result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => CameraScreen(navigateToMap: true, start: start, destination: destination, choosenModel: 'Outdoor',)),
  );

  // Check if CameraScreen has returned a result indicating to proceed with map navigation
  if (result == true) {
    final url =
        'https://www.google.com/maps/dir/?api=1&origin=${start.latitude},${start.longitude}&destination=${destination.latitude},${destination.longitude}&travelmode=walking';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}


  Future<void> drawPolyline() async {
    if (currentLocation == null || destinationLocation == null) {
      return;
    }

    var response = await http.post(Uri.parse(
        "https://maps.googleapis.com/maps/api/directions/json?key=$kGoogleApiKey&units=metric&origin=${currentLocation!.latitude},${currentLocation!.longitude}&destination=${destinationLocation!.latitude},${destinationLocation!.longitude}&mode=walking"));

    PolylineResponse polylineResponse =
        PolylineResponse.fromJson(jsonDecode(response.body));

    totalDistance = polylineResponse.routes![0].legs![0].distance!.text!;
    totalTime = polylineResponse.routes![0].legs![0].duration!.text!;

    polylinePoints.clear(); //delete any additional lines
    List<LatLng> polylineCoordinates = [];
    polylineResponse.routes![0].legs![0].steps!.forEach((step) {
      polylineCoordinates
          .add(LatLng(step.startLocation!.lat!, step.startLocation!.lng!));
      polylineCoordinates
          .add(LatLng(step.endLocation!.lat!, step.endLocation!.lng!));
    });

    polylinePoints.add(Polyline(
      polylineId: const PolylineId("polyline"),
      points: polylineCoordinates,
      width: 4,
      color: Colors.red,
    ));

    setState(() {});

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngBounds(
      LatLngBounds(
        southwest: LatLng(
          currentLocation!.latitude < destinationLocation!.latitude
              ? currentLocation!.latitude
              : destinationLocation!.latitude,
          currentLocation!.longitude < destinationLocation!.longitude
              ? currentLocation!.longitude
              : destinationLocation!.longitude,
        ),
        northeast: LatLng(
          currentLocation!.latitude > destinationLocation!.latitude
              ? currentLocation!.latitude
              : destinationLocation!.latitude,
          currentLocation!.longitude > destinationLocation!.longitude
              ? currentLocation!.longitude
              : destinationLocation!.longitude,
        ),
      ),
      100,
    ));
  }

  Future<void> _setCurrentLocation() async {
    Position position = await _determinePosition();

    currentLocation = LatLng(position.latitude, position.longitude);

    markersList.clear();
    markersList.add(Marker(
      markerId: const MarkerId('currentLocation'),
      position: currentLocation!,
      infoWindow: const InfoWindow(title: "Current Location"),
    ));

    setState(() {});
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  void _onPlaceDoubleTapped(dynamic place) async {
    final lat = place['geometry']['location']['lat'];
    final lng = place['geometry']['location']['lng'];

    setState(() {
      destinationLocation = LatLng(lat, lng);
      markersList.add(Marker(
        markerId: MarkerId('destination'),
        position: destinationLocation!,
        infoWindow: InfoWindow(title: place['name']),
      ));
      _searchResults = [];
    });

    drawPolyline();
    launchNavigation(currentLocation!, destinationLocation!);
  }

  Future<bool> _onBackPressed() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Outdoor()),
    );
    return Future.value(
        false); // Prevents default behavior of popping the screen
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: homeScaffoldKey,
        body: Stack(
          children: [
            GoogleMap(
              polylines: polylinePoints,
              markers: markersList,
              zoomControlsEnabled: false,
              initialCameraPosition: initialCameraPosition,
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 0),
                  child: GestureDetector(
                    onDoubleTap: () async {
                      await _ttsHelper.speak("Starting navigation");
                      if (currentLocation != null &&
                          destinationLocation != null) {
                        launchNavigation(
                            currentLocation!, destinationLocation!);
                      }
                    },
                    child: TextField(
                      controller: _searchController,
                      onTap: () async {
                        await _ttsHelper.speak("Search Places");
                      },
                      decoration: InputDecoration(
                        hintText: 'Search Places',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                    ),
                  ),
                ),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                if (_searchResults.isNotEmpty)
                  Expanded(
                    child: ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final place = _searchResults[index];
                        return GestureDetector(
                          onDoubleTap: () => _onPlaceDoubleTapped(place),
                          child: Card(
                            elevation: 5,
                            color: Colors.white,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 15),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              title: Text(place['name']),
                              subtitle: Text(place['formatted_address']),
                              trailing: const Icon(Icons.arrow_forward),
                              onTap: () => displayPrediction(place),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                if (totalDistance.isNotEmpty && totalTime.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Total Distance: $totalDistance"),
                        Text("Total Time: $totalTime"),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
