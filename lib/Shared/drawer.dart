import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AvailableTransactions/AvailableTransactions_Controller.dart';
import '../CustomAppbar/CustomAppbar_Controller.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

import '../Local/Local_Controller.dart';
import '../Pumps/Pumps_Controller.dart';
import '../Receipt/Receipt_Controller.dart';
import '../Theme/Theme_Controller.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});
  // final customController = Get.put(CustomAppbarController());
  final customController = Get.find<CustomAppbarController>();
  final Local = Get.find<LocalController>();
  final themeController = Get.put(ThemeController());

  var drawerxmlDataPumpListener;
  var drawerAvailableTrxListener;
  var avail_flag = false;
  var pump_flag = false;
  // final receiptController = Get.put(ReceiptController());

  @override
  Widget build(BuildContext context) {
    print(
        " customController.managershift.value${customController.managershift.value}");
    return Drawer(
      backgroundColor: themeController.isDarkMode.value
          ? Color(0xFF166E36)
          : Color(0xFF1a2035),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(
            height: 40,
          ),
          Container(
            padding:
                EdgeInsets.all(16.0), // Add some padding around the content
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.person,
                  size: 40, // Adjust size as needed
                  color: Colors.white, // Optional: Change the icon color
                ),
                SizedBox(width: 16), // Space between icon and text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        return Text(
                          customController.managershift.value,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        );
                      }),
                      Text(
                        '@' + 'Supervisor'.tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 8), // Space between text and date
                      Text(
                        'Start_at'.tr +
                            ': ${customController.datetimeshift.value}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Obx(() {
                        return Text(
                          'S/N'.tr + ': ${customController.SerialNumber.value}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.home_rounded,
              color: Colors.white,
            ),
            title: Text(
              'Home'.tr,
              style: TextStyle(color: Colors.white),
            ),
            tileColor: Get.currentRoute == "/Home" ? Colors.green : null,
            onTap: () {
              if (Get.currentRoute != "/Home") {
                Get.offNamed("/Home");
              }
            },
          ),
          ListTile(
            leading: Icon(
              Icons.local_gas_station_rounded,
              color: Colors.white,
            ),
            title: Text(
              'Fuels'.tr,
              style: TextStyle(color: Colors.white),
            ),
            tileColor: Get.currentRoute == "/verify" ? Colors.green : null,
            onTap: () {
              Get.offNamed("/verify");
            },
            // onTap: () {
            //   Get.offNamed("/verify");
            // },
          ),
          ListTile(
            leading: Icon(
              Icons.cloud_download_rounded,
              color: Colors.white,
            ),
            title: Text(
              'Telecollect'.tr,
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              Get.back();
              customController.fetchToken();
              if (customController.isconnect.value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Collecting Config...'.tr,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    duration: Duration(
                        seconds:
                            2), // Duration for which the snackbar is visible
                    backgroundColor: Color.fromARGB(
                        255, 0, 0, 0), // Set background color to white
                    behavior: SnackBarBehavior
                        .floating, // Makes the snackbar float above the content
                  ),
                );
                customController.sendtaxreid();
                customController.sendShiftsToApi();
                customController.sendTransactionsToApi();
                customController.sendtoupdateistaxed();

                // await closeController.checkthelastpos();
              } else {
                await customController.readConfigFromFile();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Reading Local Config...'.tr,
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                    duration: Duration(
                        seconds:
                            2), // Duration for which the snackbar is visible
                    backgroundColor: Color.fromARGB(
                        255, 0, 0, 0), // Set background color to white
                    behavior: SnackBarBehavior
                        .floating, // Makes the snackbar float above the content
                  ),
                );
                Get.closeAllSnackbars();
              }
            },
          ),
          ListTile(
            leading: Icon(
              Icons.power_rounded,
              color: Colors.white,
            ),
            title: Text(
              'Force_Login'.tr,
              style: TextStyle(color: Colors.white),
            ),
            onTap: () async {
              Get.back();
              await customController.startConnection();
            },
          ),
          ListTile(
            leading: Icon(
              Icons.layers_rounded,
              color: Colors.white,
            ),
            title: Text(
              'Transactions | All'.tr,
              style: TextStyle(color: Colors.white),
            ),
            tileColor:
                Get.currentRoute == "/Transactions" ? Colors.green : null,
            onTap: () {
              Get.offNamed("/Transactions");
            },
            // onTap: () {
            //   Get.offNamed("/Transactions");
            // },
          ),
          ListTile(
            leading: Icon(
              Icons.library_add_check_rounded,
              color: Colors.white,
            ),
            title: Text(
              'Transactions | Available'.tr,
              style: TextStyle(color: Colors.white),
            ),
            tileColor: Get.currentRoute == "/Availabletransactions"
                ? Colors.green
                : null,
            onTap: () {
              Get.offAllNamed("/Verifyavailabletrx");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.add_chart_rounded,
              color: Colors.white,
            ),
            title: Text(
              'Report | Transactions'.tr,
              style: TextStyle(color: Colors.white),
            ),
            tileColor: Get.currentRoute == "/Report" ? Colors.green : null,
            onTap: () {
              Get.offNamed("/Report");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.add_chart_rounded,
              color: Colors.white,
            ),
            title: Text(
              'Report | Shifts'.tr,
              style: TextStyle(color: Colors.white),
            ),
            tileColor: Get.currentRoute == "/ReportShift" ? Colors.green : null,
            onTap: () {
              Get.offNamed("/ReportShift");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.tune,
              color: Colors.white,
            ),
            title: Text(
              'Pump_Calibration'.tr,
              style: TextStyle(color: Colors.white),
            ),
            tileColor: Get.currentRoute == "/Mair" ? Colors.green : null,
            onTap: () {
              Get.toNamed("/Mair");
            },
          ),
          ListTile(
            leading: Icon(
              Icons.payments_rounded,
              color: Colors.white,
            ),
            title: Text(
              'Settlement_trans'.tr,
              style: TextStyle(color: Colors.white),
            ),
            tileColor:
                Get.currentRoute == "/VerifySetlemment" ? Colors.green : null,
            onTap: () async {
              Get.toNamed('/VerifySetlemment');
              // const _channel = MethodChannel('com.example.pms/method');

              // await _channel.invokeMethod<String>('settlementTrans');
              // _channel.setMethodCallHandler((call) async {
              //   if (call.method == "onTransactionResult") {
              //     final Map<String, dynamic> response =
              //         Map<String, dynamic>.from(call.arguments);

              //     // Handle transaction result
              //     if (response.containsKey("error")) {
              //       print("Transaction Error: ${response['error']}");
              //     } else {
              //       print("Transaction Successful: $response");
              //     }
              //   }
              // });
            },
          ),
          ListTile(
            leading: Icon(
              Icons.language_rounded,
              color: Colors.white,
            ),
            title: SwitchListTile(
              activeColor: Color.fromARGB(255, 24, 24, 24),
              title: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Arabic'.tr,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              value: Local.getCurrentLang()?.languageCode == "ar",
              onChanged: (value) {
                Local.changeLang(value
                    ? "ar" // Change to Arabic
                    : "en");
                Get.back();
              },
            ),
          ),
          ListTile(
            leading: Icon(
              customController.isDarkMode.value
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: Colors.white,
            ),
            title: Text(
              "Theme",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              themeController.toggleTheme();
              Get.back();
            },
          ),
          Container(
            margin: EdgeInsets.only(right: 6, left: 6),
            decoration: BoxDecoration(
                color: themeController.isDarkMode.value
                    ? Colors.black
                    : Colors.white,
                borderRadius: BorderRadius.circular(10)),

            // Set your desired background color
            child: ListTile(
              trailing: Icon(
                Icons.logout_rounded,
                color: themeController.isDarkMode.value
                    ? Colors.white
                    : Color(0xFF2B2B2B),
              ),
              title: Text(
                'Close_Shift'.tr,
                style: TextStyle(
                  color: themeController.isDarkMode.value
                      ? Colors.white
                      : Color(0xFF2B2B2B),
                ),
              ),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                var transactions =
                    await customController.fetchTransactionsByshiftchecking(
                        prefs.getInt('shift_id') ?? 0);

// Check if any transaction has a status of 'void'
                bool hasVoidTransaction = transactions.any(
                    (transaction) => transaction['statusvoid'] == 'progress');
                // print("hasVoidTransaction${hasVoidTransaction}");
                if (hasVoidTransaction) {
                  Get.snackbar(
                    "Error".tr,
                    "You_have_to_pay_the_void_transactions_first".tr,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                } else {
                  await GetAllTransaction();
                  await Future.delayed(Duration(seconds: 1));
                  await checkFueling();
                  await Future.delayed(Duration(seconds: 1));
                  if (avail_flag && pump_flag) {
                    // drawerxmlDataPumpListener!.cancel();
                    // drawerAvailableTrxListener!.cancel();
                    Get.toNamed('/VerifyCloseShift');
                  } else {
                    if (!avail_flag) {
                      Get.snackbar(
                        "Error".tr,
                        "You_have_to_pay_the_available_transactions_first".tr,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                    if (!pump_flag) {
                      Get.snackbar(
                        "Error".tr,
                        "sorry".tr +
                            ", " +
                            "there_is_a_pump_in_use".tr +
                            " , " +
                            "you_can_not_close_the_shift".tr,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  }
                  drawerxmlDataPumpListener!.cancel();
                  drawerAvailableTrxListener!.cancel();
                }
              },
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }

  GetAllTransaction() async {
    print("teeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    print("id1${customController.iD}");
    // Increment RequestID
    customController.iD++;
    print("id2${customController.iD}");

    // Get the current time formatted for the XML
    String currentTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now());

    String xmlContentreq = '''
<?xml version="1.0" encoding="utf-8" ?>
<ServiceRequest RequestType="GetAvailableFuelSaleTrxs" ApplicationSender="${customController.SerialNumber.value.substring(customController.SerialNumber.value.length - 5)}"
WorkstationID="PMS" RequestID="${customController.iD}" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:noNamespaceSchemaLocation="FDC_GetAvailableFuelSaleTrxs_Request.xsd">
<POSdata>
<POSTimeStamp>$currentTime</POSTimeStamp>
<DeviceClass Type="FP" DeviceID="*">
</DeviceClass>
</POSdata>
</ServiceRequest>
''';
    print("xmlContentreqcheckFueling${xmlContentreq}");

    // Log the XML for debugging purposes
    // Get.snackbar(
    //   'Check PUMP Status',
    //   'GetFPState Request Sent',
    //   snackPosition: SnackPosition.TOP,
    //   backgroundColor: Colors.green,
    //   colorText: Colors.white,
    // );
    // Send the constructed XML message through socket
    // print(customController.socketConnection);
    // print(customController.socketConnection.runtimeType);

    drawerAvailableTrxListener = customController.xmlData.listen((data) async {
      var document = XmlDocument.parse(data);
      var serviceResponse = document.getElement('ServiceResponse');
      if (serviceResponse != null) {
        var RequestType = serviceResponse.getAttribute('RequestType');
        var OverallResult = serviceResponse.getAttribute('OverallResult');
        if (RequestType == 'GetAvailableFuelSaleTrxs' &&
            OverallResult == 'Success') {
          var allClasses = document.findAllElements('DeviceClass');
          print('DeviceClass----->${allClasses}');
          allClasses.forEach((element) {
            var errorCode = element.findAllElements('ErrorCode').first.text;
            if (errorCode == 'ERRCD_OK') {
              avail_flag = false;
              drawerAvailableTrxListener!.cancel();
            } else {
              avail_flag = true;
              drawerAvailableTrxListener!.cancel();
            }
          });
        }
      }
    });
    customController.socketConnection
        .sendMessage(customController.getXmlHeader(xmlContentreq));
    // Get.snackbar(
    //   'AvailableTrxList',
    //   '${AvailableTrxList.value}',
    //   snackPosition: SnackPosition.TOP,
    //   backgroundColor: Colors.green,
    //   colorText: Colors.white,
    // );
    // if (AvailableTrxListener != null) {
    //   AvailableTrxListener!.cancel();
    //   print("AvailableTrxListener stopped.");
    // }
  }

  checkFueling() {
    var tempList = 0;
    print("teeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    print("id1${customController.iD}");
    // Increment RequestID
    customController.iD++;
    print("id2${customController.iD}");

    // Get the current time formatted for the XML
    String currentTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now());

    String xmlContentreq = '''
<?xml version="1.0"?>
<ServiceRequest xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:xsd="http://www.w3.org/2001/XMLSchema" RequestType="GetFPState"
ApplicationSender="${customController.SerialNumber.value.substring(customController.SerialNumber.value.length - 5)}" WorkstationID="PMS" RequestID="${customController.iD}">
 <POSdata>
 <POSTimeStamp>$currentTime</POSTimeStamp>
 <DeviceClass Type="FP" DeviceID="*" />
 </POSdata>
</ServiceRequest>
''';
    print("xmlContentreqcheckFueling${xmlContentreq}");

    // Log the XML for debugging purposes
    // Get.snackbar(
    //   'Check PUMP Status',
    //   'GetFPState Request Sent',
    //   snackPosition: SnackPosition.TOP,
    //   backgroundColor: Colors.green,
    //   colorText: Colors.white,
    // );
    // Send the constructed XML message through socket
    // print(customController.socketConnection);
    // print(customController.socketConnection.runtimeType);

    drawerxmlDataPumpListener = customController.xmlData.listen((data) async {
      var document = XmlDocument.parse(data);

      var serviceResponse = document.getElement('ServiceResponse');
      if (serviceResponse != null) {
        var RequestType = serviceResponse.getAttribute('RequestType');
        var overallResult = serviceResponse.getAttribute('OverallResult');
        if (RequestType == 'GetFPState' && overallResult == "Success") {
          var pumpNo = document.findAllElements('DeviceClass');
          var status = document.findAllElements('DeviceState');
          print('status-----------: $status');
          for (var pump in pumpNo) {
            var pumpStatus = pump.findAllElements('DeviceState').first.text;
            if (pumpStatus == 'FDC_FUELLING' ||
                pumpStatus == 'FDC_AUTHORISED' ||
                pumpStatus == 'FDC_STARTED') {
              tempList = tempList + 1;
            }
          }
          print('tempList-->${tempList}');
          if (tempList > 0) {
            pump_flag = false;
            drawerxmlDataPumpListener!.cancel();
          } else {
            pump_flag = true;
            tempList = 0;
            drawerxmlDataPumpListener!.cancel();
          }
        }
      }
    });

    customController.socketConnection
        .sendMessage(customController.getXmlHeader(xmlContentreq));
  }
}
