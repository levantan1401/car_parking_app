import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:giuaki_map_location/controller/home/homepage_binding.dart';
import 'package:giuaki_map_location/controller/main/main_binding.dart';
import 'package:giuaki_map_location/controller/onboarding/onboarding_binding.dart';
import 'package:giuaki_map_location/controller/splash/splash_binding.dart';
import 'package:giuaki_map_location/pages/main/home/home_page.dart';
import 'package:giuaki_map_location/pages/main/list_parking/list_parking.dart';
import 'package:giuaki_map_location/pages/main/profile/profile_screen.dart';
import 'package:giuaki_map_location/pages/main_screen.dart';
import 'package:giuaki_map_location/pages/onboarding/onboarding_screen.dart';
import 'package:giuaki_map_location/pages/splash/splash_screen.dart';

class Routers {
  static const INITIAL = '/splash';

  static final routers = [
    GetPage(
      name: '/splash',
      page: () => SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: '/onboarding',
      page: () => OnboardingScreen(),
      binding: OnboardingBinding(),
    ),
    // GetPage(
    //   name: '/main',
    //   page: () => HomePage(),
    //   binding: HomepageBinding(),
    // ),
    GetPage(
        name: '/main',
        page: () => MainScreen(),
        binding: MainBinding(),
        children: [
          GetPage(
            name: '/home',
            page: () => HomePage(),
          ),
          GetPage(
            name: '/list_parking',
            page: () => ListParkingScreen(),
          ),
          GetPage(
            name: '/profile',
            page: () => ProfileScreen(),
          ),
        ]),
  ];
}
