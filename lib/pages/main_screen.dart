import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:giuaki_map_location/constants/color_constants.dart';
import 'package:giuaki_map_location/controller/main/main_controller.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});

  final MainController _mainController = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 1,
        notchMargin: 10,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
          child: Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _bottomAppBarItem(
                      icon: _mainController.currentPage == 0
                          ? Icons.home
                          : Icons.home_outlined,
                      page: 0),
                  _bottomAppBarItem(
                      icon: _mainController.currentPage == 1
                          ? Image.asset(
                              'assets/images/parking_car_icon.png', // Path to your PNG asset
                              width: 24,
                              height: 24,
                            )
                          : Image.asset(
                              'assets/images/parking_car_icon.png', // Path to your PNG asset
                              width: 24,
                              height: 24,
                            ),
                      page: 1),
                  _bottomAppBarItem(
                      icon: _mainController.currentPage == 2
                          ? Icons.person
                          : Icons.person_outline_outlined,
                      page: 2),
                ],
              )),
        ),
      ),
      body: PageView(
        controller: _mainController.pageController,
        children: [..._mainController.pages],
      ),
    );
  }

  Widget _bottomAppBarItem({icon, page}) {
    return ZoomTapAnimation(
      onTap: () => _mainController.goToTab(page),
      child: icon is IconData
          ? Icon(
              icon,
              color: _mainController.currentPage == page
                  ? ColorsConstants.kActiveColor
                  : Colors.grey,
              size: 30,
            )
          : icon, // If it's an image, just return it
    );
  }
}
