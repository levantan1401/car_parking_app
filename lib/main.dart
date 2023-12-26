import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import 'package:giuaki_map_location/models/place.dart';
import 'package:giuaki_map_location/pages/main/home/home_page.dart';
import 'package:giuaki_map_location/pages/main_screen.dart';
import 'package:giuaki_map_location/pages/onboarding/onboarding_screen.dart';
import 'package:giuaki_map_location/pages/search.dart';
import 'package:giuaki_map_location/pages/splash/splash_screen.dart';
import 'package:giuaki_map_location/services/geolocator_service.dart';
import 'package:giuaki_map_location/services/place_service.dart';

//NEWS
import 'router/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  final locatorService = GeoLocatorService();

  final placesService = PlaceService();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'CarParking',
          getPages: Routers.routers,
          initialRoute: Routers.INITIAL,
          // initialBinding: AppBinding(),
        );
      },
    );
  }
}
