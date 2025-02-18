// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';
import '../CloseRequest/CloseRequest_Controller.dart';
import '../CustomAppbar/CustomAppbar_Controller.dart';
import '../Theme/Theme_Controller.dart';

class FooterView extends StatelessWidget {
  // final customController = Get.put(CustomAppbarController());
  final customController = Get.find<CustomAppbarController>();
  final closeController = Get.put(CloseRequestController());
  var themeController = Get.find<ThemeController>();

  var FooterxmlDataPumpListener;
  var FooterAvailableTrxListener;
  var footer_avail_flag = false;
  var footer_pump_flag = false;
  var color = Color.fromARGB(255, 24, 24, 24);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
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
          // height: 50,
          color: Colors.white.withOpacity(0),
          // width: double.infinity,
          padding: const EdgeInsets.all(16.0), // Add padding if needed
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center the content in the Row
            children: [
              GestureDetector(
                onTap: () async {
                  customController.fetchToken();
                  if (customController.isconnect.value) {
                    //check close shift
                    await GetAllTransaction();
                    await Future.delayed(Duration(seconds: 1));
                    await checkFueling();
                    await Future.delayed(Duration(seconds: 1));
                    if (footer_avail_flag && footer_pump_flag) {
                      // drawerxmlDataPumpListener!.cancel();
                      // drawerAvailableTrxListener!.cancel();
                      // Get.toNamed('/VerifyCloseShift');
                      print("tellecollect cheking");
                    } else {
                      if (!footer_avail_flag) {
                        Get.snackbar(
                          "Alert".tr,
                          "You_have_to_pay_the_available_transactions_first".tr,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                      if (!footer_pump_flag) {
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
                    FooterxmlDataPumpListener!.cancel();
                    FooterAvailableTrxListener!.cancel();

                    // end check close shift
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ('Collecting Config...').tr,
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
                    // customController.sendShiftsToApi();
                    customController.sendTransactionsToApi();
                    customController.sendtoupdateistaxed();
                    await closeController.checkthelastpos();
                  } else {
                    await customController.readConfigFromFile();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ('Reading Local Config...').tr,
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
                  }
                  // Navigate to the verification page'
                },
                child: _buildCircleIcon(
                    Icons.cloud_download_rounded, color), // Cloud on the left
                // Fuel on the right
              ),
              const Spacer(), // Spacer to push the logo to the center
              _buildCircleImage('media/new_logo.png'), // New logo in the center
              const Spacer(), // Spacer to push the fuel icon to the right
              GestureDetector(
                onTap: () {
                  // Navigate to the verification page'
                  customController.issupervisormaiar.value = false;
                  Get.toNamed("/verify");
                },
                child: _buildCircleIcon(Icons.local_gas_station_rounded,
                    color), // Fuel on the right
              ),
            ],
          ),
        ),
      ],
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

    FooterAvailableTrxListener = customController.xmlData.listen((data) async {
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
              footer_avail_flag = false;
              FooterAvailableTrxListener!.cancel();
            } else {
              footer_avail_flag = true;
              FooterAvailableTrxListener!.cancel();
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

    FooterxmlDataPumpListener = customController.xmlData.listen((data) async {
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
            footer_pump_flag = false;
            FooterxmlDataPumpListener!.cancel();
          } else {
            footer_pump_flag = true;
            tempList = 0;
            FooterxmlDataPumpListener!.cancel();
          }
        }
      }
    });

    customController.socketConnection
        .sendMessage(customController.getXmlHeader(xmlContentreq));
  }
}
