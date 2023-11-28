import 'package:flutter/material.dart';
import 'package:giuaki_map_location/constants/api_google_key.dart';
import 'package:vietmap_flutter_gl/vietmap_flutter_gl.dart';

class MapDemo extends StatefulWidget {
  const MapDemo({super.key});

  @override
  State<MapDemo> createState() => _MapDemoState();
}

class _MapDemoState extends State<MapDemo> {
  VietmapController? mapController;
  var isLight = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // needs different dark and light styles in this repo
        // floatingActionButton: Padding(
        // padding: const EdgeInsets.all(32.0),
        // child: FloatingActionButton(
        // child: Icon(Icons.swap_horiz),
        // onPressed: () => setState(
        // () => isLight = !isLight,
        // ),
        // ),
        // ),
        body: VietmapGL(
      onMapCreated: _onMapCreated,
      initialCameraPosition: const CameraPosition(target: LatLng(0.0, 0.0)),
      onStyleLoadedCallback: _onStyleLoadedCallback,
      myLocationRenderMode: MyLocationRenderMode.GPS,
      myLocationTrackingMode: MyLocationTrackingMode.TrackingGPS,
      onUserLocationUpdated: (location) {
        print(location.latitude);
      },
      styleString:
          "https://maps.vietmap.vn/api/maps/light/styles.json?apikey=$VIETMAP_API_KEY",
    ));
  }
}
