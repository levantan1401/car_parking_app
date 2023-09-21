import 'package:giuaki_map_location/models/place.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
class PlaceService {

  final key = "AIzaSyDesN9h5qS6RCmNVeipHaNi-KgQQQLYz3Q";

  Future<List<Place>> getPlace(double lat, double lng) async {
    
    var response = await http.get(Uri.parse("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&type=parking&rankby=distance&key=$key"));
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['results'] as List;

    return jsonResult.map((place) => Place.fromJson(place)).toList();
  }

}