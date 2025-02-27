import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../CustomAppbar/CustomAppbar_Controller.dart';
import '../Receipt/Receipt_Controller.dart';
import '../models/database_helper.dart';
import 'package:intl/intl.dart';

class ResetPaymentController extends GetxController {
  // final customController = Get.put(CustomAppbarController());
  final customController = Get.find<CustomAppbarController>();
  final receiptController = Get.put(ReceiptController());
  final DatabaseHelper dbHelper = DatabaseHelper();
  var selectedPaymentOption = ''.obs;
  var paymentTypeName = ''.obs;

  static const _channel = MethodChannel('com.example.pms/method');

  @override
  void onInit() {
    super.onInit();
    Get.closeAllSnackbars();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Method to select a payment option
  void selectPaymentOption(BuildContext context, String option) async {
    selectedPaymentOption.value = option;
    print(option);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedPaymentOption', selectedPaymentOption.value);

    print("optionoption${option}");
    if (option == "Bank_Card".tr) {
      var sum = customController.amountVal.value +
          double.parse(customController.TipsValue.value);
      await startTrans(sum);
    }
    if (option == "Cash".tr) {
      customController.paymentType.value = 1;
      paymentTypeName.value = "Cash";
      // customController.saveTransaction(1);
      printCashReceipt();
    }
    if (option == "Fleet".tr) {
      customController.paymentType.value = 4;

      paymentTypeName.value = "Fleet";
      // customController.saveTransaction(4);
      printFleetReceipt();
    }
    if (option == "Bank_Point".tr) {
      customController.paymentType.value = 5;
      paymentTypeName.value = "Bank Point";

      // customController.saveTransaction(5);
      printBankPointsReceipt();
    }
  }

  startTrans(double amount) async {
    try {
      // Send the amount for transaction initiation
      var adjustedAmount = amount * 100; // Convert to minor units
      var ecrRefNo =
          '${customController.SerialNumber.value.substring(customController.SerialNumber.value.length - 5)}${customController.transactionSeqNo.value}${customController.trxSeqNoCounter++}';
      print("ecrRef----------->${ecrRefNo}");
      await _channel.invokeMethod(
          'startTrans', {'amount': adjustedAmount, 'ecrRefNo': ecrRefNo});
      // await _channel.invokeMethod('startTrans', {'amount': adjustedAmount});

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
            if (response['rspCode'] == 0) {
              if (response['cardNo'] == 'Unknown') {
                customController.stanNumber.value = 0;
                return false;
              } else {
                print('customController.stanNumber.value ${response['stan']}');
                print('customController.stanNumber.value ${response}');
                customController.stanNumber.value = response['stan'];
                customController.voucherNo.value = response['voucherNo'];
                customController.ecrRef.value = response['ecrRef'];
                customController.batchNo.value = response['batchNo'];
                print(
                    'customController.stanNumber.value ${customController.stanNumber.value}');
                customController.paymentType.value = 2;
                paymentTypeName.value = "Bank";
                // got to receipt
                dbHelper.updateStatusvoid(
                    customController.transactionSeqNo.value, 'complete');
                dbHelper.updatePaymentType(
                    customController.transactionSeqNo.value, 'Bank');
                dbHelper.updateStannumber(
                    customController.transactionSeqNo.value,
                    response['stan'].toString());
                dbHelper.updateIsPortal(
                    customController.transactionSeqNo.value, "false");
                dbHelper.updateECRRef(customController.transactionSeqNo.value,
                    response['ecrRef']);
                dbHelper.updateVoucherNo(
                    customController.transactionSeqNo.value,
                    response['voucherNo']);
                dbHelper.updateBatchNo(customController.transactionSeqNo.value,
                    response['batchNo']);

                if (customController.isconnect.value) {
                  customController.sendTransactionToApi();
                }

                printReceipt();
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
    dbHelper.updateStatusvoid(
        customController.transactionSeqNo.value, 'complete');
    dbHelper.updatePaymentType(customController.transactionSeqNo.value, 'Cash');
    dbHelper.updateStannumber(customController.transactionSeqNo.value, '0');
    dbHelper.updateIsPortal(customController.transactionSeqNo.value, "false");

    if (customController.isconnect.value) {
      customController.sendTransactionToApi();
    }
    customController.paymentType.value = 1;

    printReceipt();
    // receiptController.printReceipt();
  }

  printFleetReceipt() {
    customController.stanNumber.value = 0;
    // customController.paymentType.value = 1;
    // got to receipt
    print("Transaction Successful Fleet");
    dbHelper.updateStatusvoid(
        customController.transactionSeqNo.value, 'complete');
    dbHelper.updatePaymentType(
        customController.transactionSeqNo.value, 'Fleet');
    dbHelper.updateStannumber(customController.transactionSeqNo.value, '0');
    dbHelper.updateIsPortal(customController.transactionSeqNo.value, "false");

    if (customController.isconnect.value) {
      customController.sendTransactionToApi();
    }
    customController.paymentType.value = 4;

    printReceipt();
    // receiptController.printReceipt();
  }

  printBankPointsReceipt() {
    customController.stanNumber.value = 0;
    // customController.paymentType.value = 1;
    // got to receipt
    print("Transaction Successful Bank Points");
    dbHelper.updateStatusvoid(
        customController.transactionSeqNo.value, 'complete');
    dbHelper.updatePaymentType(
        customController.transactionSeqNo.value, 'Bank Point');
    dbHelper.updateStannumber(customController.transactionSeqNo.value, '0');
    dbHelper.updateIsPortal(customController.transactionSeqNo.value, "false");

    if (customController.isconnect.value) {
      customController.sendTransactionToApi();
    }
    customController.paymentType.value = 5;

    printReceipt();
    // receiptController.printReceipt();
  }

  printReceipt() async {
    try {
      const int receiptWidth =
          30; // Adjust based on your printer's character width

      String centerText(String text) {
        int spaces = (receiptWidth - text.length) ~/ 2;
        return ' ' * spaces + text + ' ' * spaces;
      }

      // Left and right alignment utility
      String alignLeftRight(String left, String right) {
        int spaces = receiptWidth - left.length - right.length;
        return left + ' ' * spaces + right;
      }

      final bytes = await rootBundle.load('media/new_logo_recet.jpg');
      final base64String = base64Encode(Uint8List.view(bytes.buffer));

      List<String> receiptContent = [
        '',
        '',
        centerText(customController.config['station name'] ?? ''),
        centerText(customController.config['station address'] ?? ''),
        centerText(DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())),
        '',
        '-------------------------------',
        alignLeftRight(('Transaction SeqNo' + ':'),
            customController.transactionSeqNo.value.toString()),
        '',
        alignLeftRight(
            ('Pump No' + ':'), customController.pumpNo.value.toString()),
        '',
        alignLeftRight(
            ('Nozzle No' + ':'), customController.nozzleNo.value.toString()),
        '',
        alignLeftRight(
            ('Product Name' + ':'),
            customController.getProductName(
                    int.parse(customController.productNo.value)) ??
                ""),
        '',
        alignLeftRight(('Payment Type' + ':'), paymentTypeName.value),
        '',
        (customController.trxAttendant.value.isNotEmpty)
            ? alignLeftRight(
                ('Transaction By' + ':'), customController.trxAttendant.value)
            : alignLeftRight(
                ('Calibration' + ':'), customController.managershift.value),
        '-------------------------------',
        alignLeftRight(('Total Amount' + ':'),
            (customController.amountVal.value.toStringAsFixed(2) + ' EGP')),
        '',
        alignLeftRight(('Volume' + ':'),
            (customController.volume.value.toStringAsFixed(2) + ' LTR')),
        '',
        alignLeftRight(('Unit Price' + ':'),
            (customController.unitPrice.value.toStringAsFixed(2) + ' EGP')),
        '',
        '',
        '',
        alignLeftRight(('Total Paid' + ':'),
            (customController.amountVal.value.toStringAsFixed(2) + ' EGP')),
        '-------------------------------',
        '',
        'Thank you for your visit' + '.',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
      ];

      print("receiptContent->>>>${receiptContent}");

      final result = await _channel.invokeMethod('printReceipt',
          {'receiptContent': receiptContent, 'image': base64String});

      // Center text utility

      // Initialize printer
    } catch (e) {
      print("An error occurred during printing: $e");
    } finally {
      // customController.amountVal.value = 0.0;
      customController.TipsValue.value = "0";
      customController.issupervisormaiar.value = false;
      Get.offAllNamed("/Home");
    }
  }
}
