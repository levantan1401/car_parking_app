import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  Location? _location;
  LocationData? _currentLocation;

  // CREATE MARKET (PARKING CAR POSITION)
  final List<Marker> myMarkers = [];
  final List<Marker> markerList = const [
    Marker(
      markerId: MarkerId('First'),
      position: LatLng(15.973328, 108.251571),
      infoWindow: InfoWindow(title: 'My Home'),
    ),
  ];

  List<String> images = [
    'assets/images/tan.png',
  ];

  @override
  void initState() {
    _init();
    // TODO: implement initState
    super.initState();
    myMarkers.addAll(markerList);
  }

  _init() async {
    _location = Location();
    _cameraPosition = const CameraPosition(
      target: LatLng(0, 0),
      zoom: 15,
    );
    _initLocation();
  }

  // function generate location current
  _initLocation() async {
    _location?.getLocation().then((location) => _currentLocation = location);
    _location?.onLocationChanged.listen((newLocation) {
      _currentLocation = newLocation;
      moveToPosion(LatLng(
          _currentLocation?.latitude ?? 0, _currentLocation?.longitude ?? 0));
    });
  }

  moveToPosion(LatLng latLng) async {
    GoogleMapController mapController = await _googleMapController.future;
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 15),
      ),
    );
  }

  // Get the located for user
  Future<Position> getUserLocation() async {
    await Geolocator.requestPermission()
        .then(
      (value) {},
    )
        .onError((error, stackTrace) {
      print('Error: $error');
    });
    return await Geolocator.getCurrentPosition();
  }

  // THAY DOI ANH ICON THANH AVATAR USER
  Future<Uint8List> getImageFromMakers(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetHeight: width);
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    return (await frameInfo.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  // GET DATA USER CURRENT POSITION
  packData() {
    getUserLocation().then((value) async {
      print("CURRENT POSITION");
      print("${value.latitude} ${value.longitude}");
      for (int i = 0; i < images.length; i++) {
        final Uint8List imageData = await getImageFromMakers(images[i], 100);
        myMarkers.add(
          Marker(
            markerId: MarkerId('Second'),
            position: LatLng(value.latitude, value.longitude),
            icon: BitmapDescriptor.fromBytes(imageData),
            infoWindow: InfoWindow(
              title:
                  "Current with lat ${value.latitude} and long ${value.longitude}",
            ),
          ),
        );
        setState(() {});
      }
      CameraPosition cameraPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 14,
      );

      final GoogleMapController controller = await _googleMapController.future;

      controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return _getMap();
  }

  Widget _getMarket() {
    return Container(
      width: 40,
      height: 40,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
        boxShadow: const [
          BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 3),
              spreadRadius: 4,
              blurRadius: 6)
        ],
      ),
      child: ClipOval(child: Image.asset("assets/images/tan.jpg")),
    );
  }

  Widget _getMap() {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _cameraPosition!,
          mapType: MapType.normal,
          markers: Set<Marker>.of(myMarkers),
          onMapCreated: (GoogleMapController controller) {
            if (!_googleMapController.isCompleted) {
              _googleMapController.complete(controller);
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.my_location),
        elevation: 4,
        onPressed: () {
          packData();
        },

        // FILL ICON USER
        // Positioned.fill(
        //   child: Align(
        //     alignment: Alignment.center,
        //     child: _getMarket(),
        //   ),
        // ),
      ),
    );
  }
}
