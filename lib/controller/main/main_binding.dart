import 'package:get/get.dart';
import 'package:giuaki_map_location/controller/main/main_controller.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
  }
}
