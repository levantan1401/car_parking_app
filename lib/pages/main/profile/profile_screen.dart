// ignore_for_file: prefer_const_constructors
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ProfileScreen extends StatelessWidget {
  final String tName; // Declare the parameter as final
  final String tMail;

  const ProfileScreen({
    Key? key,
    this.tName = 'Tấn',
    this.tMail = 'tan@gmail.com',
  }) : super(key: key);
// Lấy thông tin người dùng
  Future<String> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    String password = prefs.getString('password') ?? '';

    return "$username,  $password";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            // Add functionality to navigate or perform an action
          },
          icon: const Icon(
            LineAwesomeIcons.angle_left,
            color: Colors.black,
          ),
        ),
        title: Padding(
          padding: EdgeInsets.only(left: 100.0),
          child: Text(
            'Profile', // Use the tName property here
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),

      // end
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(
                          image: AssetImage('assets/images/tan.png')),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.blue),
                      child: const Icon(
                        LineAwesomeIcons.alternate_pencil,
                        color: Colors.black,
                        size: 25,
                      ),
                    ),
                  )
                ],
              ),
              // name , maill
              const SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(bottom: 10),
                child: Text(
                  tName,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                child: Text(
                  tMail,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    print('text');
                    Get.toNamed('/EditProfile');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    shape: StadiumBorder(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Text(
                      'Edit Profile',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                          height: 0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              //menu

              // const SizedBox(height: 10),
              ProfileMenuWidget(
                title: "History",
                icon: LineAwesomeIcons.history,
                onPress: () {},
              ),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: "Settings",
                icon: LineAwesomeIcons.cog,
                onPress: () {},
              ),
              const SizedBox(height: 10),
              ProfileMenuWidget(
                title: "Information",
                icon: LineAwesomeIcons.info,
                onPress: () {
                  // Add logic to display information about the Car Parking app
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Car Parking App Information'),
                        content: Container(
                          height: 300,
                          width: 600,
                          child: Column(
                            children: [
                              Container(
                                child: FutureBuilder<String>(
                                  future: getUserData(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      // If the Future is still running, return a loading indicator or placeholder
                                      return CircularProgressIndicator(); // You can replace this with any loading widget.
                                    } else if (snapshot.hasError) {
                                      // If the Future throws an error, display the error message
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      // If the Future is complete, use the result in the Text widget
                                      return Text(snapshot.data ??
                                          'No user data available');
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
    required this.onPress,
    this.endIcon = true,
    this.textColor,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPress,
      leading: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.blueAccent.withOpacity(0.1)),
          child: Icon(
            icon,
            color: Colors.blue,
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      trailing: Padding(
        padding: const EdgeInsets.only(right: 30),
        child: endIcon
            ? Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey.withOpacity(0.1)),
                child: const Icon(
                  LineAwesomeIcons.angle_right,
                  color: Colors.blue,
                ),
              )
            : null,
      ),
    );
  }
}
