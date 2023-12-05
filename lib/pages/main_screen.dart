import 'package:diamond_bottom_bar/diamond_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:giuaki_map_location/constants/color_constants.dart';
import 'package:giuaki_map_location/controller/main/main_controller.dart';
import 'package:giuaki_map_location/pages/main/home/home_page.dart';
import 'package:giuaki_map_location/pages/main/home/map_demo.dart';
import 'package:giuaki_map_location/pages/main/home/map_home.dart';
import 'package:giuaki_map_location/pages/main/list_parking/list_parking.dart';
import 'package:giuaki_map_location/pages/main/profile/profile_screen.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class MainScreen extends StatefulWidget {
  MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainController _mainController = Get.find<MainController>();
  int _selectedIndex = 1;
  late Widget _selectedWidget;

  @override
  void initState() {
    _selectedWidget = const MapHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedWidget,
      bottomNavigationBar: DiamondBottomNavigation(
        itemIcons: const [
          Icons.local_parking,
          Icons.person,
        ],
        centerIcon: Icons.place,
        selectedIndex: _selectedIndex,
        onItemPressed: onPressed,
      ),
    );
  }

  void onPressed(index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        _selectedWidget = ListParkingScreen();
      } else if (index == 1) {
        _selectedWidget = const MapHome();
      } else if (index == 2) {
        _selectedWidget = VietMapNavigationScreen();
      }
    });
  }
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     bottomNavigationBar: BottomAppBar(
  //       elevation: 1,
  //       notchMargin: 10,
  //       child: Container(
  //         padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
  //         child: Obx(() => Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 _bottomAppBarItem(
  //                     icon: _mainController.currentPage == 0
  //                         ? Icons.home
  //                         : Icons.home_outlined,
  //                     page: 0),
  //                 _bottomAppBarItem(
  //                     icon: _mainController.currentPage == 1
  //                         ? Image.asset(
  //                             'assets/images/parking_car_icon.png', // Path to your PNG asset
  //                             width: 24,
  //                             height: 24,
  //                           )
  //                         : Image.asset(
  //                             'assets/images/parking_car_icon.png', // Path to your PNG asset
  //                             width: 24,
  //                             height: 24,
  //                           ),
  //                     page: 1),
  //                 _bottomAppBarItem(
  //                     icon: _mainController.currentPage == 2
  //                         ? Icons.person
  //                         : Icons.person_outline_outlined,
  //                     page: 2),
  //               ],
  //             )),
  //       ),
  //     ),
  //     body: PageView(
  //       controller: _mainController.pageController,
  //       children: [..._mainController.pages],
  //       physics: NeverScrollableScrollPhysics(),
  //     ),
  //   );
  // }

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
