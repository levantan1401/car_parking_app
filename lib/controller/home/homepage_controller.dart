import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:giuaki_map_location/models/station.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomepageController extends GetxController {
  final Completer<GoogleMapController> _googleMapController = Completer();
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  CameraPosition? _cameraPosition;
  Location? _location;
  LocationData? _currentLocation;
  final getStorage = GetStorage();
  final List<Marker> myMarkers = [];
  // final List<LatLng> markerList = [
  //   LatLng(15.980467, 108.250201),
  //   LatLng(15.977002, 108.256552),
  //   LatLng(15.972298, 108.250201),
  // ];
  @override
  void onInit() {
    super.onInit();
    // packData();
  }
// Hiển thị vị trí đậu xe lên màn hình

  _init() async {
    _location = Location();
    _cameraPosition = const CameraPosition(
      target: LatLng(0, 0),
      zoom: 15,
    );
    _initLocation();
  }

  // Hiển thị vị trí của map là địa chỉ người dùng hiện tại
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

  //GET API 
  // FutureBuilder<Station> getDataAPI() {
  //   return 
  // }
 
  // GET DATA USER CURRENT POSITION
  getCurrentPosion() {
    getUserLocation().then(
      (value) async {
        print("CLICK METHOD getCurrentPosion");
        print("${value.latitude} ${value.longitude}");
        final Uint8List imageData =
            await getImageFromMakers('assets/images/tan.png', 100);
        myMarkers.add(
          Marker(
            markerId: MarkerId('currentID'),
            position: LatLng(value.latitude, value.longitude),
            icon: BitmapDescriptor.fromBytes(imageData),
          ),
        );
        // setState(() {});
        CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude),
          zoom: 14,
        );
        final GoogleMapController controller =
            await _googleMapController.future;

        controller
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        // setState(() {});
      },
    );
  }
}
