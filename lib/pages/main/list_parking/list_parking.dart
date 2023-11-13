import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:giuaki_map_location/constants/color_constants.dart';
import 'package:giuaki_map_location/models/station.dart';
import 'package:giuaki_map_location/services/place_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'detail_parking_screen.dart';

class ListParkingScreen extends StatelessWidget {
  // const ListParkingScreen({super.key});
  int limitSubtitle = 65;

  final PlaceService apiService = PlaceService();
  final List<Station> station = [];

  // @override
  // Widget build(BuildContext context) {
  //   return const Scaffold(
  //     backgroundColor: ColorsConstants.kMainColor,
  //     body: SafeArea(
  //       child: Center(
  //           child: Text(
  //         "LIST PARKING",
  //         style: TextStyle(color: Colors.white),
  //       )),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Danh sách bãi đỗ xe'), // Tiêu đề của thanh điều hướng
          backgroundColor: ColorsConstants.kMainColor,
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
                  return Card(
                    child: ListTile(
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
                              image: stations[index].image,
                              lat: stations[index].lat,
                              long: stations[index].long,
                            ),
                          ),
                        );
                      },
                      title: Text(
                        stations[index].name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        (stations[index].address.length > limitSubtitle)
                            ? '${stations[index].address.substring(0, limitSubtitle)}...'
                            : stations[index].address,
                        style: const TextStyle(fontSize: 14),
                      ),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(7.0),
                        child: Image.network(
                          stations[index].image,
                          width: 90,
                          height: 170,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}
