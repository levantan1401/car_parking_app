import 'package:giuaki_map_location/constants/api_google_key.dart';
import 'package:giuaki_map_location/models/place.dart';
import 'package:giuaki_map_location/models/station.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class PlaceService {
  final String apiUrl =
      "https://654e49accbc325355742ae72.mockapi.io/api/test/parking_lot";
  // "https://654e49accbc325355742ae72.mockapi.io/api/test/locate_test";

  var data = [];
  List<Station> results = [];

  Future<List<Place>> getPlace(double lat, double lng) async {
    var response = await http.get(Uri.parse(
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&type=parking&rankby=distance&key=$GOOGLE_API_KEY"));
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['results'] as List;

    return jsonResult.map((place) => Place.fromJson(place)).toList();
  }

  Future<List<Station>> getStations({String? query}) async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final contentType = response.headers['content-type'];
      final charsetMatch =
          RegExp(r'charset=([\w-]+)').firstMatch(contentType ?? '');

      // Lấy giá trị charset nếu có
      final charset = charsetMatch?.group(1) ?? 'utf-8';

      // Chuyển đổi dữ liệu với encoding đúng
      final decodedBody = convert.utf8.decode(response.bodyBytes);

      // Kiểm tra xem dữ liệu đã được giải mã đúng chưa
      print(decodedBody);

      Iterable stationsJson = convert.jsonDecode(decodedBody);
      results =
          stationsJson.map((station) => Station.fromJson(station)).toList();
      if (query != null) {
        results = results
            .where((element) =>
                element.address.toLowerCase().contains(query.toLowerCase()))
            .toList();

        print(results);
      } else {
        print("API ERROR");
      }
    } else {
      throw Exception('Failed to load stations');
    }

    return results;
  }

  Future<List<Station>> getDetailStation(int id) async {
    var response = await http.get(Uri.parse("$apiUrl$id"));
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['results'] as List;

    return jsonResult.map((place) => Station.fromJson(place)).toList();
  }
}
