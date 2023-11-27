import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giuaki_map_location/pages/main/home/demo_apivietmap.dart';
import 'package:giuaki_map_location/pages/main/home/home_page.dart';
import 'package:giuaki_map_location/pages/main/list_parking/list_parking.dart';
import 'package:giuaki_map_location/pages/main/profile/profile_screen.dart';

class MainController extends GetxController {
  MainController();
  late PageController pageController;
  late CarouselController carouselController;

  var currentPage = 0.obs;
  var currentBanner = 0.obs;

  List<Widget> pages = [
    // HomePage(),
    DemoApiVietmap(),
    ListParkingScreen(),
    ProfileScreen(),
  ];

  @override
  void onInit() {
    pageController = PageController(initialPage: 0);
    carouselController = CarouselController();

    super.onInit();
  }

  void goToTab(int page) {
    currentPage.value = page;
    pageController.jumpToPage(page);
  }

  void changeBanner(int index) {
    currentBanner.value = index;
  }

  @override
  void dispose() {
    pageController.dispose();

    super.dispose();
  }
}
