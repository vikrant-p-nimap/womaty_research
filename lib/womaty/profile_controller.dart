import 'package:get/get.dart';

class ProfileController extends GetxController {
  int profile = 1;

  @override
  void onInit() {
    super.onInit();
    profile = 5;
    print("init profilepage");
  }
}