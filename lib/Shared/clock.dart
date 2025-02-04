// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:get/get.dart';

import '../CustomAppbar/CustomAppbar_Controller.dart';
import '../Theme/Theme_Controller.dart';

class ClockContainer extends StatelessWidget {
  var color = Color.fromARGB(255, 24, 24, 24);
  final customController = Get.find<CustomAppbarController>();
  var themeController = Get.find<ThemeController>();

  // List of month names
  final List<String> monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  Stream<String> getDateStream() {
    return Stream.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final localizedMonth =
          monthNames[now.month - 1].tr; // Apply .tr directly here
      return "$localizedMonth ${now.day.toString().padLeft(2, '0')}";
    });
  }

  Stream<String> getClockStream() {
    return Stream.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      // Format the output to include the current time
      return "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(7),
        color: themeController.isDarkMode.value
            ? color
            : Colors.white.withOpacity(0.5),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Row for Month and Day
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align to the right
              children: [
                StreamBuilder<String>(
                  stream: getDateStream(),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data ?? '',
                      style: TextStyle(
                        color: themeController.isDarkMode.value
                            ? Colors.white
                            : color,
                        fontSize: 18,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          // Clock time on the second row
          StreamBuilder<String>(
            stream: getClockStream(),
            builder: (context, snapshot) {
              return Text(
                snapshot.data ?? 'Loading'.tr + '...',
                style: TextStyle(
                  color:
                      themeController.isDarkMode.value ? Colors.white : color,
                  fontSize: 50,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
