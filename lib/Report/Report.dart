import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../CustomAppbar/CustomAppbar.dart';
import '../Local/Local_Controller.dart';
import '../Shared/drawer.dart';
import '../Theme/Theme_Controller.dart';
import 'Report_Controller.dart';
import 'package:intl/intl.dart';

class Report extends StatelessWidget {
  Report({super.key});
  final reprotController = Get.find<ReportController>();
  final localController = Get.find<LocalController>();
  var themeController = Get.find<ThemeController>();
  var color = Color.fromARGB(255, 24, 24, 24);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Obx(() {
        return Scaffold(
          // appBar: AppBar(
          //   title: Text(
          //     'Report_Transactions'.tr,
          //     style: TextStyle(
          //       color: themeController.isDarkMode.value ? Colors.white : color,
          //     ),
          //   ),
          //   backgroundColor: themeController.isDarkMode.value
          //       ? Color(0xFF2B2B2B)
          //       : Color(0xFFE9ECEF),
          //   iconTheme: IconThemeData(
          //       color: themeController.isDarkMode.value
          //           ? Colors.white
          //           : color, // Change Drawer icon color to white
          //       size: 40),
          //   // Customize the AppBar color
          // ),
          backgroundColor: themeController.isDarkMode.value
              ? Color(0xFF2B2B2B)
              : Color(0xFFE9ECEF),
          drawer: CustomDrawer(),
          body: SingleChildScrollView(
            // Wrap the body with SingleChildScrollView
            child: Stack(
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
                          topLeft:
                              Radius.circular(10), // Top-left corner rounded
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
                  child: AppBar(
                    title: Text(
                      'Report_Transactions'.tr,
                      style: TextStyle(
                        color: themeController.isDarkMode.value
                            ? Colors.white
                            : color,
                      ),
                    ),
                    backgroundColor: themeController.isDarkMode.value
                        ? Color(0xFF2B2B2B)
                        : Color(0xFFE9ECEF),
                    iconTheme: IconThemeData(
                        color: themeController.isDarkMode.value
                            ? Colors.white
                            : color, // Change Drawer icon color to white
                        size: 40),
                    // Customize the AppBar color
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: 90),
                    SizedBox(
                      height: 100,
                      width: 200,
                      child: Image.asset(
                        'media/new_logo2.png', // Path to your image
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Vertically center the content
                        crossAxisAlignment: CrossAxisAlignment
                            .center, // Horizontally center the content
                        children: [
                          Text(
                              "Station_Name".tr +
                                  " : ${reprotController.customController.config['station_name']}",
                              style: TextStyle(
                                color: themeController.isDarkMode.value
                                    ? Colors.white
                                    : color,
                              )),
                          // const Text("Egypt, Cairo",
                          //     style: TextStyle(color: Colors.white)),
                          Text(
                            "${DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now())}",
                            style: TextStyle(
                              color: themeController.isDarkMode.value
                                  ? Colors.white
                                  : color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Obx(
                      () {
                        return ListView.builder(
                          shrinkWrap:
                              true, // Ensures the ListView takes only as much space as needed
                          physics:
                              NeverScrollableScrollPhysics(), // Disables internal scrolling of the ListView
                          itemCount:
                              reprotController.groupedTransactions.length,
                          itemBuilder: (context, index) {
                            // Get the current group (pumpNo)
                            final pumpNo = reprotController
                                .groupedTransactions.keys
                                .elementAt(index);
                            final data =
                                reprotController.groupedTransactions[pumpNo];

                            // Check if data is null
                            if (data == null) {
                              return SizedBox
                                  .shrink(); // Return an empty widget if data is null
                            }

                            // Get the summarized data for this group
                            final transactionCount =
                                data['transactionCount'] ?? 0;
                            final totalAmount = data['totalAmount'] ?? 0.0;
                            final totalTips = data['totalTips'] ?? 0.0;
                            print(
                                'transactionCount->>>>>>>>>>${transactionCount}');
                            print('totalAmount->>>>>>>>>>${totalAmount}');
                            print('totalTips->>>>>>>>>>${totalTips}');

                            return Padding(
                              padding: localController
                                          .getCurrentLang()
                                          ?.languageCode ==
                                      "ar"
                                  ? EdgeInsets.only(right: 20.0, top: 10.0)
                                  : EdgeInsets.only(left: 20.0, top: 10.0),
                              child: Column(
                                children: [
                                  // Displaying pump details
                                  Row(
                                    children: [
                                      Text(
                                        "Pump_No".tr + ":" + " ",
                                        style: TextStyle(
                                          color:
                                              themeController.isDarkMode.value
                                                  ? Colors.white
                                                  : color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "$pumpNo",
                                        style: TextStyle(
                                          color:
                                              themeController.isDarkMode.value
                                                  ? Colors.white
                                                  : color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "Number_of_Transactions".tr + ": ",
                                        style: TextStyle(
                                          color:
                                              themeController.isDarkMode.value
                                                  ? Colors.white
                                                  : color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "$transactionCount",
                                        style: TextStyle(
                                          color:
                                              themeController.isDarkMode.value
                                                  ? Colors.white
                                                  : color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "Total_Amount".tr + ":",
                                        style: TextStyle(
                                          color:
                                              themeController.isDarkMode.value
                                                  ? Colors.white
                                                  : color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${totalAmount.toStringAsFixed(2)}",
                                        style: TextStyle(
                                          color:
                                              themeController.isDarkMode.value
                                                  ? Colors.white
                                                  : color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        "Total_Tips".tr + ": ",
                                        style: TextStyle(
                                          color:
                                              themeController.isDarkMode.value
                                                  ? Colors.white
                                                  : color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${totalTips.toStringAsFixed(2)}",
                                        style: TextStyle(
                                          color:
                                              themeController.isDarkMode.value
                                                  ? Colors.white
                                                  : color,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Total_Amount".tr + ": ",
                            style: TextStyle(
                              color: themeController.isDarkMode.value
                                  ? Colors.white
                                  : color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${reprotController.totalAmount.value.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: themeController.isDarkMode.value
                                  ? Colors.white
                                  : color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Total_Tips".tr + ": ",
                            style: TextStyle(
                              color: themeController.isDarkMode.value
                                  ? Colors.white
                                  : color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${reprotController.totalTipsAmount.value.toStringAsFixed(2)}",
                            style: TextStyle(
                              color: themeController.isDarkMode.value
                                  ? Colors.white
                                  : color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "Totals".tr + ": ",
                            style: TextStyle(
                              color: themeController.isDarkMode.value
                                  ? Colors.white
                                  : color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${(reprotController.totalAmount.value + reprotController.totalTipsAmount.value).toStringAsFixed(2)}",
                            style: TextStyle(
                              color: themeController.isDarkMode.value
                                  ? Colors.white
                                  : color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: reprotController
                          .printReceipt, // Call printReceipt on button press
                      child: Text(
                        "Print_Receipt".tr,
                        style: TextStyle(
                          color: themeController.isDarkMode.value
                              ? Colors.white
                              : color,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
