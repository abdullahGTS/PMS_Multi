// ignore_for_file: use_key_in_widget_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pms/CustomAppbar/CustomAppbar_Controller.dart';

import '../Local/Local_Controller.dart';
import 'Fueling_Controller.dart';

class FuelingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize the LoadingController here
    final loadingController = Get.find<FuelingController>();
    // var customAppbarController = Get.put(CustomAppbarController());
    final customController = Get.find<CustomAppbarController>();
    final localController = Get.find<LocalController>();

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //   icon:
          //       Icon(Icons.arrow_back, color: Colors.white), // Back button icon
          //   onPressed: () {
          //     Get.back(); // Navigate back when the back button is pressed
          //   },
          // ),
          // title: Text(
          //   'Fueling Page', // Title of the AppBar
          //   style: TextStyle(color: Colors.white),
          // ),
          backgroundColor: const Color(0xED1C1C1C), // AppBar background color
          elevation: 0, // Remove the shadow
        ),
        backgroundColor: const Color(0xED1C1C1C),
        // Optional: Customize your background color
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () async {
        //     var test_con = customAppbarController.socketConnection.isConnected();
        //     print("test_con--->${test_con}");
        //     // await customAppbarController.startConnection();
        //     // customAppbarController.socketConnection.sendMessage(
        //     //     customAppbarController
        //     //         .getXmlHeader(customAppbarController.incrementXml()));
        //     // print("test_con--->${test_con}");
        //   },
        //   child: Icon(Icons.add),
        // ),
        body: Center(
          child: Obx(() {
            if (loadingController.isLoading.value) {
              return Container(
                child: localController.getCurrentLang()?.languageCode == "ar"
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
                                  width: 20), // Add space between the images
                              // Drop Image with animation
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Loading spinner
                          const SizedBox(height: 20),
                          Text(
                            ('Fueling_in_progress...').tr,
                            style: TextStyle(fontSize: 30, color: Colors.white),
                          ),
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
                                  width: 20), // Add space between the images
                              // Drop Image with animation
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Loading spinner
                          const SizedBox(height: 20),
                          Text(
                            ('Fueling_in_progress...').tr,
                            style: TextStyle(fontSize: 30, color: Colors.white),
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
      ),
    );
  }
}
