import 'package:giuaki_map_location/models/geometry.dart';

class Place {
  final String name;
  final String vicinity;
  final Geometry geometry;

  Place(
      {
      required this.geometry,
      required this.name,
      required this.vicinity,
      });

  Place.fromJson(Map<dynamic, dynamic> parsedJson)
      : name = parsedJson['name'],
        vicinity = parsedJson['vicinity'],
        geometry = Geometry.fromJson(parsedJson['geometry']);


}
