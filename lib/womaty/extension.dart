import 'package:get/get.dart';

extension Validator on String {
  bool containsPhoneNoOrEmail() {
    if (isNotEmpty) {
      final words = split(" ");
      for (var word in words) {
        if (word.isEmail || word.isPhoneNumber) {
          return true;
        }
      }
    }
    return false;
  }
}
