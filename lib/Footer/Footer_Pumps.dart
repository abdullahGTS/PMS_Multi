// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../CustomAppbar/CustomAppbar_Controller.dart';
import '../Theme/Theme_Controller.dart';

class FooterPumpsView extends StatelessWidget {
  var pumps = "";
  var themeController = Get.find<ThemeController>();
  var color = Color.fromARGB(255, 24, 24, 24);
  final customController = Get.find<CustomAppbarController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          // height: 30,
          right: 0,
          left: 0,
          top: 60,
          bottom: 0,
          // left: 0,
          child: Container(
            color: themeController.isDarkMode.value
                ? color
                : Color(0x35576E38).withOpacity(0.6),
          ),
        ),
        Container(
          color: Colors.white.withOpacity(0),
          width: double.infinity,
          padding: const EdgeInsets.all(16.0), // Add padding if needed
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center the content in the Row
            children: [
              GestureDetector(
                onTap: () {
                  // Navigate to the verification page
                  // Navigator.pushNamed(context, '/verify');
                  if (customController.issupervisormaiar.value) {
                    customController.issupervisormaiar.value = false;
                    Get.offAllNamed("/Mair");
                  } else {
                    Get.toNamed("/verify");
                  }
                },
                child: _buildCircleIcon(Icons.arrow_back_rounded,
                    Colors.white), // Fuel on the right
              ),
              const Spacer(), // Spacer to push the logo to the center
              _buildCircleImage('media/new_logo.png'), // New logo in the center
              const Spacer(), // Spacer to push the fuel icon to the right
              GestureDetector(
                onTap: () async {
                  Get.snackbar(
                    ('Pumps_Alert').tr,
                    ("click_on_pump_to_know_its_status").tr,
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                },
                child: _buildCircleIcon(
                    Icons.payments_rounded, Colors.white), // Fuel on the right
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircleImage(String assetPath) {
    return Container(
      padding: const EdgeInsets.all(
          10.0), // Add 10 pixels of padding for the circular container
      decoration: BoxDecoration(
        color: themeController.isDarkMode.value
            ? color
            : Colors.white
                .withOpacity(0.5), // Background color for the circular area
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: Colors.white.withOpacity(0.3),
              offset: Offset(0, 8),
              blurRadius: 3,
              spreadRadius: 0)
        ], // Makes the container circular
      ),
      child: Container(
        width: 60, // Set width
        height: 60, // Set height
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Keeps the image circular
          image: DecorationImage(
            image: AssetImage(assetPath), // Path to the image
            fit: BoxFit
                .contain, // Ensures the entire image fits within the circle
          ),
        ),
      ),
    );
  }

  Widget _buildCircleIcon(IconData iconData, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(
          10.0), // Add 10 pixels of padding for the circular container
      decoration: BoxDecoration(
        color: themeController.isDarkMode.value
            ? color
            : Colors.white
                .withOpacity(0.5), // Background color for the circular area
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: Colors.white.withOpacity(0.3),
              offset: Offset(0, 8),
              blurRadius: 3,
              spreadRadius: 0)
        ], // Makes the container circular
      ),
      child: Container(
        width: 60, // Set width
        height: 60, // Set height
        decoration: BoxDecoration(
          shape: BoxShape.circle, // Keeps the image circular
        ),
        child: Icon(
          iconData, // The icon to display
          color: themeController.isDarkMode.value
              ? Colors.white
              : Color(0x35576E38).withOpacity(0.9), // Color of the icon
          size: 50.0, // Adjust size as needed
        ),
      ),
    );
  }
}
