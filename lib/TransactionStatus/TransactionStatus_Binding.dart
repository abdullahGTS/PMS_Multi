import 'package:get/get.dart';

import 'TransactionStatus_Controller.dart';

class TransactionStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionStatusController>(
        () => TransactionStatusController());
  }
}
