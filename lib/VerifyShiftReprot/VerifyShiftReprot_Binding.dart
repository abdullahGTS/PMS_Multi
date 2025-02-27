import 'package:get/get.dart';

import 'VerifyShiftReprot_Controller.dart';


class VerifyShiftReprotBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyShiftReprotController>(
        () => VerifyShiftReprotController());
  }
}
