// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pms/Models/transactiontable.dart';

import '../CustomAppbar/CustomAppbar_Controller.dart';
import '../models/database_helper.dart';

class ShiftController extends GetxController {
  final customController = Get.find<CustomAppbarController>();
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    startWIFIBackgroundService();
    startBackgroundService();

    var last_shift = await dbHelper.lastShift();
    if (last_shift != null) {
      print("last_shiftsupervisor${last_shift?['status']}");
      if (last_shift?['status'] == 'opened') {
        customController.managershift.value = last_shift?['supervisor'] ?? '';
        customController.datetimeshift.value = last_shift?['startshift'] ?? '';
        Get.toNamed('/Home');
      }
    } else {
      print('no last shift in shifts on init');
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  startWIFIBackgroundService() async {
    const _channel = MethodChannel('com.example.pms/method');
    var response = await _channel.invokeMethod('enableWifi');
    // Wait for the transaction result
    print('startWIFIBackgroundService---> ${response}');
  }

  startBackgroundService() async {
    const _channel = MethodChannel('com.example.pms/method');
    await _channel.invokeMethod('startService');
  }
}
