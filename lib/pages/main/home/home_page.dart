import 'dart:async';
import 'dart:ui' as ui;
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:giuaki_map_location/constants/color_constants.dart';
import 'package:giuaki_map_location/controller/home/homepage_controller.dart';
import 'package:giuaki_map_location/models/station.dart';
import 'package:giuaki_map_location/pages/main/home/direction_parking.dart';
import 'package:giuaki_map_location/pages/main/list_parking/detail_parking_screen.dart';
import 'package:giuaki_map_location/services/place_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomepageController _homeController = HomepageController();
  final Completer<GoogleMapController> _googleMapController = Completer();
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  CameraPosition? _cameraPosition;
  Location? _location;
  LocationData? _currentLocation;

  // CREATE MARKET (PARKING CAR POSITION)

  final List<Marker> myMarkers = [];
  List<String> images = [
    'assets/images/parking_here.png',
  ];

  // GET API
  final PlaceService apiService = PlaceService();
  final List<Station> station = [];

  // Hiển thị vị trí đậu xe lên màn hình
  @override
  void initState() {
    _init();
    super.initState();
    getParkingAPI();
  }

  _init() async {
    _location = Location();
    _cameraPosition = const CameraPosition(
      target: LatLng(15.975295, 108.252345),
      zoom: 14,
    );
  }

  // Hiển thị vị trí của map là địa chỉ người dùng hiện tại
  // _initLocation() async {
  //   _location?.getLocation().then((location) => _currentLocation = location);
  //   _location?.onLocationChanged.listen((newLocation) {
  //     _currentLocation = newLocation;
  //     moveToPosion(LatLng(
  //         _currentLocation?.latitude ?? 0, _currentLocation?.longitude ?? 0));
  //   });
  // }

  // moveToPosion(LatLng latLng) async {
  //   GoogleMapController mapController = await _googleMapController.future;
  //   mapController.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(target: latLng, zoom: 13),
  //     ),
  //   );
  // }

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

  // GET RESULTS FROM API
  Future<void> getParkingAPI() async {
    try {
      final PlaceService apiService = PlaceService();
      List<Station> apiData = await apiService.getStations();
      for (int i = 0; i < apiData.length; i++) {
        print(">>>>>>>>>>>>>> Station NEW:  ${apiData[i].lat}");
        final Uint8List imageData = await getImageFromMakers(
            images[0], 100); // lay anh parking potision
        print(">>>>>>>>>>>>STATION: ${apiData}");
        myMarkers.add(
          Marker(
            markerId: MarkerId(i.toString()),
            position: LatLng(apiData[i].lat, apiData[i].long),
            icon: BitmapDescriptor.fromBytes(imageData),
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                Container(
                  height: 200.h,
                  width: 200.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: ColorsConstants.kActiveColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          width: 300.w,
                          height: 120.h,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(apiData[i].image),
                              fit: BoxFit.fitWidth,
                              filterQuality: FilterQuality.high,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.sp),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 150.w,
                                child: Text(
                                  apiData[i].name,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14.sp, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.sp),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ParkingItemScreen(
                                        idParking: apiData[i]
                                            .id, // Truyền thông tin sản phẩm
                                        name: apiData[i].name,
                                        address: apiData[i].address,
                                        image: apiData[i].image,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 8.h),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    "Detail",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w,),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DirectionParking(
                                        idParking: apiData[i]
                                            .id, // Truyền thông tin sản phẩm
                                            lat: apiData[i].lat,
                                            long: apiData[i].long,
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 8.h),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    "Chỉ đường",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                LatLng(apiData[i].lat, apiData[i].long),
              );
            },
          ),
        );
        setState(() {});
      }
    } catch (e) {
      print(">>>>>>>>>>>>>>>>>>>>>>>Error fetching data from the API: $e");
    }
  }

  // GET DATA USER CURRENT POSITION
  getCurrentPosion() {
    getUserLocation().then(
      (value) async {
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
        setState(() {});
        CameraPosition cameraPosition = CameraPosition(
          target: LatLng(value.latitude, value.longitude),
          zoom: 14,
        );
        final GoogleMapController controller =
            await _googleMapController.future;

        controller
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          initialCameraPosition: _cameraPosition!,
          mapType: MapType.normal,
          markers: Set<Marker>.of(myMarkers),
          onTap: (position) {
            _customInfoWindowController.hideInfoWindow!();
          },
          onCameraMove: (position) {
            _customInfoWindowController.onCameraMove!();
          },
          onMapCreated: (GoogleMapController controller) {
            _customInfoWindowController.googleMapController = controller;
            _googleMapController.complete(controller);
          },
        ),
        CustomInfoWindow(
          controller: _customInfoWindowController,
          height: 230,
          width: 200,
          offset: 40,
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsConstants.kActiveColor,
        child: const Icon(Icons.my_location),
        elevation: 4,
        onPressed: () {
          getCurrentPosion();
          print("CURRENT POSITION");
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
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
      child: ClipOval(child: Image.asset("assets/images/tan.png")),
    );
  }
}
