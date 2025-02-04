import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../CustomAppbar/CustomAppbar.dart';
import '../Models/transactiontable.dart';
import '../ReportShifts/ReportShift_Controller.dart';
import '../Shared/drawer.dart';
import '../Theme/Theme_Controller.dart';

class Reportshift extends StatelessWidget {
  Reportshift({super.key});
  final shiftreprotController = Get.find<ReportshiftController>();
  var themeController = Get.find<ThemeController>();
  var color = Color.fromARGB(255, 24, 24, 24);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false; // Prevent navigation back
      },
      child: Obx(() {
        return Scaffold(
          backgroundColor: themeController.isDarkMode.value
              ? Color(0xFF2B2B2B)
              : Color(0xFFE9ECEF),
          drawer: CustomDrawer(),
          body: SingleChildScrollView(
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
                      'Report_shift'.tr,
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
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: 90),
                    SizedBox(
                      height: 100,
                      width: 200,
                      child: Image.asset(
                        'media/new_logo2.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              "Station_Name".tr +
                                  " :${shiftreprotController.customController.config['station_name']}",
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
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: shiftreprotController.shifts.value.length,
                          itemBuilder: (context, index) {
                            var shift =
                                shiftreprotController.shifts.value[index];
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, top: 10.0, right: 20),
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Shift_id".tr + ":",
                                            style: TextStyle(
                                              color: themeController
                                                      .isDarkMode.value
                                                  ? Colors.white
                                                  : color,
                                            ),
                                          ),
                                          Text(
                                            "${shift['shift_num']}",
                                            style: TextStyle(
                                              color: themeController
                                                      .isDarkMode.value
                                                  ? Colors.white
                                                  : color,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Supervisor".tr + ":",
                                            style: TextStyle(
                                              color: themeController
                                                      .isDarkMode.value
                                                  ? Colors.white
                                                  : color,
                                            ),
                                          ),
                                          Text(
                                            "${shift['supervisor']}",
                                            style: TextStyle(
                                              color: themeController
                                                      .isDarkMode.value
                                                  ? Colors.white
                                                  : color,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Start_Shift".tr + ":",
                                            style: TextStyle(
                                              color: themeController
                                                      .isDarkMode.value
                                                  ? Colors.white
                                                  : color,
                                            ),
                                          ),
                                          Text(
                                            "${shift['start_date']}",
                                            style: TextStyle(
                                              color: themeController
                                                      .isDarkMode.value
                                                  ? Colors.white
                                                  : color,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "End_Shift".tr + ":",
                                            style: TextStyle(
                                              color: themeController
                                                      .isDarkMode.value
                                                  ? Colors.white
                                                  : color,
                                            ),
                                          ),
                                          Text(
                                            shift['end_date']?.isNotEmpty ??
                                                    false
                                                ? "${shift['end_date']}"
                                                : "Not_Closed_until_now".tr,
                                            style: TextStyle(
                                              color: themeController
                                                      .isDarkMode.value
                                                  ? Colors.white
                                                  : color,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Total_Amount".tr + ":",
                                            style: TextStyle(
                                              color: themeController
                                                      .isDarkMode.value
                                                  ? Colors.white
                                                  : color,
                                            ),
                                          ),
                                          Text(
                                            "${shift['total_amount'].toStringAsFixed(2)}",
                                            style: TextStyle(
                                              color: themeController
                                                      .isDarkMode.value
                                                  ? Colors.white
                                                  : color,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Total_Tips".tr + ":",
                                            style: TextStyle(
                                              color: themeController
                                                      .isDarkMode.value
                                                  ? Colors.white
                                                  : color,
                                            ),
                                          ),
                                          Text(
                                            "${shift['total_tips'].toStringAsFixed(2)}",
                                            style: TextStyle(
                                              color: themeController
                                                      .isDarkMode.value
                                                  ? Colors.white
                                                  : color,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Total_Money".tr + ":",
                                            style: TextStyle(
                                              color: themeController
                                                      .isDarkMode.value
                                                  ? Colors.white
                                                  : color,
                                            ),
                                          ),
                                          Text(
                                            "${shift['total'].toStringAsFixed(2)}",
                                            style: TextStyle(
                                              color: themeController
                                                      .isDarkMode.value
                                                  ? Colors.white
                                                  : color,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Status".tr + ":",
                                            style: TextStyle(
                                              color: themeController
                                                      .isDarkMode.value
                                                  ? Colors.white
                                                  : color,
                                            ),
                                          ),
                                          Text(
                                            ("${shift['status']}").tr,
                                            style: TextStyle(
                                              color: themeController
                                                      .isDarkMode.value
                                                  ? Colors.white
                                                  : color,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    ElevatedButton(
                      onPressed: shiftreprotController.printReceipt,
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
