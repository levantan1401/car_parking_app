import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  final getStore = GetStorage();
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    if (getStore.read('isOnboardingComplete') == null) {
      Future.delayed(const Duration(seconds: 1), () {
        Get.offAllNamed('/onboarding');
      });
    // }
    //  else if (getStore.read('userId') == null){
    //   Future.delayed(const Duration(seconds: 1), () {
    //     Get.offAllNamed('/login');
    //   });
    }else{
      Future.delayed(const Duration(seconds: 1), () {
        Get.offAllNamed('/main');
      });
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
