import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../CustomAppbar/CustomAppbar_Controller.dart';
import '../Theme/Theme_Controller.dart';
import '../models/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionsController extends GetxController {
  var transactions = <String>[].obs;
  // final RxList<dynamic> filteredTransactions = <dynamic>[].obs;
  var searchQuery = ''.obs;
  static const _channel = MethodChannel('com.example.pms/method');
  final DatabaseHelper dbHelper = DatabaseHelper();
  final customController = Get.find<CustomAppbarController>();
  var paymentTypeName = ''.obs;
  var themeController = Get.find<ThemeController>();

  @override
  void onInit() async {
    super.onInit();
    // await customController.fetchTransactions();
    final prefs = await SharedPreferences.getInstance();
    print("paymentType@@@${customController.paymentType.value}");
    if (customController.paymentType.value == 1) {
      paymentTypeName.value = 'Cash';
    }
    if (customController.paymentType.value == 2) {
      paymentTypeName.value = 'Bank';
    }
    if (customController.paymentType.value == 4) {
      paymentTypeName.value = 'Fleet';
    }
    if (customController.paymentType.value == 5) {
      paymentTypeName.value = 'Bank Point';
    }
    if (customController.paymentType.value == 3) {
      paymentTypeName.value = 'Calibration';
      // print("paymantTypeName${paymantTypeName}");
    }

    await customController
        .fetchTransactionsByshift(prefs.getInt('shift_id') ?? 0);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> voidTrans(BuildContext context, String amount,
      String transactionSeqNo, String stannumber, String ecrRef) async {
    try {
      await _channel.invokeMethod<String>('voidTrans', {'ecrRefNo': ecrRef});

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
              print('Response from native code (voidTrans): $response');
              await dbHelper.updateStatusvoid(transactionSeqNo, 'progress');
              await dbHelper.updateStannumber(transactionSeqNo, '0');
              // await dbHelper.updateECRRef(transactionSeqNo, response['ecrRef']);
              await dbHelper.updateVoucherNo(
                  transactionSeqNo, response['voucherNo']);
              await dbHelper.updateBatchNo(
                  transactionSeqNo, response['batchNo']);
              customController.fetchTransactions();
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

      // await dbHelper.updateStatusvoid(transactionSeqNo, 'progress');
      // await dbHelper.updateStannumber(transactionSeqNo, '0');
      // customController.fetchTransactions();

      // Navigate to ChoosePayment page using Get.to

      // Get.toNamed('/ChoosePayment', arguments: amount);
    } on PlatformException catch (e) {
      print('Error invoking voidTrans: ${e.message}');
    }
  }

  void showVoidConfirmationDialog(BuildContext context, String stannumber,
      double amount, String transactionSeqNo, String ecrRef) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm_Void_Transaction'.tr),
          content: Text(
            stannumber.isEmpty
                ? 'Stannumber_not_found'.tr + '.'
                : 'Are_you_sure_you_want_to_void_this_transaction_with_Stannumber'
                        .tr +
                    ': $stannumber  ' +
                    'and'.tr +
                    'ecrRefNO'.tr +
                    ': ${ecrRef} ...  ',
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel'.tr,
                style: TextStyle(
                  color: themeController.isDarkMode.value
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog without doing anything
              },
            ),
            TextButton(
              child: Text(
                'Confirm'.tr,
                style: TextStyle(
                  color: themeController.isDarkMode.value
                      ? Colors.white
                      : Colors.black,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                if (stannumber.isNotEmpty) {
                  // Proceed with voiding the transaction if Stannumber is found
                  voidTrans(context, amount.toString(), transactionSeqNo,
                      stannumber, ecrRef);
                } else {
                  // Handle case where Stannumber is not found, if needed
                  print('Stannumber is missing, cannot proceed with void.');
                }
              },
            ),
          ],
        );
      },
    );
  }

  resetTransaction(var transaction) {
    print('Abdullah transaction ${transaction}');
    customController.pumpNo.value = transaction['pumpNo'];
    customController.fdCTimeStamp.value = transaction['fdCTimeStamp'];
    customController.nozzleNo.value = transaction['nozzleNo'];
    customController.transactionSeqNo.value = transaction['transactionSeqNo'];
    customController.amountVal.value = double.parse(transaction['amount']);
    customController.volume.value = double.parse(transaction['volume']);
    customController.unitPrice.value = double.parse(transaction['unitPrice']);
    customController.volumeProduct1.value =
        double.parse(transaction['volumeProduct1']);
    customController.volumeProduct2.value =
        double.parse(transaction['volumeProduct2']);
    customController.productNo1.value = int.parse(transaction['productNo1']);
    customController.productNo.value = transaction['productNo'];
    customController.productName.value = transaction['productName'];
    customController.TipsValue.value = transaction['TipsValue'].toString();
    customController.paymentType.value = 2;
    customController.stanNumber.value = int.parse(transaction['Stannumber']);
  }

  reprint(ecrRef, voucherNo) async {
    const _channel = MethodChannel('com.example.pms/method');
    final String response = await _channel.invokeMethod<String>(
            'reprintTransMsg',
            {"ecrRef": "${ecrRef}", "voucherNo": voucherNo}) ??
        'No response';
    print("response Home ----> ${response}");
  }

  bool isPrinting = false; // Prevent duplicate print jobs

  printReceipt() async {
    const MethodChannel _channel = MethodChannel("com.example.pms/method");

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
    } finally {}
  }
}
