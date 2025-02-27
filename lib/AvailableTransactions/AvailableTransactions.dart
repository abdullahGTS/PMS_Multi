import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../CustomAppbar/CustomAppbar.dart';
import '../Local/Local_Controller.dart';
import '../Shared/drawer.dart';
import '../Theme/Theme_Controller.dart';
import 'AvailableTransactions_Controller.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

class Availabletransactions extends StatelessWidget {
  Availabletransactions({super.key});
  final alltransController = Get.find<AvailabletransactionsController>();
  var themeController = Get.find<ThemeController>();
  var color = Color.fromARGB(255, 24, 24, 24);
  final localController = Get.find<LocalController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Obx(() {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              alltransController.showExtractedValuesPopup(context);

              // Get the current time formatted for the XML
            },
            child: Icon(Icons.plus_one),
          ),
          backgroundColor: themeController.isDarkMode.value
              ? Color(0xFF2B2B2B)
              : Color(0xFFE9ECEF),
          // appBar: const CustomAppBar(),
          drawer: CustomDrawer(),
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () async {
          //     await alltransController.GetAllTransaction();
          //   },
          //   child: Icon(Icons.add),
          // ),
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
              SizedBox(
                child: CustomAppBar(),
                width: MediaQuery.of(context).size.width * 0.99,
              ),
              Container(
                child: Column(
                  children: [
                    SizedBox(height: 180),
                    Expanded(
                      child: Obx(
                        () {
                          return alltransController.AvailableTrxList.length <=
                                      0 ||
                                  alltransController.AvailableTrxList.length <
                                      alltransController.SeqNoList.length
                              ? alltransController.NoAvailableTrx.value != ""
                                  ? Center(
                                      child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "${alltransController.NoAvailableTrx.value}",
                                        style: TextStyle(
                                            color:
                                                themeController.isDarkMode.value
                                                    ? Colors.white
                                                    : color,
                                            fontSize: 24),
                                      ),
                                    ))
                                  : Center(
                                      child: CircularProgressIndicator(
                                        color: themeController.isDarkMode.value
                                            ? Colors.white
                                            : color,
                                      ),
                                    )
                              : ListView.builder(
                                  itemCount: alltransController
                                      .AvailableTrxList.length,
                                  itemBuilder: (context, index) {
                                    int reverseIndex = alltransController
                                            .AvailableTrxList.length -
                                        1 -
                                        index;
                                    final transaction = alltransController
                                        .AvailableTrxList[reverseIndex];
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, left: 8.0, right: 8.0),
                                      child: Card(
                                        color: const Color(
                                            0xFF166E36), // Card color
                                        child: Padding(
                                          padding: const EdgeInsets.all(
                                              10.0), // Padding inside the card
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center, // Center vertically
                                            crossAxisAlignment: CrossAxisAlignment
                                                .center, // Center horizontally
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    // flex: 1,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Align(
                                                              alignment: localController
                                                                          .getCurrentLang()
                                                                          ?.languageCode ==
                                                                      "ar"
                                                                  ? Alignment
                                                                      .centerRight
                                                                  : Alignment
                                                                      .centerLeft,
                                                              child: Icon(
                                                                Icons
                                                                    .calendar_month_rounded,
                                                                color: Colors
                                                                    .white,
                                                                size: 20,
                                                              ),
                                                            )),
                                                        Expanded(
                                                          flex: 4,
                                                          child: Align(
                                                            alignment: localController
                                                                        .getCurrentLang()
                                                                        ?.languageCode ==
                                                                    "ar"
                                                                ? Alignment
                                                                    .centerRight
                                                                : Alignment
                                                                    .centerLeft,
                                                            child: Text(
                                                              "Start_Date".tr,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    // flex: 2,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                          "${transaction['Start_Date']}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16)),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Icon(
                                                              Icons
                                                                  .local_gas_station,
                                                              color:
                                                                  Colors.white,
                                                              size: 20,
                                                            )),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                            flex: 4,
                                                            child: Text(
                                                              "Pump".tr +
                                                                  " ${transaction['pumpNo']}",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Icon(
                                                              Icons
                                                                  .local_gas_station,
                                                              color:
                                                                  Colors.white,
                                                              size: 20,
                                                            )),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                            flex: 4,
                                                            child: Text(
                                                              "Nozzle".tr +
                                                                  " ${transaction['nozzleNo']}",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Icon(
                                                              Icons
                                                                  .water_drop_rounded,
                                                              color:
                                                                  Colors.white,
                                                              size: 20,
                                                            )),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                            flex: 4,
                                                            child: Text(
                                                              "${transaction['productName']}"
                                                                  .tr,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Icon(
                                                              Icons
                                                                  .numbers_rounded,
                                                              color:
                                                                  Colors.white,
                                                              size: 20,
                                                            )),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                            flex: 4,
                                                            child: Text(
                                                              "TRX".tr +
                                                                  " ${transaction['transactionSeqNo']}",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Icon(
                                                              Icons
                                                                  .payments_outlined,
                                                              color:
                                                                  Colors.white,
                                                              size: 20,
                                                            )),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                            flex: 4,
                                                            child: Text(
                                                              "T/A".tr +
                                                                  " ${transaction['amountVal']} " +
                                                                  "EGP".tr,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Icon(
                                                              Icons
                                                                  .water_rounded,
                                                              color:
                                                                  Colors.white,
                                                              size: 20,
                                                            )),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                            flex: 4,
                                                            child: Text(
                                                              "T/V".tr +
                                                                  " ${transaction['volume']} " +
                                                                  "LTR".tr,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Icon(
                                                              Icons
                                                                  .payments_outlined,
                                                              color:
                                                                  Colors.white,
                                                              size: 20,
                                                            )),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                            flex: 4,
                                                            child: Text(
                                                              "U/P".tr +
                                                                  " ${transaction['unitPrice']} " +
                                                                  "EGP".tr,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Icon(
                                                              Icons
                                                                  .phone_android_rounded,
                                                              color:
                                                                  Colors.white,
                                                              size: 20,
                                                            )),
                                                        SizedBox(
                                                          width: 5,
                                                        ),
                                                        Expanded(
                                                            flex: 4,
                                                            child: Text(
                                                              "POS".tr +
                                                                  " ${transaction['AuthorisationApplicationSender'] == '' ? 'Unknown'.tr : transaction['AuthorisationApplicationSender']}",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            )),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 10),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    // flex: 1,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            flex: 1,
                                                            child: Align(
                                                              alignment: localController
                                                                          .getCurrentLang()
                                                                          ?.languageCode ==
                                                                      "ar"
                                                                  ? Alignment
                                                                      .centerRight
                                                                  : Alignment
                                                                      .centerLeft,
                                                              child: Icon(
                                                                Icons
                                                                    .calendar_month_rounded,
                                                                color: Colors
                                                                    .white,
                                                                size: 20,
                                                              ),
                                                            )),
                                                        Expanded(
                                                          flex: 4,
                                                          child: Align(
                                                            alignment: localController
                                                                        .getCurrentLang()
                                                                        ?.languageCode ==
                                                                    "ar"
                                                                ? Alignment
                                                                    .centerRight
                                                                : Alignment
                                                                    .centerLeft,
                                                            child: Text(
                                                              "End_Date".tr,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    // flex: 2,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Text(
                                                          "${transaction['End_Date']}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 16)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 10.0,
                                                      left: 10.0,
                                                      right: 10.0,
                                                    ),
                                                    child: ElevatedButton(
                                                        onPressed: () async {
                                                          print(
                                                              'abdullahMichaelKiro${transaction['transactionSeqNo']}');
                                                          await alltransController
                                                              .TransactionDetails(
                                                                  transaction[
                                                                      'transactionSeqNo']);
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFF2B2B2B),
                                                        ),
                                                        child: Text(
                                                          'Details'.tr,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                  )),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////
//  [
//                                 Row(children: [
//                                   Expanded(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(10.0),
//                                       child: Text(
//                                         "Pump No: ${transaction['pumpNo']}, "
//                                         "Nozzle No: ${transaction['nozzleNo']}, "
//                                         "Amount: ${transaction['amount']}, "
//                                         "status: ${transaction['statusvoid']}, "
//                                         "transsec: ${transaction['transactionSeqNo']}, "
//                                         "Type: ${transaction['payment_type']}, "
//                                         "Stannumber: ${transaction['Stannumber']},"
//                                         "Tips: ${transaction['TipsValue']}",
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ]),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: transaction['payment_type'] ==
//                                               'Bank'
//                                           ? transaction['statusvoid'] ==
//                                                   "complete"
//                                               ? Padding(
//                                                   padding: const EdgeInsets
//                                                       .symmetric(
//                                                       horizontal: 20,
//                                                       vertical: 5),
//                                                   child: ElevatedButton(
//                                                     style: ElevatedButton
//                                                         .styleFrom(
//                                                       backgroundColor:
//                                                           const Color(
//                                                               0xFF2B2B2B),
//                                                     ),
//                                                     onPressed: () {
//                                                       alltransController
//                                                           .showVoidConfirmationDialog(
//                                                         context,
//                                                         transaction[
//                                                             'Stannumber'],
//                                                         double.parse(
//                                                             transaction[
//                                                                 'amount']),
//                                                         transaction[
//                                                             'transactionSeqNo'],
//                                                       );
//                                                     },
//                                                     child: const Text(
//                                                       "Void",
//                                                       style: TextStyle(
//                                                           color: Colors.white),
//                                                     ),
//                                                   ),
//                                                 )
//                                               : transaction['statusvoid'] ==
//                                                       "progress"
//                                                   ? Padding(
//                                                       padding: const EdgeInsets
//                                                           .symmetric(
//                                                           horizontal: 20,
//                                                           vertical: 5),
//                                                       child: ElevatedButton(
//                                                         style: ElevatedButton
//                                                             .styleFrom(
//                                                           backgroundColor:
//                                                               const Color(
//                                                                   0xFF2B2B2B),
//                                                         ),
//                                                         onPressed: () {
//                                                           // Initialize the PreSaleValueController

//                                                           // Navigate to the /ChoosePaymentaftervoid page and pass presalecontroller.value as an argument
//                                                           alltransController
//                                                               .resetTransaction(
//                                                                   transaction);
//                                                           Get.toNamed(
//                                                               '/ResetPayment');
//                                                         },
//                                                         child: const Text(
//                                                           "Set Transaction", // Or any other label you'd prefer
//                                                           style: TextStyle(
//                                                               color:
//                                                                   Colors.white),
//                                                         ),
//                                                       ),
//                                                     )
//                                                   : SizedBox()
//                                           : SizedBox(),
//                                     )
//                                   ],
//                                 ),
//                               ]
////////
