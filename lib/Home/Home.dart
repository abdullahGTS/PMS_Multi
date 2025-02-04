import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pms/Home/Home_Controller.dart';

import '../CustomAppbar/CustomAppbar.dart';
import '../Footer/Footer.dart';
import '../Local/Local_Controller.dart';
import '../Shared/clock.dart';
import '../Shared/drawer.dart';
import '../Theme/Theme_Controller.dart';

class HomePage extends StatelessWidget {
  final homecontrol = Get.find<HomeController>();
  final TextEditingController _passwordController = TextEditingController();
  final Local = Get.find<LocalController>();
  var themeController = Get.find<ThemeController>();
  var color = Color.fromARGB(255, 24, 24, 24);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive padding for different screen sizes
    final horizontalPadding = screenWidth * 0.05; // 5% of the screen width
    final verticalPadding = screenHeight * 0.02; // 2% of the screen height
    return WillPopScope(
      onWillPop: () async {
        // Show the password dialog and return true only if the password is correct

        return await homecontrol.showExitPasswordDialog(context);
      },
      child: Obx(() {
        return Scaffold(
          // appBar: const CustomAppBar(),
          backgroundColor: themeController.isDarkMode.value
              ? Color(0xFF2B2B2B)
              : Color(0xFFE9ECEF),
          drawer: CustomDrawer(),
          body: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    themeController.isDarkMode.value
                        ? SizedBox()
                        : Positioned(
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
                                    topLeft: Radius.circular(
                                        10), // Top-left corner rounded
                                    topRight: Radius.circular(
                                        0), // Top-right corner not rounded
                                    bottomLeft: Radius.circular(
                                        0), // Bottom-left corner not rounded
                                    bottomRight: Radius.circular(0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      child: CustomAppBar(),
                      width: MediaQuery.of(context).size.width * 0.99,
                    ),
                    SizedBox(
                      height: 672,
                    ),
                    Positioned(
                      // right: 100,
                      // top: 0,
                      bottom: 0,
                      child: SizedBox(
                        child: FooterView(),
                        width: MediaQuery.of(context).size.width * 0.99,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        children: [
                          SizedBox(height: 220),
                          ClockContainer(),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // First Card - Total Transactions
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(screenWidth * 0.04),
                                    decoration: BoxDecoration(
                                      color: themeController.isDarkMode.value
                                          ? color
                                          : Colors.white.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            // Use Expanded to prevent overflow in this Row
                                            Expanded(
                                              child: Text(
                                                ("Transaction").tr,
                                                style: TextStyle(
                                                  color: themeController
                                                          .isDarkMode.value
                                                      ? Colors.white
                                                      : color,
                                                  fontSize: 19,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            // Use Expanded to prevent overflow in this Row

                                            Obx(
                                              () => Text(
                                                homecontrol.transnum.value
                                                    .toString(),
                                                style: TextStyle(
                                                  color: themeController
                                                          .isDarkMode.value
                                                      ? Colors.white
                                                      : color,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              (" ") + (" TRX").tr,
                                              style: TextStyle(
                                                color: themeController
                                                        .isDarkMode.value
                                                    ? Colors.white
                                                    : color,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(screenWidth * 0.04),
                                    decoration: BoxDecoration(
                                      color: themeController.isDarkMode.value
                                          ? color
                                          : Color(0x35576E38).withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            // Use Expanded to prevent overflow in this Row
                                            Expanded(
                                              child: Text(
                                                ("Amount").tr,
                                                style: TextStyle(
                                                  color: themeController
                                                          .isDarkMode.value
                                                      ? Colors.white
                                                      : color,
                                                  fontSize: 19,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            // Use Expanded to prevent overflow in this Row

                                            Obx(() => Text(
                                                  homecontrol.totalamount.value
                                                      .toString(),
                                                  style: TextStyle(
                                                    color: themeController
                                                            .isDarkMode.value
                                                        ? Colors.white
                                                        : color,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 17,
                                                  ),
                                                )),
                                            Text(
                                              (" ") + (" EGP").tr,
                                              style: TextStyle(
                                                color: themeController
                                                        .isDarkMode.value
                                                    ? Colors.white
                                                    : color,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(screenWidth * 0.04),
                                    decoration: BoxDecoration(
                                      color: themeController.isDarkMode.value
                                          ? color
                                          : Color(0xFFF25961).withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            // Use Expanded to prevent overflow in this Row
                                            Expanded(
                                              child: Text(
                                                ("Tips").tr,
                                                style: TextStyle(
                                                  color: themeController
                                                          .isDarkMode.value
                                                      ? Colors.white
                                                      : color,
                                                  fontSize: 19,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            // Use Expanded to prevent overflow in this Row

                                            Obx(
                                              () => Text(
                                                homecontrol.totaltips.value
                                                    .toString(),
                                                style: TextStyle(
                                                  color: themeController
                                                          .isDarkMode.value
                                                      ? Colors.white
                                                      : color,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              (" ") + (" EGP").tr,
                                              style: TextStyle(
                                                color: themeController
                                                        .isDarkMode.value
                                                    ? Colors.white
                                                    : color,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.all(screenWidth * 0.04),
                                    decoration: BoxDecoration(
                                      color: themeController.isDarkMode.value
                                          ? color
                                          : Colors.white.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            // Use Expanded to prevent overflow in this Row
                                            Expanded(
                                              child: Text(
                                                ("Total").tr,
                                                style: TextStyle(
                                                  color: themeController
                                                          .isDarkMode.value
                                                      ? Colors.white
                                                      : color,
                                                  fontSize: 19,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            // Use Expanded to prevent overflow in this Row

                                            Obx(
                                              () => Text(
                                                homecontrol.totalmoney.value
                                                    .toString(),
                                                style: TextStyle(
                                                  color: themeController
                                                          .isDarkMode.value
                                                      ? Colors.white
                                                      : color,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              (" ") + (" EGP").tr,
                                              style: TextStyle(
                                                color: themeController
                                                        .isDarkMode.value
                                                    ? Colors.white
                                                    : color,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // bottomNavigationBar: FooterView(),
        );
      }),

      // Add your other widgets here...
    );
  }
}
