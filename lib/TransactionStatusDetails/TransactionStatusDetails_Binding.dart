import 'package:get/get.dart';

import 'TransactionStatusDetails_Controller.dart';

class TransactionStatusDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionStatusDetailsController>(
        () => TransactionStatusDetailsController());
  }
}
