import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Theme/Theme_Controller.dart';

class FooterAvailabletrxdetails extends StatelessWidget {
  var themeController = Get.find<ThemeController>();
  var color = Color.fromARGB(255, 24, 24, 24);

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
          // width: double.infinity,
          padding: const EdgeInsets.all(16.0), // Add padding if needed
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center the content in the Row
            children: [
              GestureDetector(
                onTap: () {
                  // Navigate to the verification page
                  // ScaffoldMessenger.of(context).showSnackBar(
                  //   const SnackBar(
                  //       content: Text(
                  //           'you can not back while fueling is in progress !!')),
                  // );
                  Get.back();
                },
                child: _buildCircleIcon(Icons.arrow_back_rounded, Colors.white),
                // Fuel on the right
              ),
              const Spacer(), // Spacer to push the logo to the center
              _buildCircleImage('media/new_logo.png'), // New logo in the center
              const Spacer(), // Spacer to push the fuel icon to the right
              GestureDetector(
                onTap: () {
                  // Navigate to the verification page
                  Get.snackbar(
                    'Payment_Alert'.tr,
                    "sorry".tr +
                        ", " +
                        "you_have_to_choose_a_payment_method".tr,
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                },
                child: _buildCircleIcon(Icons.mobile_friendly_rounded,
                    Colors.white), // Fuel on the right
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
        boxShadow: [
          BoxShadow(
              color: Colors.white.withOpacity(0.3),
              offset: Offset(0, 8),
              blurRadius: 3,
              spreadRadius: 0)
        ],
        color: themeController.isDarkMode.value
            ? color
            : Colors.white
                .withOpacity(0.5), // Background color for the circular area
        shape: BoxShape.circle, // Makes the container circular
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
        boxShadow: [
          BoxShadow(
              color: Colors.white.withOpacity(0.3),
              offset: Offset(0, 8),
              blurRadius: 3,
              spreadRadius: 0)
        ],
        color: themeController.isDarkMode.value
            ? color
            : Colors.white
                .withOpacity(0.5), // Background color for the circular area
        shape: BoxShape.circle, // Makes the container circular
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
