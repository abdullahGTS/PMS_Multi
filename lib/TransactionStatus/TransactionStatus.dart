import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../CustomAppbar/CustomAppbar.dart';
import '../Footer/Footer_AvailableTrxDetails.dart';
import '../Footer/Footer_TrxStatus.dart';
import '../Shared/drawer.dart';
import '../Theme/Theme_Controller.dart';
import 'TransactionStatus_Controller.dart';

class TransactionStatus extends StatelessWidget {
  TransactionStatus({super.key});
  final transactionStatusController = Get.put(TransactionStatusController());
  var themeController = Get.find<ThemeController>();
  var color = Color.fromARGB(255, 24, 24, 24);

  @override
  Widget build(BuildContext context) {
    // Initialize the PaymentController

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Obx(() {
        return Scaffold(
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () async {
          //     await transactionStatusController.dbHelper.updateTrxStatus("1");
          //   },
          //   child: Text("data"),
          // ),
          backgroundColor: themeController.isDarkMode.value
              ? Color(0xFF2B2B2B)
              : Color(0xFFE9ECEF),
          // appBar: const CustomAppBar(),
          drawer: CustomDrawer(),
          body: Obx(() {
            return transactionStatusController.AvailableTrxList.isEmpty
                ? transactionStatusController.NoAvailableTrx.value != ""
                    ? Stack(
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
                          Positioned(
                            // right: 100,
                            // top: 0,
                            bottom: 0,
                            child: SizedBox(
                              child: FooterTrxStatus(),
                              width: MediaQuery.of(context).size.width * 0.99,
                            ),
                          ),
                          SizedBox(
                            child: Center(
                                child: Padding(
                              padding: const EdgeInsets.only(top: 170.0),
                              child: Text(
                                "${transactionStatusController.NoAvailableTrx.value}",
                                style: TextStyle(
                                    color: themeController.isDarkMode.value
                                        ? Colors.white.withOpacity(0.5)
                                        : color,
                                    fontSize: 24),
                              ),
                            )),
                          ),
                        ],
                      )
                    : Center(
                        child: CircularProgressIndicator(
                          color: themeController.isDarkMode.value
                              ? Colors.white.withOpacity(0.5)
                              : color,
                        ),
                      )
                : Stack(
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
                          child: FooterTrxStatus(),
                          width: MediaQuery.of(context).size.width * 0.99,
                        ),
                      ),
                      ListView.builder(
                        itemCount: transactionStatusController
                            .AvailableTrxList[0].length,
                        itemBuilder: (context, index) {
                          final transaction = transactionStatusController
                              .AvailableTrxList[0][index];
                          return Padding(
                            padding: const EdgeInsets.only(top: 185.0),
                            child: Card(
                              color: themeController.isDarkMode.value
                                  ? Color(0xED166E36)
                                  : Colors.white.withOpacity(0.8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 5,
                              child: Column(
                                children: [
                                  Row(children: [
                                    Expanded(
                                      // flex: 4,
                                      child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Icon(
                                                              Icons
                                                                  .local_gas_station,
                                                              color: themeController
                                                                      .isDarkMode
                                                                      .value
                                                                  ? Colors.white
                                                                      .withOpacity(
                                                                          0.8)
                                                                  : color,
                                                              size: 20,
                                                            )),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                            flex: 4,
                                                            child: Text(
                                                              "Pump".tr +
                                                                  " ${transaction['PumpNo']}",
                                                              style: TextStyle(
                                                                color: themeController
                                                                        .isDarkMode
                                                                        .value
                                                                    ? Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.8)
                                                                    : color,
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Icon(
                                                              Icons
                                                                  .water_drop_rounded,
                                                              color: themeController
                                                                      .isDarkMode
                                                                      .value
                                                                  ? Colors.white
                                                                      .withOpacity(
                                                                          0.8)
                                                                  : color,
                                                              size: 20,
                                                            )),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                            flex: 4,
                                                            child: Text(
                                                              ("${transaction['ProductName']}"
                                                                  .tr),
                                                              style: TextStyle(
                                                                color: themeController
                                                                        .isDarkMode
                                                                        .value
                                                                    ? Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.8)
                                                                    : color,
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Icon(
                                                              Icons
                                                                  .pending_actions_rounded,
                                                              color: themeController
                                                                      .isDarkMode
                                                                      .value
                                                                  ? Colors.white
                                                                      .withOpacity(
                                                                          0.8)
                                                                  : color,
                                                              size: 20,
                                                            )),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                            flex: 4,
                                                            child: Text(
                                                              "State".tr +
                                                                  ' ' +
                                                                  "${(transaction['State'])}"
                                                                      .tr,
                                                              style: TextStyle(
                                                                color: themeController
                                                                        .isDarkMode
                                                                        .value
                                                                    ? Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.8)
                                                                    : color,
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Icon(
                                                              Icons
                                                                  .local_gas_station,
                                                              color: themeController
                                                                      .isDarkMode
                                                                      .value
                                                                  ? Colors.white
                                                                      .withOpacity(
                                                                          0.8)
                                                                  : color,
                                                              size: 20,
                                                            )),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                            flex: 4,
                                                            child: Text(
                                                              "Nozzle".tr +
                                                                  " ${transaction['NozzleNo']}",
                                                              style: TextStyle(
                                                                color: themeController
                                                                        .isDarkMode
                                                                        .value
                                                                    ? Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.8)
                                                                    : color,
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Icon(
                                                              Icons
                                                                  .numbers_rounded,
                                                              color: themeController
                                                                      .isDarkMode
                                                                      .value
                                                                  ? Colors.white
                                                                      .withOpacity(
                                                                          0.8)
                                                                  : color,
                                                              size: 20,
                                                            )),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                            flex: 4,
                                                            child: Text(
                                                              "TRX".tr +
                                                                  " ${transaction['TransactionSeqNo']}",
                                                              style: TextStyle(
                                                                color: themeController
                                                                        .isDarkMode
                                                                        .value
                                                                    ? Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0.8)
                                                                    : color,
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    Row(
                                                      children: [],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )),
                                    ),
                                  ]),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 10.0,
                                            bottom: 10.0),
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              await transactionStatusController
                                                  .TransactionDetails(
                                                      transaction[
                                                          'TransactionSeqNo']);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF2B2B2B),
                                            ),
                                            child: Text(
                                              'Details'.tr,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )),
                                      )),
                                    ],
                                  ),
                                  //   Row(
                                  //     children: [
                                  //       Expanded(
                                  //         child: transaction['payment_type'] ==
                                  //                 'Bank'
                                  //             ? transaction['statusvoid'] ==
                                  //                     "complete"
                                  //                 ? Padding(
                                  //                     padding: const EdgeInsets
                                  //                         .symmetric(
                                  //                         horizontal: 20,
                                  //                         vertical: 5),
                                  //                     child: ElevatedButton(
                                  //                       style: ElevatedButton
                                  //                           .styleFrom(
                                  //                         backgroundColor:
                                  //                             const Color(
                                  //                                 0xFF2B2B2B),
                                  //                       ),
                                  //                       onPressed: () {
                                  //                         alltransController
                                  //                             .showVoidConfirmationDialog(
                                  //                           context,
                                  //                           transaction[
                                  //                               'Stannumber'],
                                  //                           double.parse(
                                  //                               transaction[
                                  //                                   'amount']),
                                  //                           transaction[
                                  //                               'transactionSeqNo'],
                                  //                         );
                                  //                       },
                                  //                       child: const Text(
                                  //                         "Void",
                                  //                         style: TextStyle(
                                  //                             color: Colors.white),
                                  //                       ),
                                  //                     ),
                                  //                   )
                                  //                 : transaction['statusvoid'] ==
                                  //                         "progress"
                                  //                     ? Padding(
                                  //                         padding: const EdgeInsets
                                  //                             .symmetric(
                                  //                             horizontal: 20,
                                  //                             vertical: 5),
                                  //                         child: ElevatedButton(
                                  //                           style: ElevatedButton
                                  //                               .styleFrom(
                                  //                             backgroundColor:
                                  //                                 const Color(
                                  //                                     0xFF2B2B2B),
                                  //                           ),
                                  //                           onPressed: () {
                                  //                             // Initialize the PreSaleValueController

                                  //                             // Navigate to the /ChoosePaymentaftervoid page and pass presalecontroller.value as an argument
                                  //                             alltransController
                                  //                                 .resetTransaction(
                                  //                                     transaction);
                                  //                             Get.toNamed(
                                  //                                 '/ResetPayment');
                                  //                           },
                                  //                           child: const Text(
                                  //                             "Set Transaction", // Or any other label you'd prefer
                                  //                             style: TextStyle(
                                  //                                 color:
                                  //                                     Colors.white),
                                  //                           ),
                                  //                         ),
                                  //                       )
                                  //                     : SizedBox()
                                  //             : SizedBox(),
                                  //       )
                                  //     ],
                                  //   ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  );

            // Stop loading and show actual content when condition is met
            // return
            // Container(
            //   padding: const EdgeInsets.only(
            //       top: 20.0,
            //       right: 5.0,
            //       left: 5.0), // No padding around the content
            //   child: Center(
            //     child: transactionStatusController.TrxDetailsList.length <= 0
            //         ? Center(
            //             child: Text(
            //             "No Transcations Pending",
            //             style: TextStyle(color: Colors.white, fontSize: 24),
            //           ))
            //         : ListView.builder(
            //             itemCount:
            //                 transactionStatusController.TrxDetailsList.length,
            //             itemBuilder: (context, index) {
            //               final transaction =
            //                   transactionStatusController.TrxDetailsList[index];
            //               print(
            //                   "transactionStatusController.TrxDetailsList.length${transactionStatusController.TrxDetailsList.length}");
            //               return Card(
            //                 color: transaction['status'] == "pending"
            //                     ? Color.fromARGB(255, 24, 24, 24)
            //                     : Color(0xFF166E36), // Card color
            //                 child: Padding(
            //                   padding: const EdgeInsets.only(
            //                       top: 20.0,
            //                       right: 10,
            //                       left: 10,
            //                       bottom: 10), // Padding inside the card
            //                   child: Column(
            //                     mainAxisAlignment:
            //                         MainAxisAlignment.center, // Center vertically
            //                     crossAxisAlignment: CrossAxisAlignment
            //                         .center, // Center horizontally
            //                     children: [
            //                       Row(
            //                         children: [
            //                           Expanded(
            //                             flex: 1,
            //                             child: Row(
            //                               children: [
            //                                 Expanded(
            //                                     flex: 1,
            //                                     child: Align(
            //                                       alignment: Alignment.centerLeft,
            //                                       child: Icon(
            //                                         Icons.calendar_month_rounded,
            //                                         color: Colors.white,
            //                                         size: 20,
            //                                       ),
            //                                     )),
            //                                 Expanded(
            //                                   flex: 4,
            //                                   child: Align(
            //                                     alignment: Alignment.centerLeft,
            //                                     child: Text(
            //                                       "Start_Date".tr,
            //                                       style: TextStyle(
            //                                           color: Colors.white,
            //                                           fontSize: 16),
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ],
            //                             ),
            //                           ),
            //                           Expanded(
            //                             flex: 2,
            //                             child: Align(
            //                               alignment: Alignment.centerRight,
            //                               child: Text(
            //                                   "${transaction['timeStamp']}",
            //                                   style: TextStyle(
            //                                       color: Colors.white,
            //                                       fontSize: 16)),
            //                             ),
            //                           )
            //                         ],
            //                       ),
            //                       SizedBox(height: 10),
            //                       Row(
            //                         children: [
            //                           Expanded(
            //                             child: Row(
            //                               children: [
            //                                 Expanded(
            //                                     flex: 1,
            //                                     child: Icon(
            //                                       Icons.local_gas_station,
            //                                       color: Colors.white,
            //                                       size: 20,
            //                                     )),
            //                                 SizedBox(
            //                                   width: 5,
            //                                 ),
            //                                 Expanded(
            //                                     flex: 4,
            //                                     child: Text(
            //                                       "Pump".tr +
            //                                           " ${transaction['pumpNo']}",
            //                                       style: TextStyle(
            //                                           color: Colors.white),
            //                                     )),
            //                               ],
            //                             ),
            //                           ),
            //                           Expanded(
            //                             child: Row(
            //                               children: [
            //                                 Expanded(
            //                                     flex: 1,
            //                                     child: Icon(
            //                                       Icons.local_gas_station,
            //                                       color: Colors.white,
            //                                       size: 20,
            //                                     )),
            //                                 SizedBox(
            //                                   width: 5,
            //                                 ),
            //                                 Expanded(
            //                                     flex: 4,
            //                                     child: Text(
            //                                       "Nozzle".tr +
            //                                           " ${transaction['nozzleNo']}",
            //                                       style: TextStyle(
            //                                           color: Colors.white),
            //                                     )),
            //                               ],
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       SizedBox(height: 10),
            //                       Row(
            //                         children: [
            //                           Expanded(
            //                             child: Row(
            //                               children: [
            //                                 Expanded(
            //                                     flex: 1,
            //                                     child: Icon(
            //                                       Icons.water_drop_rounded,
            //                                       color: Colors.white,
            //                                       size: 20,
            //                                     )),
            //                                 SizedBox(
            //                                   width: 5,
            //                                 ),
            //                                 Expanded(
            //                                     flex: 4,
            //                                     child: Text(
            //                                       "${transaction['productName']}",
            //                                       style: TextStyle(
            //                                           color: Colors.white),
            //                                     )),
            //                               ],
            //                             ),
            //                           ),
            //                           Expanded(
            //                             child: Row(
            //                               children: [
            //                                 Expanded(
            //                                     flex: 1,
            //                                     child: Icon(
            //                                       Icons.numbers_rounded,
            //                                       color: Colors.white,
            //                                       size: 20,
            //                                     )),
            //                                 SizedBox(
            //                                   width: 5,
            //                                 ),
            //                                 Expanded(
            //                                     flex: 4,
            //                                     child: Text(
            //                                       "TRX".tr +
            //                                           " ${transaction['transactionSeqNo']}",
            //                                       style: TextStyle(
            //                                           color: Colors.white),
            //                                     )),
            //                               ],
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       SizedBox(height: 10),
            //                       Row(
            //                         children: [
            //                           Expanded(
            //                             child: Row(
            //                               children: [
            //                                 Expanded(
            //                                     flex: 1,
            //                                     child: Icon(
            //                                       Icons.payments_outlined,
            //                                       color: Colors.white,
            //                                       size: 20,
            //                                     )),
            //                                 SizedBox(
            //                                   width: 5,
            //                                 ),
            //                                 Expanded(
            //                                     flex: 4,
            //                                     child: Text(
            //                                       "T/A".tr +
            //                                           " ${transaction['amount']} EGP",
            //                                       style: TextStyle(
            //                                           color: Colors.white),
            //                                     )),
            //                               ],
            //                             ),
            //                           ),
            //                           Expanded(
            //                             child: Row(
            //                               children: [
            //                                 Expanded(
            //                                     flex: 1,
            //                                     child: Icon(
            //                                       Icons.payments_outlined,
            //                                       color: Colors.white,
            //                                       size: 20,
            //                                     )),
            //                                 SizedBox(
            //                                   width: 5,
            //                                 ),
            //                                 Expanded(
            //                                     flex: 4,
            //                                     child: Text(
            //                                       "U/P".tr +
            //                                           " ${transaction['unitPrice']} EGP",
            //                                       style: TextStyle(
            //                                           color: Colors.white),
            //                                     )),
            //                               ],
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       SizedBox(height: 10),
            //                       Row(
            //                         children: [
            //                           Expanded(
            //                             child: Row(
            //                               children: [
            //                                 Expanded(
            //                                     flex: 1,
            //                                     child: Icon(
            //                                       Icons.phone_android_rounded,
            //                                       color: Colors.white,
            //                                       size: 20,
            //                                     )),
            //                                 SizedBox(
            //                                   width: 5,
            //                                 ),
            //                                 Expanded(
            //                                     flex: 4,
            //                                     child: Text(
            //                                       "POS".tr +
            //                                           " ${transaction['pos']}",
            //                                       style: TextStyle(
            //                                           color: Colors.white),
            //                                     )),
            //                               ],
            //                             ),
            //                           ),
            //                           Expanded(
            //                             child: Row(
            //                               children: [
            //                                 Expanded(
            //                                     flex: 1,
            //                                     child: Icon(
            //                                       Icons.pending_actions_rounded,
            //                                       color: Colors.white,
            //                                       size: 20,
            //                                     )),
            //                                 SizedBox(
            //                                   width: 5,
            //                                 ),
            //                                 Expanded(
            //                                     flex: 4,
            //                                     child: Text(
            //                                       "Status".tr +
            //                                           " ${transaction['status']}",
            //                                       style: TextStyle(
            //                                           color: Colors.white),
            //                                     )),
            //                               ],
            //                             ),
            //                           ),
            //                         ],
            //                       ),
            //                       transaction['status'] == "pending"
            //                           ? SizedBox(height: 25)
            //                           : SizedBox(height: 10),
            //                       transaction['status'] == "pending"
            //                           ? Row(
            //                               children: [
            //                                 Expanded(
            //                                   // flex: 3,
            //                                   child: ElevatedButton(
            //                                     style: ElevatedButton.styleFrom(
            //                                       backgroundColor:
            //                                           transaction['status'] ==
            //                                                   "pending"
            //                                               ? Color(0xFF166E36)
            //                                               : Color.fromARGB(
            //                                                   255,
            //                                                   24,
            //                                                   24,
            //                                                   24), // Card color,
            //                                     ),
            //                                     onPressed: () {
            //                                       transactionStatusController
            //                                               .customController
            //                                               .transactionSeqNo
            //                                               .value =
            //                                           transaction[
            //                                               'transactionSeqNo'];
            //                                       Get.toNamed('/Fueling',
            //                                           arguments: {
            //                                             'trxSeqNum': transaction[
            //                                                 'transactionSeqNo'],
            //                                           });
            //                                     },
            //                                     child: Text(
            //                                       "Pay",
            //                                       style: TextStyle(
            //                                           color: Colors.white,
            //                                           fontSize: 25,
            //                                           fontWeight:
            //                                               FontWeight.bold),
            //                                     ),
            //                                   ),
            //                                 ),
            //                               ],
            //                             )
            //                           : SizedBox(),
            //                     ],
            //                   ),
            //                 ),
            //               );
            //             }),
            //   ),
            // );
          }),
          // bottomNavigationBar: FooterTrxStatus(),
        );
      }),
    );
  }
}
