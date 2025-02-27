import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../CustomAppbar/CustomAppbar_Controller.dart';
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

class TransactionStatusDetailsController extends GetxController {
  // final customController = Get.put(CustomAppbarController());
  final customController = Get.find<CustomAppbarController>();
  var TrxSeqNo = ''.obs;
  var selectedPaymentOption = ''.obs;
  var TrxDetailsList = [].obs;
  var TrxDetailsTempList = [];
  var TrxListener;
  final TrxDetalisTipInput = TextEditingController();
  static const _channel = MethodChannel('com.example.pms/method');
  var isLoading = true.obs;
  var isInputTips = false.obs;
  var isInputAmount = false.obs;
  final TipInput = TextEditingController();
  final AllAmountInput = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    Get.closeAllSnackbars();
    TrxSeqNo.value = Get.arguments['TrxSeqNo'] ?? 'Unknown';
    print("TrxSeqNoAvalible${TrxSeqNo}");
    getTrxDetailsBySeqNo();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    TrxDetalisTipInput.dispose();
    if (TrxListener != null) {
      TrxListener!.cancel();
      TrxListener = null;
      print("Timer stopped.");
    }

    super.onClose();
  }

  void selectPaymentOption(BuildContext context, String option) async {
    selectedPaymentOption.value = option;
    print(option);
    // print(
    //     "customController.TipsValue.value****${double.parse(customController.TipsValue.value)}");
    if (customController.TipsValue.value == "") {
      customController.TipsValue.value = "0.00";
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedPaymentOption', selectedPaymentOption.value);
    if (double.parse(customController.TipsValue.value) > 20.00) {
      Get.snackbar(
        "Error".tr,
        "not_correct_Tips_the_max_tips".tr + " 20 " + "EGP".tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else if (double.parse(customController.TipsValue.value) < 0.00) {
      Get.snackbar(
        "Error".tr,
        "Please_make_sure_the_total_amount_is_greater_than_the_fueling_amount"
            .tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      print("optionoption${option}");
      if (customController.issupervisormaiar.value) {
        customController.paymentType.value = 3;

        customController.saveTransaction(3);
        printCashReceipt();
      } else {
        if (option == "Bank_Card".tr) {
          var sum = customController.amountVal.value +
              double.parse(customController.TipsValue.value);
          await startTrans(sum);
        }
        if (option == "Cash".tr) {
          customController.paymentType.value = 1;

          customController.saveTransaction(1);
          printCashReceipt();
        }
        if (option == "Fleet".tr) {
          customController.paymentType.value = 4;

          customController.saveTransaction(4);
          printCashReceipt();
        }
        if (option == "Bank_Point".tr) {
          customController.paymentType.value = 5;

          customController.saveTransaction(5);
          printCashReceipt();
        }
      }
    }
  }

  startTrans(double amount) async {
    try {
      // Send the amount for transaction initiation
      var adjustedAmount = amount * 100; // Convert to minor units
      // await _channel.invokeMethod('startTrans', {'amount': adjustedAmount});
      var ecrRefNo =
          '${customController.SerialNumber.value.substring(customController.SerialNumber.value.length - 5)}${customController.transactionSeqNo.value}${customController.trxSeqNoCounter++}';
      print("ecrRefNo------>${ecrRefNo}");
      await _channel.invokeMethod(
          'startTrans', {'amount': adjustedAmount, 'ecrRefNo': ecrRefNo});

      // Wait for the transaction result
      _channel.setMethodCallHandler((call) async {
        if (call.method == "onTransactionResult") {
          final Map<String, dynamic> response =
              Map<String, dynamic>.from(call.arguments);

          // Handle transaction result
          if (response.containsKey("error")) {
            print("Transaction Error: ${response['error']}");
          } else {
            print("Transaction Successful: $response");
            customController.paymentType.value = 2;
            if (response['rspCode'] == 0) {
              if (response['cardNo'] == 'Unknown') {
                customController.stanNumber.value = 0;
                return false;
              } else {
                print('customController.stanNumber.value ${response['stan']}');
                print(
                    'customController.voucherNo.value ${response['voucherNo']}');
                print('customController.ecrRef.value ${response['ecrRef']}');
                print('customController.stanNumber.value ${response}');
                customController.stanNumber.value = response['stan'];
                customController.voucherNo.value = response['voucherNo'];
                customController.ecrRef.value = response['ecrRef'];
                customController.batchNo.value = response['batchNo'];
                print(
                    'customController.stanNumber.value ${customController.stanNumber.value}');
                print(
                    'customController.voucherNo.value ${customController.voucherNo.value}');
                print(
                    'customController.ecrRef.value ${customController.ecrRef.value}');
                customController.saveTransaction(2);
                // got to receipt
                Get.toNamed('/Receipt');
              }
            } else {
              Get.snackbar(
                'Transaction Fail',
                '[${response['rspCode']}]' + ' - ' + '${response['rspMsg']}',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          }
        }
      });
    } on PlatformException catch (e) {
      print('Error initiating transaction: ${e.message}');
    }
  }

  printCashReceipt() {
    customController.stanNumber.value = 0;
    // customController.paymentType.value = 1;
    // got to receipt
    print("Transaction Successful Cash");
    Get.toNamed('/Receipt');
  }

  // Method to select a payment option
  getTrxDetailsBySeqNo() async {
    customController.trxAttendant.value = customController.managershift.value;
    print("teeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    print("id1${customController.iD}");
    // Increment RequestID
    customController.iD++;
    print("id2${customController.iD}");

    // Get the current time formatted for the XML
    String currentTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now());

    String xmlContentreq = '''
<?xml version="1.0" encoding="utf-8" ?>
<ServiceRequest RequestType="GetFuelSaleTrxDetailsByNo" ApplicationSender="${customController.SerialNumber.value.substring(customController.SerialNumber.value.length - 5)}"
WorkstationID="PMS" RequestID="${customController.iD}" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:noNamespaceSchemaLocation="FDC_GetFuelSaleTrxDetailsByNo_Request.xsd">
<POSdata>
<POSTimeStamp>$currentTime</POSTimeStamp>
<DeviceClass Type="FP" DeviceID="*" TransactionSeqNo="${TrxSeqNo.value}">
</DeviceClass>
</POSdata>
</ServiceRequest>
''';
    print("xmlContentreqcheckFueling${xmlContentreq}");

    // Log the XML for debugging purposes
    // Get.snackbar(
    //   'Check PUMP Status',
    //   'GetFPState Request Sent',
    //   snackPosition: SnackPosition.TOP,
    //   backgroundColor: Colors.green,
    //   colorText: Colors.white,
    // );
    // Send the constructed XML message through socket
    // print(customController.socketConnection);
    // print(customController.socketConnection.runtimeType);

    TrxListener = customController.xmlData.listen((data) async {
      var document = XmlDocument.parse(data);
      var serviceResponse = document.getElement('ServiceResponse');
      if (serviceResponse != null) {
        var RequestType = serviceResponse.getAttribute('RequestType');
        var OverallResult = serviceResponse.getAttribute('OverallResult');
        if (RequestType == 'GetFuelSaleTrxDetailsByNo' &&
            OverallResult == 'Success') {
          customController.statevalue.value =
              document.findAllElements('State').first.text;
          print("statevalue${customController.statevalue}");

          customController.AuthorisationApplicationSender.value = document
              .findAllElements('AuthorisationApplicationSender')
              .first
              .text;
          print(
              "AuthorisationApplicationSender${customController.AuthorisationApplicationSender}");
          customController.pumpNo.value = document
                  .findAllElements('DeviceClass')
                  .first
                  .getAttribute('PumpNo') ??
              '';
          if (customController.AuthorisationApplicationSender.value ==
              customController.SerialNumber.value
                  .substring(customController.SerialNumber.value.length - 5)) {
            customController.counterTrans++;
            customController
                .updateCounterTrans(customController.counterTrans.value);
            // Send counterTrans to HomeController
            customController.fdCTimeStamp.value =
                document.findAllElements('FDCTimeStamp').first.text;

            customController.type.value = document
                    .findAllElements('DeviceClass')
                    .first
                    .getAttribute('Type') ??
                '';

            customController.deviceID.value = document
                    .findAllElements('DeviceClass')
                    .first
                    .getAttribute('DeviceID') ??
                '';

            customController.nozzleNo.value = document
                    .findAllElements('DeviceClass')
                    .first
                    .getAttribute('NozzleNo') ??
                '';
            customController.transactionSeqNo.value = document
                    .findAllElements('DeviceClass')
                    .first
                    .getAttribute('TransactionSeqNo') ??
                '';
            customController.fusionSaleId.value = document
                    .findAllElements('DeviceClass')
                    .first
                    .getAttribute('FusionSaleId') ??
                '';
            print("fdCTimeStamp${customController.fdCTimeStamp.value}");

            print("type${customController.type.value}");
            print("deviceID${customController.deviceID.value}");
            print("pumpNo${customController.pumpNo.value}");
            print("nozzleNo${customController.nozzleNo.value}");
            print("transactionSeqNo${customController.transactionSeqNo.value}");

            // fusionSaleId.value = document
            //         .findAllElements('DeviceClass')
            //         .first
            //         .getAttribute('FusionSaleId') ??
            //     '';
            customController.releaseToken.value =
                document.findAllElements('ReleaseToken').first.text;
            // completionReason.value =
            //     document.findAllElements('CompletionReason').first.text;
            customController.fuelMode.value = document
                    .findAllElements('FuelMode')
                    .first
                    .getAttribute('ModeNo') ??
                '';
            customController.productUM.value =
                document.findAllElements('ProductUM').first.text ?? '';

            customController.productNo.value =
                document.findAllElements('ProductNo').first.text;
            customController.amountVal.value = double.tryParse(
                    document.findAllElements('Amount').first.text) ??
                0.0;
            customController.volume.value = double.tryParse(
                    document.findAllElements('Volume').first.text) ??
                0.0;
            customController.unitPrice.value = double.tryParse(
                    document.findAllElements('UnitPrice').first.text) ??
                0.0;
            customController.volumeProduct1.value = double.tryParse(
                    document.findAllElements('VolumeProduct1').first.text) ??
                0.0;
            customController.volumeProduct2.value = double.tryParse(
                    document.findAllElements('VolumeProduct2').first.text) ??
                0.0;
            customController.productNo1.value = int.tryParse(
                    document.findAllElements('ProductNo1').first.text) ??
                0;
            // productUM.value = document.findAllElements('ProductUM').first.text;
            customController.productName.value =
                customController.getProductName(
                        int.parse(customController.productNo.value)) ??
                    'No Product';
            // productName.value = document.findAllElements('ProductName').first.text;
            customController.blendRatio.value = int.tryParse(
                    document.findAllElements('BlendRatio').first.text) ??
                0;
            customController.startTimeStamp.value =
                document.findAllElements('StartTimeStamp').first.text ?? "";
            customController.endTimeStamp.value =
                document.findAllElements('EndTimeStamp').first.text ?? "";
          } else {
            Get.dialog(
              WillPopScope(
                onWillPop: () async {
                  // Prevent back button from closing the dialog
                  return false;
                },
                child: Dialog(
                  backgroundColor: Colors.transparent,
                  child: Container(
                    color: const Color(0xFF2B2B2B),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Access_Denied".tr,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "You_do_not_have_permission_to_access_this_transaction"
                                  .tr +
                              ".",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            Get.offAllNamed("/TransactionStatus", arguments: {
                              'pumpName': customController.pumpNo.value
                            }); // Close the dialog
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF166E36), // Button color
                          ),
                          child: Text(
                            "OK".tr,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              barrierDismissible:
                  false, // Prevent dialog dismissal by tapping outside
            );
          }
          isLoading.value = false;
        }
      }
    });
    customController.socketConnection
        .sendMessage(customController.getXmlHeader(xmlContentreq));
    await Future.delayed(Duration(seconds: 1));

    // AvailableTrxList.value = AvailableTrxTempList;

    // Get.snackbar(
    //   'AvailableTrxList',
    //   '${AvailableTrxList.value}',
    //   snackPosition: SnackPosition.TOP,
    //   backgroundColor: Colors.green,
    //   colorText: Colors.white,
    // );
    // if (AvailableTrxListener != null) {
    //   AvailableTrxListener!.cancel();
    //   print("AvailableTrxListener stopped.");
    // }
  }

  void updateValue() {
    print("TipInput.textTipInput.text${TipInput.text}");

    int texttipinput;
    if (TipInput.text != '') {
      isInputAmount.value = true;
      texttipinput = int.parse(TipInput.text);
    } else {
      texttipinput = 0;
      customController.TipsValue.value = "0";
    }
    if (texttipinput < 0 || texttipinput > 20) {
      customController.TipsValue.value = texttipinput.toString();
      // Get.snackbar(
      //   "Error",
      //   "not correct Tips .... Please make sure the Tips amount is greater than the 0 !",
      //   backgroundColor: Colors.red,
      //   colorText: Colors.white,
      // );
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
            customController.amountVal.value);
        print("tip${tip}");
        customController.TipsValue.value = tip.toStringAsFixed(2);
        isInputTips.value = true;

        print(
            "customController.TipsValue.value${customController.TipsValue.value}");
      } else {
        isInputTips.value = true;
        print(
            "testttttttttttttttt${double.parse(customController.AllAmountValue.value) - customController.amountVal.value}");
        customController.TipsValue.value =
            "${double.parse(customController.AllAmountValue.value) - customController.amountVal.value}";
        // Get.snackbar(
        //   "Error",
        //   "not correct Total .... Please make sure the total amount is greater than the fueling amount!",
        //   backgroundColor: Colors.red,
        //   colorText: Colors.white,
        // );
      }
    }

    if (AllAmountInput.text.isEmpty) {
      isInputTips.value = false;
      customController.TipsValue.value = "0";
    }
  }
}
