import 'package:get/get.dart';

import 'VerifyTransactionReprot_Controller.dart';

class VerifyTransactionReprotBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerifyTransactionReprotController>(
        () => VerifyTransactionReprotController());
  }
}
