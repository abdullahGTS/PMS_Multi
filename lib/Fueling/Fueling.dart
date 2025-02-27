// ignore_for_file: use_key_in_widget_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pms/CustomAppbar/CustomAppbar_Controller.dart';

import '../Local/Local_Controller.dart';
import '../Theme/Theme_Controller.dart';
import 'Fueling_Controller.dart';

class FuelingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize the LoadingController here
    final loadingController = Get.find<FuelingController>();
    // var customAppbarController = Get.put(CustomAppbarController());
    final customController = Get.find<CustomAppbarController>();
    final localController = Get.find<LocalController>();
    var themeController = Get.find<ThemeController>();
    var color = Color.fromARGB(255, 24, 24, 24);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Obx(() {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: themeController.isDarkMode.value
                ? Color(0xFF2B2B2B)
                : Color(0xFFE9ECEF), // AppBar background color
            elevation: 0, // Remove the shadow
          ),
          backgroundColor: themeController.isDarkMode.value
              ? Color(0xFF2B2B2B)
              : Color(0xFFE9ECEF),
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
                        bottomLeft: Radius.circular(
                            0), // Bottom-left corner not rounded
                        bottomRight: Radius.circular(0),
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: Obx(() {
                  if (loadingController.isLoading.value) {
                    return Container(
                      child: localController.getCurrentLang()?.languageCode ==
                              "ar"
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'media/nozzleload.png',
                                      width: 120,
                                      height: 120,
                                    ),
                                    Column(
                                      children: [
                                        SlideTransition(
                                          position: loadingController
                                              .dropAnimation, // Raining animation
                                          // child: Image.asset(
                                          //   'media/drop.png',
                                          //   width: 50,
                                          //   height: 50,
                                          // ),
                                        ),
                                        SlideTransition(
                                          position: loadingController
                                              .dropAnimation, // Raining animation
                                          child: Image.asset(
                                            'media/drop.png',
                                            width: 50,
                                            height: 50,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                        width:
                                            20), // Add space between the images
                                    // Drop Image with animation
                                  ],
                                ),
                                const SizedBox(height: 20),
                                // Loading spinner
                                const SizedBox(height: 20),
                                Text(
                                  ('Fueling_in_progress...').tr,
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                                // const SizedBox(height: 20),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(
                                //       horizontal: 40),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     children: [
                                //       Expanded(
                                //         flex: 2,
                                //         child: Text(
                                //           ('timeout').tr,
                                //           style: TextStyle(
                                //               fontSize: 30,
                                //               color: Colors.white),
                                //         ),
                                //       ),
                                //       Expanded(
                                //         flex: 1,
                                //         child: Text(
                                //           "${loadingController.timeoutCounter.value}",
                                //           style: TextStyle(
                                //               fontSize: 30,
                                //               color: themeController
                                //                       .isDarkMode.value
                                //                   ? Color(0xFFE9ECEF)
                                //                   : Color(0xFF2B2B2B),
                                //               fontWeight: FontWeight.bold),
                                //         ),
                                //       ),
                                //       Expanded(
                                //         flex: 1,
                                //         child: Text(
                                //           ('sec').tr,
                                //           style: TextStyle(
                                //               fontSize: 30,
                                //               color: Colors.white),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        SlideTransition(
                                          position: loadingController
                                              .dropAnimation, // Raining animation
                                          // child: Image.asset(
                                          //   'media/drop.png',
                                          //   width: 50,
                                          //   height: 50,
                                          // ),
                                        ),
                                        SlideTransition(
                                          position: loadingController
                                              .dropAnimation, // Raining animation
                                          child: Image.asset(
                                            'media/drop.png',
                                            width: 50,
                                            height: 50,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Image.asset(
                                      'media/nozzleload.png',
                                      width: 120,
                                      height: 120,
                                    ),
                                    const SizedBox(
                                        width:
                                            20), // Add space between the images
                                    // Drop Image with animation
                                  ],
                                ),
                                const SizedBox(height: 20),
                                // Loading spinner
                                const SizedBox(height: 20),
                                Text(
                                  ('Fueling_in_progress...').tr,
                                  style: TextStyle(
                                      fontSize: 30, color: Colors.white),
                                ),
                                // const SizedBox(height: 20),
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(
                                //       horizontal: 40),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.center,
                                //     children: [
                                //       Expanded(
                                //         flex: 2,
                                //         child: Text(
                                //           ('timeout').tr,
                                //           style: TextStyle(
                                //               fontSize: 30,
                                //               color: Colors.white),
                                //         ),
                                //       ),
                                //       Expanded(
                                //         flex: 1,
                                //         child: Text(
                                //           "${loadingController.timeoutCounter.value}",
                                //           style: TextStyle(
                                //               fontSize: 30,
                                //               color: themeController
                                //                       .isDarkMode.value
                                //                   ? Color(0xFFE9ECEF)
                                //                   : Color(0xFF2B2B2B),
                                //               fontWeight: FontWeight.bold),
                                //         ),
                                //       ),
                                //       Expanded(
                                //         flex: 1,
                                //         child: Text(
                                //           ('sec').tr,
                                //           style: TextStyle(
                                //               fontSize: 30,
                                //               color: Colors.white),
                                //         ),
                                //       ),
                                //     ],
                                //   ),
                                // ),
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
      }),
    );
  }
}
