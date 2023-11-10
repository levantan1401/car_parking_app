import 'package:flutter/material.dart';
import 'package:giuaki_map_location/constants/color_constants.dart';

class ListParkingScreen extends StatelessWidget {
  const ListParkingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConstants.kMainColor,
      body: SafeArea(
        child: Center(
            child: Text(
          "LIST PARKING",
          style: TextStyle(color: Colors.white),
        )),
      ),
    );
  }
}
