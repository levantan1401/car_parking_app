import 'package:geolocator/geolocator.dart';

class GeoLocatorService {
  
  Future<Position> getLocation() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();

    if(permission == LocationPermission.denied){
      print("denied");
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
  }
}