import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../Theme/Theme_Controller.dart';
import 'CustomAppbar_Controller.dart';

import 'package:fluttertoast/fluttertoast.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final customController = Get.find<CustomAppbarController>();
    var themeController = Get.find<ThemeController>();
    var color = Color.fromARGB(255, 24, 24, 24);

    return Obx(() {
      return Container(
        height: 200,
        padding: const EdgeInsets.only(top: 30.0), // Add padding for spacing
        decoration: BoxDecoration(
          color: themeController.isDarkMode.value
              ? color
              : Colors.white.withOpacity(0.8),
          // Set background color to #1B1B1B
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(80), // Rounded bottom left corner
            bottomRight: Radius.circular(80), // Rounded bottom right corner
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // First Row: Drawer Icon, Station Name, and Logos
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Drawer Icon
                    Get.currentRoute == "/verify"
                        ? GestureDetector(
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: themeController.isDarkMode.value
                                  ? Colors.white
                                  : color,
                              size: 40,
                            ),
                            onTap: () {
                              Get.offAllNamed('/Home');
                            },
                          )
                        : GestureDetector(
                            child: Icon(
                              Icons.menu,
                              color: themeController.isDarkMode.value
                                  ? Colors.white
                                  : color,
                              size: 40,
                            ),
                            // Drawer icon
                            onTap: () {
                              Scaffold.of(context).openDrawer();
                              // Open the drawer
                            },
                          ),

                    Obx(() {
                      return Icon(
                        Icons.circle,
                        color: customController.isconnect.value
                            ? Colors.green
                            : Colors.red,
                      );
                    }),
                    const SizedBox(width: 8), // Add some space
                    Obx(
                      () => Text(
                        customController.config['station_name'] ?? '',
                        style: TextStyle(
                          color: themeController.isDarkMode.value
                              ? Colors.white
                              : color,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        // Add your desired functionality here
                        // Example: Navigate to another page or perform an action
                        if (Get.currentRoute == '/Availabletransactions') {
                          Get.offAllNamed('/Availabletransactions');
                        } else {
                          await customController.fetchToken();
                          if (customController.isconnect.value) {
                            Fluttertoast.showToast(
                              msg: "You_are_connected".tr, // Message to display
                              toastLength: Toast
                                  .LENGTH_SHORT, // Duration: LENGTH_SHORT or LENGTH_LONG
                              gravity: ToastGravity
                                  .BOTTOM, // Position: TOP, CENTER, or BOTTOM
                              backgroundColor: Colors.black, // Background color
                              textColor: Colors.white, // Text color
                              fontSize: 16.0, // Font size
                            );
                          } else {
                            Fluttertoast.showToast(
                              msg: "No_Connection".tr, // Message to display
                              toastLength: Toast
                                  .LENGTH_SHORT, // Duration: LENGTH_SHORT or LENGTH_LONG
                              gravity: ToastGravity
                                  .BOTTOM, // Position: TOP, CENTER, or BOTTOM
                              backgroundColor: Colors.red, // Background color
                              textColor: Colors.white, // Text color
                              fontSize: 16.0, // Font size
                            );
                          }
                        }
                      },
                      child: Container(
                        width: 60, // Adjust the width
                        height: 60, // Adjust the height
                        decoration: const BoxDecoration(
                          shape:
                              BoxShape.circle, // Makes the container circular
                          image: DecorationImage(
                            image: AssetImage(
                                'media/new_logo.png'), // Path to the logo
                            fit: BoxFit
                                .contain, // Ensures the entire image fits within the circle
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10), // Add some space between images
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Second Row: Online Status
            Row(
              children: [
                SizedBox(width: 50), // Add spacing before the text
                SizedBox(width: 5),
                Obx(() {
                  return customController.isconnect.value
                      ? Text(
                          ("Station_online").tr,
                          style: TextStyle(
                            color: themeController.isDarkMode.value
                                ? Colors.white
                                : color, // Green to indicate online status
                            fontSize: 16,
                          ),
                        )
                      : Text(
                          ("Station_offline").tr,
                          style: TextStyle(
                            color: Colors.red, // Red to indicate offline status
                            fontSize: 16,
                          ),
                        );
                }),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 50), // Add spacing before the text
                SizedBox(width: 5),
                Obx(() {
                  return customController.timeoftellecollect.value != ''
                      ? Text(
                          customController.timeoftellecollect.value,
                          style: TextStyle(
                            color: themeController.isDarkMode.value
                                ? Colors.white
                                : color, // Green to indicate online status
                            fontSize: 16,
                          ),
                        )
                      : Text(
                          DateTime.now().toString(),
                          style: TextStyle(
                            color: themeController.isDarkMode.value
                                ? Colors.white
                                : color, // Red to indicate offline status
                            fontSize: 16,
                          ),
                        );
                }),
              ],
            ),
            Row(
              children: [
                SizedBox(width: 50), // Add spacing before the text
                SizedBox(width: 5),
                Obx(
                  () => Text(
                    customController.config['station_code'] ?? '',
                    style: TextStyle(
                      color: themeController.isDarkMode.value
                          ? Colors.white
                          : color,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(200.0); // Custom height for AppBar
}
