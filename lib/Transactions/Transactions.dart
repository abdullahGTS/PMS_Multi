import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../CustomAppbar/CustomAppbar.dart';
import '../Local/Local_Controller.dart';
import '../Shared/drawer.dart';
import '../Theme/Theme_Controller.dart';
import 'Transactions_Controller.dart';

class Transactions extends StatelessWidget {
  Transactions({super.key});
  final alltransController = Get.find<TransactionsController>();
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
          backgroundColor: themeController.isDarkMode.value
              ? Color(0xFF2B2B2B)
              : Color(0xFFE9ECEF),
          // appBar: const CustomAppBar(),
          drawer: CustomDrawer(),
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
                          return ListView.builder(
                            itemCount: alltransController
                                .customController.filteredTransactions.length,
                            itemBuilder: (context, index) {
                              // Get the current transaction
                              final transaction = alltransController
                                  .customController.filteredTransactions[index];

                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      color: Color(0xED166E36),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      elevation: 5,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0,
                                                left: 8.0,
                                                right: 8.0,
                                                bottom: 5.0),
                                            child: Row(
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
                                                              color:
                                                                  Colors.white,
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
                                                        "${transaction['startTimeStamp']}",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16)),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Row(children: [
                                            Expanded(
                                              child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
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
                                                                      color: Colors
                                                                          .white,
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
                                                                          color:
                                                                              Colors.white),
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
                                                                          .payments_rounded,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 20,
                                                                    )),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Expanded(
                                                                    flex: 4,
                                                                    child: Text(
                                                                      "AMT".tr +
                                                                          " ${transaction['amount']} " +
                                                                          "EGP"
                                                                              .tr,
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
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
                                                                          .numbers,
                                                                      color: Colors
                                                                          .white,
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
                                                                          color:
                                                                              Colors.white),
                                                                    )),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 10,
                                                            ),
                                                            Row(
                                                              children: [
                                                                transaction['payment_type'] ==
                                                                        'Bank'
                                                                    ? Expanded(
                                                                        flex: 1,
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .credit_card_rounded,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              20,
                                                                        ))
                                                                    : Expanded(
                                                                        flex: 1,
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .account_balance_wallet_rounded,
                                                                          color:
                                                                              Colors.white,
                                                                          size:
                                                                              20,
                                                                        )),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Expanded(
                                                                    flex: 4,
                                                                    child: Text(
                                                                      "Type".tr +
                                                                          " " +
                                                                          "${transaction['payment_type']}"
                                                                              .tr,
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
                                                                    )),
                                                              ],
                                                            ),
                                                            transaction['payment_type'] ==
                                                                    'Bank'
                                                                ? SizedBox(
                                                                    height: 10,
                                                                  )
                                                                : SizedBox(),
                                                            transaction['payment_type'] ==
                                                                    'Bank'
                                                                ? Row(
                                                                    children: [
                                                                      Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              Icon(
                                                                            Icons.numbers_rounded,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                20,
                                                                          )),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Expanded(
                                                                          flex:
                                                                              4,
                                                                          child:
                                                                              Text(
                                                                            "ecrRefNO".tr,
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          )),
                                                                    ],
                                                                  )
                                                                : SizedBox(),
                                                            transaction['payment_type'] ==
                                                                    'Bank'
                                                                ? SizedBox(
                                                                    height: 10,
                                                                  )
                                                                : SizedBox(),
                                                            transaction['payment_type'] ==
                                                                    'Bank'
                                                                ? Row(
                                                                    children: [
                                                                      Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              Icon(
                                                                            Icons.numbers_rounded,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                20,
                                                                          )),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Expanded(
                                                                          flex:
                                                                              4,
                                                                          child:
                                                                              Text(
                                                                            ("voucherNo").tr,
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          )),
                                                                    ],
                                                                  )
                                                                : SizedBox(),
                                                            transaction['payment_type'] ==
                                                                    'Bank'
                                                                ? SizedBox(
                                                                    height: 10,
                                                                  )
                                                                : SizedBox(),
                                                            transaction['payment_type'] ==
                                                                    'Bank'
                                                                ? Row(
                                                                    children: [
                                                                      Expanded(
                                                                          flex:
                                                                              1,
                                                                          child:
                                                                              Icon(
                                                                            Icons.numbers_rounded,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                20,
                                                                          )),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Expanded(
                                                                          flex:
                                                                              4,
                                                                          child:
                                                                              Text(
                                                                            "batchNo".tr,
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          )),
                                                                    ],
                                                                  )
                                                                : SizedBox(),
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
                                                                      color: Colors
                                                                          .white,
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
                                                                          color:
                                                                              Colors.white),
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
                                                                          .payments_rounded,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 20,
                                                                    )),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Expanded(
                                                                    flex: 4,
                                                                    child: Text(
                                                                      "Tip".tr +
                                                                          " ${transaction['TipsValue']} " +
                                                                          "EGP"
                                                                              .tr,
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
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
                                                                          .numbers,
                                                                      color: Colors
                                                                          .white,
                                                                      size: 20,
                                                                    )),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Expanded(
                                                                    flex: 4,
                                                                    child: Text(
                                                                      "Stan".tr +
                                                                          " ${transaction['Stannumber']}",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.white),
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
                                                                      color: Colors
                                                                          .white,
                                                                      size: 20,
                                                                    )),
                                                                SizedBox(
                                                                  width: 5,
                                                                ),
                                                                Expanded(
                                                                  flex: 4,
                                                                  child: Text(
                                                                    "Status".tr +
                                                                        " " +
                                                                        "${transaction['statusvoid']}"
                                                                            .tr,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            transaction['payment_type'] ==
                                                                    'Bank'
                                                                ? SizedBox(
                                                                    height: 10,
                                                                  )
                                                                : SizedBox(),
                                                            transaction['payment_type'] ==
                                                                    'Bank'
                                                                ? Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Expanded(
                                                                          flex:
                                                                              4,
                                                                          child:
                                                                              Text(
                                                                            "${transaction['ecrRef']}",
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          )),
                                                                    ],
                                                                  )
                                                                : SizedBox(),
                                                            transaction['payment_type'] ==
                                                                    'Bank'
                                                                ? SizedBox(
                                                                    height: 10,
                                                                  )
                                                                : SizedBox(),
                                                            transaction['payment_type'] ==
                                                                    'Bank'
                                                                ? Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Expanded(
                                                                          flex:
                                                                              4,
                                                                          child:
                                                                              Text(
                                                                            "${transaction['voucherNo']}",
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          )),
                                                                    ],
                                                                  )
                                                                : SizedBox(),
                                                            transaction['payment_type'] ==
                                                                    'Bank'
                                                                ? SizedBox(
                                                                    height: 10,
                                                                  )
                                                                : SizedBox(),
                                                            transaction['payment_type'] ==
                                                                    'Bank'
                                                                ? Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Expanded(
                                                                          flex:
                                                                              4,
                                                                          child:
                                                                              Text(
                                                                            "${transaction['batchNo']}",
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          )),
                                                                    ],
                                                                  )
                                                                : SizedBox(),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ),
                                          ]),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0,
                                                left: 8.0,
                                                right: 8.0,
                                                bottom: 5.0),
                                            child: Row(
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
                                                              color:
                                                                  Colors.white,
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
                                                        "${transaction['endTimeStamp']}",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: transaction[
                                                              'statusvoid'] ==
                                                          "complete"
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 5),
                                                          child: Row(
                                                            children: [
                                                              transaction['payment_type'] ==
                                                                      'Bank'
                                                                  ? Expanded(
                                                                      child:
                                                                          ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          backgroundColor:
                                                                              const Color(0xFF2B2B2B),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          alltransController
                                                                              .showVoidConfirmationDialog(
                                                                            context,
                                                                            transaction['Stannumber'],
                                                                            double.parse(transaction['amount']),
                                                                            transaction['transactionSeqNo'],
                                                                            transaction['ecrRef'],
                                                                          );
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "Void"
                                                                              .tr,
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : transaction[
                                                                              'payment_type'] ==
                                                                          'Bank'
                                                                      ? SizedBox(
                                                                          width:
                                                                              10,
                                                                        )
                                                                      : SizedBox(),
                                                              transaction['payment_type'] ==
                                                                      'Bank'
                                                                  ? SizedBox(
                                                                      width: 10,
                                                                    )
                                                                  : SizedBox(),
                                                              transaction['payment_type'] ==
                                                                      'Bank'
                                                                  ? Expanded(
                                                                      child:
                                                                          ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          backgroundColor:
                                                                              const Color(0xFF2B2B2B),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          alltransController.reprint(
                                                                              transaction['ecrRef'],
                                                                              transaction['voucherNo']);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "Re_print"
                                                                              .tr,
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Expanded(
                                                                      child:
                                                                          ElevatedButton(
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          backgroundColor:
                                                                              const Color(0xFF2B2B2B),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          alltransController
                                                                              .printReceipt();
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "Re_print"
                                                                              .tr,
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    )
                                                            ],
                                                          ),
                                                        )
                                                      : transaction[
                                                                  'statusvoid'] ==
                                                              "progress"
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          20,
                                                                      vertical:
                                                                          5),
                                                              child:
                                                                  ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      const Color(
                                                                          0xFF2B2B2B),
                                                                ),
                                                                onPressed: () {
                                                                  // Initialize the PreSaleValueController

                                                                  // Navigate to the /ChoosePaymentaftervoid page and pass presalecontroller.value as an argument
                                                                  alltransController
                                                                      .resetTransaction(
                                                                          transaction);
                                                                  Get.toNamed(
                                                                      '/ResetPayment');
                                                                },
                                                                child: Text(
                                                                  "Set_Transaction"
                                                                      .tr
                                                                      .tr
                                                                      .tr, // Or any other label you'd prefer
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                            )
                                                          : SizedBox())
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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