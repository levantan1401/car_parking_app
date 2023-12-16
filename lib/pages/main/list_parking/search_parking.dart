import 'package:flutter/material.dart';
import 'package:giuaki_map_location/models/list_parking.dart';
import 'package:giuaki_map_location/pages/main/list_parking/detail_parking_screen.dart';
import 'package:giuaki_map_location/services/list_parking_services.dart';

class SearchParking extends SearchDelegate {
  int limitSubtitle = 65;

  final ListParkingService apiService = ListParkingService();
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
      future: apiService.getStations(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // List<Station> stations = snapshot.data as List<Station>;
          List<ListParkingModel> stations =
              snapshot.data as List<ListParkingModel>;
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
                      stations[index].image.first,
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
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text("Search Parking"),
    );
  }
}
