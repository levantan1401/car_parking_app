import 'dart:developer';
import 'dart:typed_data';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:giuaki_map_location/constants/api_google_key.dart';
import 'package:giuaki_map_location/constants/color_constants.dart';
import 'package:giuaki_map_location/models/list_parking.dart';
import 'package:giuaki_map_location/models/station.dart';
import 'package:giuaki_map_location/pages/main/home/direction_parking.dart';
import 'package:giuaki_map_location/pages/main/home/map_demo.dart';
import 'package:giuaki_map_location/pages/main/list_parking/detail_parking_screen.dart';
import 'package:giuaki_map_location/pages/main/list_parking/search_parking.dart';
import 'package:giuaki_map_location/pages/search.dart';
import 'package:giuaki_map_location/services/list_parking_services.dart';
import 'package:giuaki_map_location/services/place_service.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:location/location.dart';
import 'package:vietmap_flutter_navigation/views/banner_instruction.dart';
import 'package:vietmap_flutter_plugin/vietmap_flutter_plugin.dart';

class MapHome extends StatefulWidget {
  const MapHome({super.key});

  @override
  State<MapHome> createState() => _MapHomeState();
}

class _MapHomeState extends State<MapHome> {
  List<Station> apiData = [];
  VietmapController? mapController;
  UserLocation? userLocation;
  late CameraPosition? cameraPosition;
  Location? _location;
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  final List<Marker> myMarkers = [];
  var isLight = true;
  final List<Station> data_api = [];

  @override
  void initState() {
    _init();
    super.initState();
    getParkingAPI();
    Vietmap.getInstance(VIETMAP_API_KEY);
  }

  _init() async {
    _location = Location();

    try {
      setState(() {});
      getUserLocation().then(
        (value) => {
          cameraPosition = CameraPosition(
              target: LatLng(value.latitude, value.longitude), zoom: 14),
        },
      );
    } catch (e) {
      print(e);
    } finally {
      cameraPosition = const CameraPosition(
        // target: LatLng(15.975295, 108.252345), // TRƯỜNG
        target: LatLng(16.071650, 108.220629), // LEDUAN: ,
        zoom: 14,
      );
    }
  }

  _onMapCreated(VietmapController controller) {
    mapController = controller;
  }

  // _onStyleLoadedCallback() {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     backgroundColor: Theme.of(context).primaryColor,
  //     duration: Duration(seconds: 1),
  //   ));
  // }

  _markerWidget(IconData icon) {
    return Icon(icon, color: Colors.red, size: 50);
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

  reNewLocation() {
    setState(() {
      myMarkers.clear();
    });
  }

  addLocationParking() async {
    for (int i = 0; i < apiData.length; i++) {
      var lat = apiData[i].lat;
      var lng = apiData[i].long;
      setState(() {
        myMarkers.add(
          Marker(
            alignment: Alignment.bottomCenter,
            width: 50,
            height: 50,
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(60.sp))),
                  builder: (BuildContext context) {
                    return SizedBox(
                      height: 400.h,
                      child: _bottomSheetParking(apiData: apiData, i: i),
                    );
                  },
                );
              },
              child: Image.asset(
                "assets/images/parking_here.png",
                height: 30.h,
              ),
            ),
            latLng: LatLng(lat, lng),
          ),
        );
      });
    }
  }

  addLineNoParking() async {
    // // mapController.
    // var line = await mapController?.addPolyline(
    //   const PolylineOptions(
    //       geometry: [
    //         LatLng(16.071737, 108.223574),
    //         LatLng(16.069522, 108.209806),
    //       ],
    //       polylineColor: Colors.red,
    //       polylineWidth: 14.0,
    //       polylineOpacity: 1,
    //       draggable: true),
    // );
    // Future.delayed(Duration(seconds: 3)).then((value) {
    //   if (line != null) {
    //     mapController?.updatePolyline(
    //       line,
    //       const PolylineOptions(
    //           geometry: [
    //             LatLng(16.071737, 108.223574),
    //             LatLng(16.069522, 108.209806),
    //           ],

    //           polylineColor: Colors.blue,
    //           polylineWidth: 14.0,
    //           polylineOpacity: 1,
    //           draggable: true),
    //     );
    //   }
    // });

    // VIETMAP PLUGIN
    Vietmap.routing(VietMapRoutingParams(points: [
      const LatLng(16.071737, 108.223574),
      const LatLng(16.069522, 108.209806),
    ]));
  }

  getCurrentPosion() {
    getUserLocation().then(
      (value) async {
        print(">>>>>>>>>>>>>> CURRENT: ${value.latitude} , ${value.longitude}");
        setState(() {
          CameraPosition cameraPosition = CameraPosition(
            target: LatLng(value.latitude, value.longitude),
            zoom: 14,
          );
          mapController
              ?.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        });
      },
    );
  }

  // GET RESULTS FROM API
  Future<void> getParkingAPI() async {
    try {
      final PlaceService apiService = PlaceService();
      apiData = await apiService.getStations();
    } catch (e) {
      print(">>>>>>>>>>>>>>>>>>>>>>>Error fetching data from the API: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            VietmapGL(
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              compassEnabled: false,
              trackCameraPosition: true,
              initialCameraPosition: cameraPosition!,
              // onStyleLoadedCallback: _onStyleLoadedCallback,
              // myLocationRenderMode: MyLocationRenderMode.GPS,
              // myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
              onMapRenderedCallback: () {
                mapController?.animateCamera(
                    CameraUpdate.newCameraPosition(cameraPosition!));
              },
              // onUserLocationUpdated: (location) {
              //   setState(() {
              //     userLocation = location;
              //   });
              // },
              styleString:
                  "https://maps.vietmap.vn/api/maps/light/styles.json?apikey=$VIETMAP_API_KEY",
              onMapClick: (point, coordinates) async {
                var data =
                    await mapController?.queryRenderedFeatures(point: point);
                log(data.toString());
              },
            ),
            mapController == null
                ? SizedBox.shrink()
                : MarkerLayer(
                    ignorePointer: false,
                    mapController: mapController!,
                    markers: myMarkers,
                  ),
          ],
        ),
        // LIST BUTTON (CURRENT POSITION, VỊ TRÍ GẦN ĐÂY, CẤM ĐẬU XE.)
        floatingActionButton: _listFloatActionButton(),
      ),
    );
  }

  Column _listFloatActionButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // SEARCH
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 10.w,
            ),
            SizedBox(
              height: 40,
              child: FloatingActionButton(
                onPressed: () {
                 showSearch(context: context, delegate: SearchParking());
                },
                child: Icon(
                  Icons.search,
                  color: ColorsConstants.kBackgroundColor,
                ),
                backgroundColor: ColorsConstants.kActiveColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h,),
        // Info
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 10.w,
            ),
            SizedBox(
              height: 40,
              child: FloatingActionButton(
                onPressed: () {
                  print("Click Button Info");
                },
                child: Icon(
                  Icons.info_outlined,
                  color: ColorsConstants.kBackgroundColor,
                ),
                backgroundColor: ColorsConstants.kActiveColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h,),
        Row(
          children: [
            SizedBox(
              width: 10.w,
            ),
            SizedBox(
              height: 40,
              child: FloatingActionButton(
                onPressed: () {
                  mapController?.recenter();
                  getCurrentPosion();
                },
                child: Icon(
                  Icons.location_searching,
                  color: ColorsConstants.kBackgroundColor,
                ),
                backgroundColor: ColorsConstants.kActiveColor,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // ĐỒ XE GẦN ĐÂY
                    SizedBox(
                      height: 30,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          reNewLocation();
                          addLocationParking();
                        },
                        label: Text(
                          "Bãi đổ xe gần đây",
                          style: TextStyle(color: ColorsConstants.kActiveColor),
                        ),
                        icon: Icon(
                          Icons.car_crash,
                          color: ColorsConstants.kActiveColor,
                          size: 20,
                        ),
                        backgroundColor: ColorsConstants.kBackgroundColor,
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    // CẤM ĐỔ XE
                    SizedBox(
                      height: 30,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          reNewLocation();
                          // addLineNoParking();
                        },
                        label: Text(
                          "Cấm đổ xe",
                          style: TextStyle(color: ColorsConstants.kActiveColor),
                        ),
                        icon: Icon(
                          Icons.car_crash,
                          color: ColorsConstants.kActiveColor,
                          size: 20,
                        ),
                        backgroundColor: ColorsConstants.kBackgroundColor,
                      ),
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    // NGẬP NƯỚC
                    // SizedBox(
                    //   height: 30,
                    //   child: FloatingActionButton.extended(
                    //     onPressed: () {},
                    //     label: Text(
                    //       "Ngậm nước",
                    //       style: TextStyle(color: ColorsConstants.kActiveColor),
                    //     ),
                    //     icon: Icon(
                    //       Icons.car_crash,
                    //       color: ColorsConstants.kActiveColor,
                    //       size: 20,
                    //     ),
                    //     backgroundColor: ColorsConstants.kBackgroundColor,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class _bottomSheetParking extends StatelessWidget {
  const _bottomSheetParking({
    super.key,
    required this.apiData,
    required this.i,
  });

  final List<Station> apiData;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400.h,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200.h,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(apiData[i].image.first),
                  fit: BoxFit.fitWidth,
                  filterQuality: FilterQuality.high,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
              child: Column(
                children: [
                  SizedBox(
                    child: Text(
                      apiData[i].name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  SizedBox(
                    child: Text(
                      apiData[i].address,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.sp),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ParkingItemScreen(
                            idParking: apiData[i]
                                .id
                                .toString(), // Truyền thông tin sản phẩm
                            name: apiData[i].name,
                            address: apiData[i].address,
                            image: apiData[i].image,
                            description: apiData[i].description,
                            lat: apiData[i].lat,
                            long: apiData[i].long,
                            slot: apiData[i].slot,
                            max: apiData[i].max,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary:
                          ColorsConstants.kActiveColor, // Sử dụng màu #567DF4
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize:
                          Size.fromHeight(40), // Điều chỉnh chiều cao ở đây
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Chi tiết",
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 6.w,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DirectionParking(
                            lat: apiData[i].lat,
                            lng: apiData[i].long,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      primary:
                          ColorsConstants.kActiveColor, // Sử dụng màu #567DF4
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize:
                          Size.fromHeight(40), // Điều chỉnh chiều cao ở đây
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.directions,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "Chỉ đường",
                          style:
                              TextStyle(color: Colors.white, fontSize: 16.sp),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
