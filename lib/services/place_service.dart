import 'package:giuaki_map_location/models/place.dart';
import 'package:giuaki_map_location/models/station.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
class PlaceService {
  final String apiUrl = "https://654e49accbc325355742ae72.mockapi.io/api/test/located";
  final key = "AIzaSyCvMdGzQ5D9N-pO3kiNBZTziiPu1Uclb_I";

  Future<List<Place>> getPlace(double lat, double lng) async {
    
    var response = await http.get(Uri.parse("https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&type=parking&rankby=distance&key=$key"));
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['results'] as List;

    return jsonResult.map((place) => Place.fromJson(place)).toList();
  }

Future<List<Station>> getStations() async {
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final contentType = response.headers['content-type'];
    final charsetMatch = RegExp(r'charset=([\w-]+)').firstMatch(contentType ?? '');

    // Lấy giá trị charset nếu có
    final charset = charsetMatch?.group(1) ?? 'utf-8';

    // Chuyển đổi dữ liệu với encoding đúng
    final decodedBody = convert.utf8.decode(response.bodyBytes);

    // Kiểm tra xem dữ liệu đã được giải mã đúng chưa
    print(decodedBody);

    Iterable stationsJson = convert.jsonDecode(decodedBody);
    return stationsJson.map((station) => Station.fromJson(station)).toList();
  } else {
    throw Exception('Failed to load stations');
  }
}

}