import 'package:get/get.dart';
import 'package:giuaki_map_location/controller/home/homepage_controller.dart';

class HomepageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomepageController());
  }
}
