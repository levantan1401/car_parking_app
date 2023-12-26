import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:giuaki_map_location/constants/color_constants.dart';
import 'package:giuaki_map_location/models/station.dart';
import 'package:giuaki_map_location/pages/main/list_parking/detail_parking_screen.dart';
import 'package:giuaki_map_location/pages/main/list_parking/widget/card_item_parking.dart';
import 'package:giuaki_map_location/services/place_service.dart';

class SearchParking extends SearchDelegate {
  int limitSubtitle = 65;

  final PlaceService apiService = PlaceService();
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: Icon(Icons.arrow_back_ios),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // CARD
    return FutureBuilder(
      future: apiService.getStations(query: query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // List<Station> stations = snapshot.data as List<Station>;
          List<Station> stations = snapshot.data as List<Station>;
          return ListView.builder(
            itemCount: stations.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  print("Click " + stations[index].name);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ParkingItemScreen(
                        idParking: stations[index]
                            .id
                            .toString(), // Truyền thông tin sản phẩm
                        name: stations[index].name,
                        address: stations[index].address,
                        description: stations[index].description,
                        image: stations[index].image,
                        lat: stations[index].lat,
                        long: stations[index].long,
                        slot: stations[index].slot,
                        max: stations[index].max, 
                      ),
                    ),
                  );
                },
                child: CardItemWidget(stations: stations, limitSubtitle: limitSubtitle, index: index),
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text("Search Parking", style: TextStyle(
        fontSize: 30, 
        color: ColorsConstants.kActiveColor,
        fontWeight: FontWeight.bold
      ),),
    );
  } 
}


