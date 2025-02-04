// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../CustomAppbar/CustomAppbar_Controller.dart';

class TipsController extends GetxController {
  final customController = Get.find<CustomAppbarController>();
  final TipInput = TextEditingController();
  final AllAmountInput = TextEditingController();
  var isInputTips = false.obs;
  var isInputAmount = false.obs;
  final FocusNode firstFieldFocusNode = FocusNode();
  final FocusNode secondFieldFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
    print("valueTipsController${customController.productNo.value}");
    Get.closeAllSnackbars();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    TipInput.dispose(); // Dispose of TextEditingController
    super.onClose(); // Call super to ensure other cleanup tasks
  }

  void updateValue() {
    print(TipInput.text);

    int texttipinput;
    if (TipInput.text != '') {
      isInputAmount.value = true;
      texttipinput = int.parse(TipInput.text);
    } else {
      texttipinput = 0;
    }
    if (texttipinput < 0) {
      Get.snackbar(
        "Error".tr,
        "not_correct_Tips".tr +
            " .... " +
            "Please_make_sure_the_Tips_amount_is_greater_than_the".tr +
            "0 !",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      isInputAmount.value = true;
      customController.TipsValue.value = TipInput.text;
      customController.TipsValue.value =
          TipInput.text.isEmpty ? '0' : TipInput.text;
    }
    if (TipInput.text.isEmpty) {
      isInputAmount.value = false;
    }
  }

  void updateAllamounvalue() {
    print("AllAmountInput.text${AllAmountInput.text}");
    customController.AllAmountValue.value = AllAmountInput.text;
    if (AllAmountInput.text != '') {
      print("tipsall");
      print(
          'customController.AllAmountValue.value${customController.AllAmountValue.value}');
      print(
          'customController.amountVal.value${customController.amountVal.value}');
      print(
          'customControllervalue${double.parse(customController.AllAmountValue.value) - customController.amountVal.value}');
      if (double.parse(customController.AllAmountValue.value) >
          customController.amountVal.value) {
        var tip = (double.parse(customController.AllAmountValue.value) -
                customController.amountVal.value)
            .toInt();
        print("tip${tip}");
        customController.TipsValue.value = tip.toString();
        isInputTips.value = true;

        print(
            "customController.TipsValue.value${customController.TipsValue.value}");
      } else {
        isInputTips.value = true;
        Get.snackbar(
          "Error".tr,
          "not_correct_Total".tr +
              " ...." +
              "Please_make_sure_the_total_amount_is_greater_than_the_fueling_amount"
                  .tr +
              "!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
    if (AllAmountInput.text.isEmpty) {
      isInputTips.value = false;
    }
  }
}
