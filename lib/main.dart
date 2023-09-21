import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:giuaki_map_location/models/place.dart';
// import 'package:giuaki_map_location/pages/home_page.dart';
import 'package:giuaki_map_location/pages/search.dart';
import 'package:giuaki_map_location/services/geolocator_service.dart';
import 'package:giuaki_map_location/services/place_service.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // runApp(const MyApp(homeScreen: HomePage(),));
  runApp(MyApp());
}

// class MyApp extends StatefulWidget {
//   final Widget? homeScreen;
//   const MyApp({Key? key, this.homeScreen}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   // This widget is the root of your application.
//   final locatorService = GeoLocatorService();
//   @override
//   Widget build(BuildContext context) {
//     return FutureProvider(
//       create: (context) => locatorService.getLocation(),
//       initialData: 1,
//       builder: (context, child) {
//         return HomePage();
//       },
//     );
//   }
// }

class MyApp extends StatelessWidget {
  final locatorService = GeoLocatorService();

  final placesService = PlaceService();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider(
          create: (context) => locatorService.getLocation(),
          initialData: null,
        ),
        ProxyProvider<Position, Future<List<Place>>?>(
          update: (context, position, places) {
            return (position != null)
                ? placesService.getPlace(position.latitude, position.longitude)
                : null;
          },
        ),
      ],
      child: const MaterialApp(
        title: "Parking App",
        home: Search(),
      ),
    );
  }
}
