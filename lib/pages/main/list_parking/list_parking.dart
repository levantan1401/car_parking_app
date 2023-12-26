import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:giuaki_map_location/constants/color_constants.dart';
import 'package:giuaki_map_location/models/station.dart';
import 'package:giuaki_map_location/pages/main/list_parking/search_parking.dart';
import 'package:giuaki_map_location/pages/main/list_parking/widget/card_item_parking.dart';
import 'package:giuaki_map_location/services/place_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'detail_parking_screen.dart';

class ListParkingScreen extends StatelessWidget {
  int limitSubtitle = 65;

  final PlaceService apiService = PlaceService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Danh sách bãi đỗ xe'), // Tiêu đề của thanh điều hướng
        backgroundColor: ColorsConstants.kMainColor,
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchParking());
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: FutureBuilder(
        future: apiService.getStations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Station> stations = snapshot.data as List<Station>;
            print(stations);
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
      ),
    );
  }
}
