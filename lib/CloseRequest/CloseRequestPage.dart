// ignore_for_file: use_key_in_widget_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../CustomAppbar/CustomAppbar_Controller.dart';
import '../Theme/Theme_Controller.dart';
import 'CloseRequest_Controller.dart';

class CloseRequestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize the LoadingController here
    final closeRequestController = Get.find<CloseRequestController>();
    final customcontroller = Get.find<CustomAppbarController>();
    var themeController = Get.find<ThemeController>();

    return Obx(() {
      return Scaffold(
        appBar: null,
        backgroundColor: themeController.isDarkMode.value
            ? Color(0xFF2B2B2B)
            : Color(0xFFE9ECEF), // Optional: Customize your background color
        body: Stack(
          children: [
            Positioned(
              right: 100,
              top: 0,
              bottom: 0,
              child: Transform.rotate(
                angle: 45 * (3.14159265359 / 180),
                child: Container(
                  height: 500,
                  width: 150, // Width of the red background
                  decoration: BoxDecoration(
                    color: Color(0x35576E38).withOpacity(0.6),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10), // Top-left corner rounded
                      topRight:
                          Radius.circular(0), // Top-right corner not rounded
                      bottomLeft:
                          Radius.circular(0), // Bottom-left corner not rounded
                      bottomRight: Radius.circular(0),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Obx(() {
                if (closeRequestController.isLoading.value) {
                  return Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock_clock_rounded,
                              color: themeController.isDarkMode.value
                                  ? Colors.white
                                  : Color.fromARGB(255, 24, 24, 24),
                              size: 150,
                            ),
                            const SizedBox(
                                width: 20), // Add space between the images
                            // Drop Image with animation
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Loading spinner
                        const SizedBox(height: 20),
                        Obx(() {
                          return Text(
                            '${closeRequestController.closeStatus.value}'.tr,
                            style: TextStyle(
                              fontSize: 30,
                              color: themeController.isDarkMode.value
                                  ? Colors.white
                                  : Color.fromARGB(255, 24, 24, 24),
                            ),
                          );
                        }),
                        Obx(() {
                          return Text(
                            '${closeRequestController.posNum.value}' +
                                ' ' +
                                'Remains'.tr,
                            style: TextStyle(
                              fontSize: 25,
                              color: themeController.isDarkMode.value
                                  ? Colors.white
                                  : Color.fromARGB(255, 24, 24, 24),
                            ),
                          );
                        }),
                        SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: () async {
                            closeRequestController.checkthelastpos();
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 50.0),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: const Color(0xED166E36)),
                              child: Center(
                                child: Text(
                                  "Check_Remains".tr,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  // If loading is complete, return an empty container or something else
                  return Container();
                }
              }),
            ),
          ],
        ),
      );
    });
  }
}
