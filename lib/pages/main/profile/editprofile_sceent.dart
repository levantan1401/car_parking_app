import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Get.toNamed('/profile');
          },
          icon: const Icon(
            LineAwesomeIcons.angle_left,
            color: Colors.black,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 60.0),
          child: Text(
            'Edit Profile', // Use the tName property here
            style: TextStyle(
              color: Colors.black,
              fontSize: 25,
            ),
            textAlign: TextAlign.left,
          ),
        ),
      ),

      //end

      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(7.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Stack(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                          'assets/images/tan.png'), // Use Image.asset to load images from assets
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
                        LineAwesomeIcons.camera,
                        color: Colors.black,
                        size: 25,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: TTextFormFieldTheme.lightInputTheme.copyWith(
                        labelText: 'Lê Văn Tấn',
                        prefixIcon: Icon(LineAwesomeIcons.user),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: TTextFormFieldTheme.lightInputTheme.copyWith(
                        labelText: 'lvtan.20it1@vku.udn.vn',
                        prefixIcon: Icon(LineAwesomeIcons.envelope),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: TTextFormFieldTheme.lightInputTheme.copyWith(
                        labelText: '0946234470',
                        prefixIcon: Icon(LineAwesomeIcons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: TTextFormFieldTheme.lightInputTheme.copyWith(
                        labelText: '*********',
                        prefixIcon: Icon(
                          LineAwesomeIcons.lock,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 300,
                      child: SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              print('đã vào');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              side: BorderSide.none,
                              shape: const StadiumBorder(),
                            ),
                            child: const Text('Edit Profile')),
                      ),
                    )
                  ],
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TTextFormFieldTheme {
  TTextFormFieldTheme._();

  static InputDecoration lightInputTheme = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
    ),
    prefixIconColor: Colors.black,
    floatingLabelStyle: TextStyle(color: Colors.black),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: const BorderSide(width: 2, color: Colors.black),
    ),
  );
}
