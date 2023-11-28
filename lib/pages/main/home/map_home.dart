import 'dart:typed_data';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:giuaki_map_location/constants/api_google_key.dart';
import 'package:giuaki_map_location/constants/color_constants.dart';
import 'package:giuaki_map_location/models/station.dart';
import 'package:giuaki_map_location/pages/main/home/direction_parking.dart';
import 'package:giuaki_map_location/pages/main/list_parking/detail_parking_screen.dart';
import 'package:giuaki_map_location/services/place_service.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';
import 'package:location/location.dart';

class MapHome extends StatefulWidget {
  const MapHome({super.key});

  @override
  State<MapHome> createState() => _MapHomeState();
}

class _MapHomeState extends State<MapHome> {
  VietmapController? mapController;
  UserLocation? _userLocation;
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();
  final List<Marker> myMarkers = [];
  var isLight = true;

  @override
  void initState() {
    super.initState();
    getParkingAPI();
  }

  _onMapCreated(VietmapController controller) {
    mapController = controller;
  }

  _onStyleLoadedCallback() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Style loaded :)"),
      backgroundColor: Theme.of(context).primaryColor,
      duration: Duration(seconds: 1),
    ));
  }

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

  getCurrentPosion() {
    getUserLocation().then(
      (value) async {
        myMarkers.add(
          StaticMarker(
            // alignment: Alignment.bottomCenter,
            width: 100,
            height: 100,
            child: SizedBox(
              width: 100,
              height: 100,
              child: _markerWidget(Icons.location_on),
            ),
            latLng: LatLng(value.latitude, value.longitude), bearing: 0,
          ),
        );
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
      List<Station> apiData = await apiService.getStations();
      for (int i = 0; i < apiData.length; i++) {
        print(">>>>>>>>>>>>>> Station NEW:  ${apiData[i].lat}");
        print(">>>>>>>>>>>>STATION: ${apiData}");
        myMarkers.add(
          Marker(
            latLng: LatLng(apiData[i].lat, apiData[i].long),
            // child: Image.asset(
            //   "assets/images/parking_here.png",
            //   height: 50.h,
            // ),
            child: GestureDetector(
              child: Image.asset(
                "assets/images/parking_here.png",
                height: 50.h,
              ),
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
                                              .id
                                              .toString(), // Truyền thông tin sản phẩm
                                          name: apiData[i].name,
                                          address: apiData[i].address,
                                          image: apiData[i].image,
                                          lat: apiData[i].lat,
                                          long: apiData[i].long,
                                          slot: apiData[i].slot,
                                          max: apiData[i].max,
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
                                      "Chi tiết",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DirectionParking(
                                          idParking: apiData[i]
                                              .id
                                              .toString(), // Truyền thông tin sản phẩm
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
                  // ĐANG LỖI CHỖ NÀY NHÉ
                  LatLng(apiData[i].lat, apiData[i].long),
                );
              },
            ),

            // onTap: () {
            //   _customInfoWindowController.addInfoWindow!(
            //     Container(
            //       height: 200.h,
            //       width: 200.w,
            //       decoration: BoxDecoration(
            //         color: Colors.white,
            //         border: Border.all(color: ColorsConstants.kActiveColor),
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //       child: SingleChildScrollView(
            //         child: Column(
            //           children: [
            //             Container(
            //               width: 300.w,
            //               height: 120.h,
            //               decoration: BoxDecoration(
            //                 image: DecorationImage(
            //                   image: NetworkImage(apiData[i].image),
            //                   fit: BoxFit.fitWidth,
            //                   filterQuality: FilterQuality.high,
            //                 ),
            //                 borderRadius: BorderRadius.all(
            //                   Radius.circular(10.0),
            //                 ),
            //               ),
            //             ),
            //             Padding(
            //               padding: EdgeInsets.all(10.sp),
            //               child: Row(
            //                 children: [
            //                   SizedBox(
            //                     width: 150.w,
            //                     child: Text(
            //                       apiData[i].name,
            //                       maxLines: 2,
            //                       overflow: TextOverflow.ellipsis,
            //                       style: TextStyle(
            //                           fontSize: 14.sp, color: Colors.black),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //             Padding(
            //               padding: EdgeInsets.all(10.sp),
            //               child: Row(
            //                 children: [
            //                   GestureDetector(
            //                     onTap: () {
            //                       Navigator.push(
            //                         context,
            //                         MaterialPageRoute(
            //                           builder: (context) => ParkingItemScreen(
            //                             idParking: apiData[i]
            //                                 .id
            //                                 .toString(), // Truyền thông tin sản phẩm
            //                             name: apiData[i].name,
            //                             address: apiData[i].address,
            //                             image: apiData[i].image,
            //                             lat: apiData[i].lat,
            //                             long: apiData[i].long,
            //                             slot: apiData[i].slot,
            //                             max: apiData[i].max,
            //                           ),
            //                         ),
            //                       );
            //                     },
            //                     child: Container(
            //                       padding: EdgeInsets.symmetric(
            //                           horizontal: 12.w, vertical: 8.h),
            //                       decoration: BoxDecoration(
            //                         color: Colors.blue,
            //                         borderRadius: BorderRadius.circular(5),
            //                       ),
            //                       child: Text(
            //                         "Chi tiết",
            //                         style: TextStyle(color: Colors.white),
            //                       ),
            //                     ),
            //                   ),
            //                   SizedBox(
            //                     width: 10.w,
            //                   ),
            //                   GestureDetector(
            //                     onTap: () {
            //                       Navigator.push(
            //                         context,
            //                         MaterialPageRoute(
            //                           builder: (context) => DirectionParking(
            //                             idParking: apiData[i]
            //                                 .id
            //                                 .toString(), // Truyền thông tin sản phẩm
            //                             lat: apiData[i].lat,
            //                             long: apiData[i].long,
            //                           ),
            //                         ),
            //                       );
            //                     },
            //                     child: Container(
            //                       padding: EdgeInsets.symmetric(
            //                           horizontal: 12.w, vertical: 8.h),
            //                       decoration: BoxDecoration(
            //                         color: Colors.blue,
            //                         borderRadius: BorderRadius.circular(5),
            //                       ),
            //                       child: Text(
            //                         "Chỉ đường",
            //                         style: TextStyle(color: Colors.white),
            //                       ),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //     LatLng(apiData[i].lat, apiData[i].long),
            //   );
            // },
          ),
        );
        setState(() {});
      }
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
              initialCameraPosition: const CameraPosition(
                  target: LatLng(15.975295, 108.252345), zoom: 10),
              onStyleLoadedCallback: _onStyleLoadedCallback,
              myLocationRenderMode: MyLocationRenderMode.GPS,
              myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
              onMapRenderedCallback: () {
                mapController?.animateCamera(CameraUpdate.newCameraPosition(
                    CameraPosition(
                        target: LatLng(15.975295, 108.252345),
                        zoom: 10,
                        tilt: 60)));
              },
              // onUserLocationUpdated: (location) {
              //   print(location);
              // },
              styleString:
                  "https://maps.vietmap.vn/api/maps/light/styles.json?apikey=$VIETMAP_API_KEY",
            ),
            mapController == null
                ? SizedBox.shrink()
                : MarkerLayer(
                    ignorePointer: false,
                    mapController: mapController!,
                    markers: myMarkers,

                    //  [
                    //     Marker(
                    //       width: 50,
                    //       height: 50,
                    //       child: GestureDetector(
                    //         onTap: () {
                    //           print("CLICK");
                    //         },
                    //         child: Image.asset(
                    //           "assets/images/target.png",
                    //           height: 50.h,
                    //         ),
                    //       ),
                    //       latLng: LatLng(15.975295, 108.252345),
                    //     ),
                    //   ]
                  ),
          ],
        ),
        // LIST BUTTON (CURRENT POSITION, VỊ TRÍ GẦN ĐÂY, CẤM ĐẬU XE.)
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SizedBox(
                          height: 40,
                          child: FloatingActionButton.extended(
                            onPressed: () {},
                            label: Text(
                              "Cấm đổ xe",
                              style: TextStyle(
                                  color: ColorsConstants.kActiveColor),
                            ),
                            icon: Icon(
                              Icons.car_crash,
                              color: ColorsConstants.kActiveColor,
                            ),
                            backgroundColor: ColorsConstants.kBackgroundColor,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        SizedBox(
                          height: 40,
                          child: FloatingActionButton.extended(
                            onPressed: () {},
                            label: Text(
                              "Ngậm nước",
                              style: TextStyle(
                                  color: ColorsConstants.kActiveColor),
                            ),
                            icon: Icon(
                              Icons.car_crash,
                              color: ColorsConstants.kActiveColor,
                            ),
                            backgroundColor: ColorsConstants.kBackgroundColor,
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        SizedBox(
                          height: 40,
                          child: FloatingActionButton.extended(
                            onPressed: () {
                              getParkingAPI();
                            },
                            label: Text(
                              "Bãi đổ xe gần đây",
                              style: TextStyle(
                                  color: ColorsConstants.kActiveColor),
                            ),
                            icon: Icon(
                              Icons.car_crash,
                              color: ColorsConstants.kActiveColor,
                            ),
                            backgroundColor: ColorsConstants.kBackgroundColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 2.w,
                ),
                SizedBox(
                  height: 40,
                  child: FloatingActionButton(
                    onPressed: () {
                      getCurrentPosion();
                    },
                    child: Icon(
                      Icons.location_searching,
                      color: ColorsConstants.kActiveColor,
                    ),
                    backgroundColor: ColorsConstants.kBackgroundColor,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
