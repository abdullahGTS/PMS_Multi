import 'package:get/get.dart';

import 'VerifyTransactionAll_Controller.dart';

class VerifyTransactionAllBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyTransactionAllController>(
        () => VerifyTransactionAllController());
  }
}
