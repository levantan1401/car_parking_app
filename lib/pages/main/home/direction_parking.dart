import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:giuaki_map_location/constants/api_google_key.dart';
import 'package:giuaki_map_location/constants/color_constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class DirectionParking extends StatefulWidget {
  final String idParking;
  final double lat;
  final double long;

  const DirectionParking({
    super.key,
    required this.idParking,
    required this.lat,
    required this.long,

  });


  @override
  State<DirectionParking> createState() => _DirectionParkingState();
}

class _DirectionParkingState extends State<DirectionParking> {
  static const LatLng beginLocation = LatLng(15.974079, 108.252202);
  // static const LatLng endLocation = LatLng(widget., 108.253658);

  List<LatLng> polylineCooridinates = [];
  LocationData? _currentLocation;

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_API_KEY,
      PointLatLng(beginLocation.latitude, beginLocation.longitude),
      PointLatLng(widget.lat, widget.long),
      // travelMode: TravelMode.driving,
      // wayPoints: [
      //   PolylineWayPoint(location: "Garage A"),
      // ],
    );

    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCooridinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  @override
  void initState() {
    // getCurrentLocation();
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConstants.kActiveColor,
        centerTitle: true,
        title: Text(
          "Chỉ đường".toUpperCase(),
          style: TextStyle(color: Colors.white, fontSize: 16.sp),
        ),
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: beginLocation,
          zoom: 14.5,
        ),
        polylines: {
          Polyline(
            polylineId: PolylineId("route"),
            points: polylineCooridinates,
            color: ColorsConstants.kActiveColor,
            width: 4,
          )
        },
        markers: {
          const Marker(
            markerId: MarkerId("begin"),
            position: beginLocation,
          ),
          Marker(
            markerId: const MarkerId("end"),
            position: LatLng(widget.lat, widget.long),
          ),
        },
        // onMapCreated: (GoogleMapController controller) {
        //   _controller.complete(controller);
        // },
      ),
    );
  }
}