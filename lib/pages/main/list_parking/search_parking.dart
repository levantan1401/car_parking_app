import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:giuaki_map_location/constants/color_constants.dart';
import 'package:giuaki_map_location/models/station.dart';
import 'package:giuaki_map_location/pages/main/list_parking/detail_parking_screen.dart';
import 'package:giuaki_map_location/services/list_parking_services.dart';
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
                child: Card(
                  elevation: 3.0,
                  margin: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left side - Image
                      Container(
                        width: 150.0.w,
                        padding: EdgeInsets.all(8.0.sp),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7.0),
                          child: Image.network(
                            stations[index].image.first,
                            height: 100.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      // Right side - Information
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: 10.0.sp, top: 10.sp, bottom: 4.sp),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                stations[index].name,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                (stations[index].address.length > limitSubtitle)
                                    ? '${stations[index].address.substring(0, limitSubtitle)}...'
                                    : stations[index].address,
                                style: const TextStyle(fontSize: 14.0),
                              ),
                              SizedBox(height: 8.0),
                              RichText(
                                text: TextSpan(
                                    text: "Số vị trí trống:",
                                    style: TextStyle(
                                      color: ColorsConstants.kActiveColor,
                                      fontSize: 14,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: stations[index].slot.toString(),
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold))
                                    ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
