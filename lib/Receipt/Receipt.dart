// ignore_for_file: file_names, avoid_print, use_key_in_widget_constructors, prefer_interpolation_to_compose_strings, unnecessary_string_interpolations, deprecated_member_use, avoid_unnecessary_containers, use_build_context_synchronously, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_pax_printer_utility/flutter_pax_printer_utility.dart';

import '../Theme/Theme_Controller.dart';
import 'Receipt_Controller.dart';

class Receipt extends StatelessWidget {
  // Assuming these values are passed from the previous screen

  @override
  Widget build(BuildContext context) {
    final receiptController = Get.find<ReceiptController>();
    var themeController = Get.find<ThemeController>();
    var color = Color.fromARGB(255, 24, 24, 24);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Obx(() {
        return Scaffold(
          backgroundColor: themeController.isDarkMode.value
              ? Color(0xFF2B2B2B)
              : Color(0xFFE9ECEF),
          appBar: AppBar(
            title: Text(
              'Client_Receipt'.tr,
              style: TextStyle(
                color: themeController.isDarkMode.value ? Colors.white : color,
              ),
            ),
            backgroundColor: themeController.isDarkMode.value
                ? Color(0xFF2B2B2B)
                : Color(0xFFE9ECEF), // Customize the AppBar color
          ),
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5.0, left: 50.0, right: 50.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        // Logo in the center
                        SizedBox(
                          height: 70,
                          width: 100,
                          child: Image.asset(
                            'media/new_logo.png', // Path to your image
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
                              Text("Station_Name".tr,
                                  style: TextStyle(
                                    color: themeController.isDarkMode.value
                                        ? Colors.white
                                        : color,
                                  )),
                              // Text("Egypt, Cairo",
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

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Transaction_Seq_No'.tr + ':' + ' ',
                                style: TextStyle(
                                  color: themeController.isDarkMode.value
                                      ? Colors.white
                                      : color,
                                )),
                            Text(
                                "${receiptController.customController.transactionSeqNo.value}",
                                style: TextStyle(
                                  color: themeController.isDarkMode.value
                                      ? Colors.white
                                      : color,
                                ))
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Pump_No'.tr + ':' + ' ',
                                style: TextStyle(
                                  color: themeController.isDarkMode.value
                                      ? Colors.white
                                      : color,
                                )),
                            Text(
                                '${receiptController.customController.pumpNo.value}',
                                style: TextStyle(
                                  color: themeController.isDarkMode.value
                                      ? Colors.white
                                      : color,
                                )),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Nozzle_No'.tr + ':' + ' ',
                                style: TextStyle(
                                  color: themeController.isDarkMode.value
                                      ? Colors.white
                                      : color,
                                )),
                            Text(
                                '${receiptController.customController.nozzleNo.value}',
                                style: TextStyle(
                                  color: themeController.isDarkMode.value
                                      ? Colors.white
                                      : color,
                                )),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Product_No'.tr + ':' + ' ',
                                style: TextStyle(
                                  color: themeController.isDarkMode.value
                                      ? Colors.white
                                      : color,
                                )),
                            Text(
                                '${receiptController.customController.productNo1.value}',
                                style: TextStyle(
                                  color: themeController.isDarkMode.value
                                      ? Colors.white
                                      : color,
                                )),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Product_Name'.tr + ':' + ' ',
                                style: TextStyle(
                                  color: themeController.isDarkMode.value
                                      ? Colors.white
                                      : color,
                                )),
                            Text(
                                receiptController.customController
                                        .getProductName(int.parse(
                                            receiptController.customController
                                                .productNo.value))
                                        .toString()
                                        .tr ??
                                    'No_product'.tr,
                                style: TextStyle(
                                  color: themeController.isDarkMode.value
                                      ? Colors.white
                                      : color,
                                )),
                          ],
                        ),
                        const SizedBox(height: 10),

                        Obx(() {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Payment_Type'.tr + '  : ',
                                  style: TextStyle(
                                    color: themeController.isDarkMode.value
                                        ? Colors.white
                                        : color,
                                  )),
                              Text(
                                  '${(receiptController.paymentTypeName.value).tr}',
                                  style: TextStyle(
                                    color: themeController.isDarkMode.value
                                        ? Colors.white
                                        : color,
                                  )),
                            ],
                          );
                        }),
                        const SizedBox(height: 10),

                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text('Transaction By : ',
                        //         style: TextStyle(color: Colors.white)),
                        //     (receiptController
                        //             .customController.trxAttendant.value.isNotEmpty)
                        //         ? Text(
                        //             receiptController
                        //                 .customController.trxAttendant.value,
                        //             style: TextStyle(color: Colors.white))
                        //         : Text(
                        //             receiptController
                        //                 .customController.managershift.value,
                        //             style: TextStyle(color: Colors.white)),
                        //   ],
                        // ),
                        receiptController
                                .customController.issupervisormaiar.value
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Calibration'.tr + ' :',
                                      style: TextStyle(
                                        color: themeController.isDarkMode.value
                                            ? Colors.white
                                            : color,
                                      )),
                                  Text(
                                    receiptController
                                        .customController.managershift.value,
                                    style: TextStyle(
                                      color: themeController.isDarkMode.value
                                          ? Colors.white
                                          : color,
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Transaction_By'.tr + '  :',
                                      style: TextStyle(
                                        color: themeController.isDarkMode.value
                                            ? Colors.white
                                            : color,
                                      )),
                                  Text(
                                    receiptController
                                        .customController.trxAttendant.value,
                                    style: TextStyle(
                                      color: themeController.isDarkMode.value
                                          ? Colors.white
                                          : color,
                                    ),
                                  ),
                                ],
                              ),

                        const Divider(),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total_Amount_reciept'.tr + ' : ',
                              style: TextStyle(
                                  color: themeController.isDarkMode.value
                                      ? Colors.white
                                      : color,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${receiptController.customController.amountVal.value.toStringAsFixed(2)} ' +
                                  'EGP'.tr,
                              style: TextStyle(
                                  color: themeController.isDarkMode.value
                                      ? Colors.white
                                      : color,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Volume:'.tr + ' ',
                              style: TextStyle(
                                  color: themeController.isDarkMode.value
                                      ? Colors.white
                                      : color,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              ' ${receiptController.customController.volume.value.toStringAsFixed(2)} ' +
                                  'LTR'.tr,
                              style: TextStyle(
                                  color: themeController.isDarkMode.value
                                      ? Colors.white
                                      : color,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Unit_Price:'.tr + ' ',
                                style: TextStyle(
                                    color: themeController.isDarkMode.value
                                        ? Colors.white
                                        : color,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                '${receiptController.customController.unitPrice.value.toStringAsFixed(2)} ' +
                                    'EGP'.tr,
                                style: TextStyle(
                                    color: themeController.isDarkMode.value
                                        ? Colors.white
                                        : color,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),

                        const SizedBox(height: 5),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total_reciept'.tr + ': ',
                              style: TextStyle(
                                  color: themeController.isDarkMode.value
                                      ? Colors.white
                                      : color,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${receiptController.customController.amountVal.value.toStringAsFixed(2)} ' +
                                  'EGP'.tr,
                              style: TextStyle(
                                  color: themeController.isDarkMode.value
                                      ? Colors.white
                                      : color,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            await receiptController.printReceipt();
                          }, // Call printReceipt on button press
                          child: Text(
                            "Print_Receipt".tr,
                            style: TextStyle(
                              color: themeController.isDarkMode.value
                                  ? Colors.white
                                  : color,
                            ),
                          ),
                        ),
                        // ElevatedButton(
                        //   onPressed: () async {
                        //     // First, try to open the app using the URL scheme
                        //     if (await canLaunch(bmPaymentAppScheme)) {
                        //       await launch(bmPaymentAppScheme);
                        //     }
                        //     // If that fails, try using the package name for Android
                        //     else if (await canLaunch("intent://$bmPaymentAppPackage")) {
                        //       await launch("intent://$bmPaymentAppPackage");
                        //     } else {
                        //       // Show an error if the app is not installed
                        //       ScaffoldMessenger.of(context).showSnackBar(
                        //         const SnackBar(
                        //             content: Text("BM Payment app is not installed.")),
                        //       );
                        //     }
                        //   }, // Wrap the function call in a closure
                        //   // Call printReceipt on button press
                        //   child: const Text("Bank"),
                        // ),
                        // Unit Price and Blend Ratio in the second row

                        // Volume Product 1 and Volume Product 2 in the same row
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
