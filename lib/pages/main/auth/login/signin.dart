import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:giuaki_map_location/constants/color_constants.dart';
import 'package:giuaki_map_location/pages/main/auth/login/signup.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignIn();
}

class _SignIn extends State<SignIn> {
  TextEditingController emailController = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  Future<void> login(String username, String password) async {
    try {
      http.Response response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        body: {'username': username, 'password': password},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print('Login successful');
        Get.offNamed('/main');
        saveUserData(username, password);
        // Handle the successful login response data here
      } else {
        print('Login failed: ${jsonDecode(response.body)['message']}');
        // Handle the failed login scenario here
      }
    } catch (e) {
      print('Error: $e');
    }
  }

// Lưu thông tin người dùng
  void saveUserData(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setString('password', password);
  }

  @override
  Widget build(BuildContext context) {
    double _deviceHeight = MediaQuery.sizeOf(context).height;
    double _deviceWidth = MediaQuery.sizeOf(context).width;
    return Material(
      child: Stack(
        children: [
          Container(
            height: _deviceHeight,
            width: _deviceWidth,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                ColorsConstants.kMainColor,
                ColorsConstants.kLineDirect,
              ]),
            ),
            child: _headerTitle(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 200),
            child: _contentForm(_deviceHeight, _deviceWidth),
          ),
        ],
      ),
    );
  }

  Container _contentForm(_deviceHeight, _deviceWidth) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Expanded(
        child: Padding(
          padding: EdgeInsets.only(
              top: _deviceWidth * 0.07,
              left: _deviceHeight * 0.06,
              right: _deviceHeight * 0.06),
          child: Column(
            children: [
              // GestureDetector(
              //   onTap: () {
              //     login(emailController.text.toString(),
              //         PasswordController.text.toString());
              //   },
              // ),
              // Gmail or username
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.check),
                  label: Text(
                    "Gmail",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorsConstants.kMainColor,
                    ),
                  ),
                ),
              ),
              TextField(
                controller: PasswordController,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.visibility_off),
                  label: Text(
                    "Password",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorsConstants.kMainColor,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: _deviceHeight * 0.1,
              ),

              Container(
                height: _deviceHeight * 0.07,
                width: _deviceWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  gradient: LinearGradient(
                    colors: [
                      ColorsConstants.kMainColor,
                      ColorsConstants.kLineDirect,
                    ],
                  ),
                ),
                child: Center(
                  child: TextButton(
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      await login('kminchelle', '0lelplR');
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                // height: _deviceHeight * 0.1,
                // width: _deviceWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have account?",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignUp(),
                                ),
                              );
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      // GestureDetector(
      //   onTap: () {
      //     login(emailController.text.toString(),
      //         PasswordController.text.toString());
      //   },
      // ),
    );
  }

  Expanded _headerTitle() {
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: 50,
              left: 30,
              right: 30,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hello\nSign In!",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                    letterSpacing: 2,
                  ),
                ),
                Icon(
                  Icons.linear_scale_sharp,
                  size: 35,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Row titleSignin(double _deviceWidth, double _deviceHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: _deviceWidth * 0.05, vertical: _deviceHeight),
          child: const Text(
            "Hello\nSign In!",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: _deviceWidth * 0.05, vertical: _deviceHeight * 0.07),
          child: Icon(
            Icons.format_list_bulleted_outlined,
            size: 35,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
