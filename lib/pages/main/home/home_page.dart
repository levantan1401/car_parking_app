import 'dart:async';

import 'package:flutter/material.dart';
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

  @override
  void initState() {
    _init();
    // TODO: implement initState
    super.initState();
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
      moveToPosion(LatLng(_currentLocation?.latitude ?? 0, _currentLocation?.longitude ?? 0));
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
    return Stack(children: [
      GoogleMap(
        initialCameraPosition: _cameraPosition!,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          if (!_googleMapController.isCompleted) {
            _googleMapController.complete(controller);
          }
        },
      ),
      Positioned.fill(
        child: Align(
          alignment: Alignment.center,
          child: _getMarket(),
        ),
      )
    ]);
  }
}
