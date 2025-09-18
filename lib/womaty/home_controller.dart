import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';

class HomeController extends GetxController {
  int home = 1;

  @override
  void onInit() {
    super.onInit();
    home = 4;
    print("init homepage");
  }


  void increment() {
    home += 1;
    update();
  }



}