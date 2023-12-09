import 'package:giuaki_map_location/constants/api_google_key.dart';
import 'package:giuaki_map_location/models/list_parking.dart';
import 'package:giuaki_map_location/models/place.dart';
import 'package:giuaki_map_location/models/station.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ListParkingService{

  // final String apiUrl = "http://192.168.1.6/public/api/parkings";
  final String apiUrl = "https://654e49accbc325355742ae72.mockapi.io/api/test/parking_lot";
  // "https://654e49accbc325355742ae72.mockapi.io/api/test/locate_test";

  Future<List<ListParkingModel>> getStations() async {
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
      return stationsJson.map((station) => ListParkingModel.fromJson(station)).toList();
    } else {
      throw Exception('Failed to load stations');
    }
  }

  Future<List<ListParkingModel>> getDetailStation(int id) async {
    var response = await http.get(Uri.parse("$apiUrl$id"));
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['results'] as List;

    return jsonResult.map((place) => ListParkingModel.fromJson(place)).toList();
  }
}
