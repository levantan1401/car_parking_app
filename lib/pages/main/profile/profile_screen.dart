import 'package:flutter/material.dart';
import 'package:giuaki_map_location/constants/color_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConstants.kErorColor.shade200,
      body: Center(
        child: Text(
          "PROFILE",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
