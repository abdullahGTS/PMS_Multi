import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../CustomAppbar/CustomAppbar.dart';
import '../CustomAppbar/CustomAppbar_Controller.dart';
import '../Footer/Footer_Pumps.dart';
import '../Local/Local_Controller.dart';
import '../Shared/drawer.dart';
import '../Theme/Theme_Controller.dart';
import 'Pumps_Controller.dart';
import 'package:xml/xml.dart';

class PumpsPage extends StatelessWidget {
  PumpsPage({super.key});

  final allpumpcont = Get.find<PumpsController>();
  final customController = Get.find<CustomAppbarController>();
  final localController = Get.find<LocalController>();
  var color = Color.fromARGB(255, 24, 24, 24);
  var themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Obx(() {
        return Scaffold(
          backgroundColor: themeController.isDarkMode.value
              ? Color(0xFF2B2B2B)
              : Color(0xFFE9ECEF),
          // appBar: CustomAppBar(),
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
              SizedBox(
                height: 672,
              ),
              Positioned(
                // right: 100,
                // top: 0,
                bottom: 0,
                child: SizedBox(
                  child: FooterPumpsView(),
                  width: MediaQuery.of(context).size.width * 0.99,
                ),
              ),
              Container(
                height: screenHeight,
                width: screenWidth,
                padding: const EdgeInsets.only(top: 10),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(height: 220),
                      for (int i = 0;
                          i < customController.config['pumps'].length;
                          i += 2)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // First card in the row
                            buildPumpCard(
                              context,
                              customController.config['pumps'][i]['pump_number']
                                  .toString(),
                              customController.config['pumps'][i]
                                      ['nozzles_count']
                                  .toString(),
                            ),
                            // Second card in the row (if available)
                            if (i + 1 < customController.config['pumps'].length)
                              buildPumpCard(
                                context,
                                customController.config['pumps'][i + 1]
                                        ['pump_number']
                                    .toString(),
                                customController.config['pumps'][i + 1]
                                        ['nozzles_count']
                                    .toString(),
                              ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // bottomNavigationBar: FooterPumpsView(),
        );
      }),
    );
  }

  // Method to build each pump card
  Widget buildPumpCard(
      BuildContext context, String pumpName, String nozzlesCount) {
    return GestureDetector(
      onTap: () async {
        print(
            "localController${localController.getCurrentLang()?.languageCode == "ar"}");
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('pumpName', pumpName);

        if (customController.issupervisormaiar.value) {
          await allpumpcont.checkFueling(pumpName);

          allpumpcont.xmlDataPumpListener =
              customController.xmlData.listen((data) async {
            var document = XmlDocument.parse(data);

            var serviceResponse = document.getElement('ServiceResponse');
            if (serviceResponse != null) {
              var RequestType = serviceResponse.getAttribute('RequestType');
              var overallResult = serviceResponse.getAttribute('OverallResult');
              if (RequestType == 'GetFPState' && overallResult == "Success") {
                var pumpNo = document
                    .findAllElements('DeviceClass')
                    .first
                    .getAttribute('DeviceID');
                var status = document.findAllElements('DeviceState').first.text;
                print('pumpNo-----------: $pumpNo');
                print('status-----------: $status');

                if (status == 'FDC_FUELLING' ||
                    status == 'FDC_AUTHORISED' ||
                    status == 'FDC_STARTED') {
                  Get.snackbar(
                    ("Alert").tr,
                    ("Sorry_the_pump").tr + "${pumpNo}" + ("is_in_progress").tr,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  Get.closeAllSnackbars();
                  customController.checkFueling.value = "";
                  // var posNumber = await customController.dbHelper
                  //     .getTrxStatuspending(pumpNo!);
                  // print("posNumber${posNumber}");
                  // if (customController.SerialNumber.value.substring(
                  //         customController.SerialNumber.value.length - 5) ==
                  //     posNumber) {
                  //   Get.offAllNamed("/Pumps");
                  // }
                } else {
                  customController.pumpNo.value = pumpNo!;
                  allpumpcont.xmlDataPumpListener!.cancel();
                  allpumpcont.xmlDataPumpListener = null;
                  Get.toNamed("/Nozzles", arguments: {'pumpName': pumpNo});
                }
              }
            }
          });
        } else {
          Get.offAllNamed("/TransactionStatus",
              arguments: {'pumpName': pumpName});
        }
        // await allpumpcont.checkFueling(pumpName);

        // allpumpcont.xmlDataPumpListener =
        //     customController.xmlData.listen((data) async {
        //   var document = XmlDocument.parse(data);

        //   var serviceResponse = document.getElement('ServiceResponse');
        //   if (serviceResponse != null) {
        //     var RequestType = serviceResponse.getAttribute('RequestType');
        //     var overallResult = serviceResponse.getAttribute('OverallResult');
        //     if (RequestType == 'GetFPState' && overallResult == "Success") {
        //       var pumpNo = document
        //           .findAllElements('DeviceClass')
        //           .first
        //           .getAttribute('DeviceID');
        //       var status = document.findAllElements('DeviceState').first.text;
        //       print('pumpNo-----------: $pumpNo');
        //       print('status-----------: $status');

        //       if (status == 'FDC_FUELLING' ||
        //           status == 'FDC_AUTHORISED' ||
        //           status == 'FDC_STARTED') {
        //         Get.snackbar(
        //           ("Alert").tr,
        //           ("Sorry_the_pump").tr + " ${pumpNo}" + ("is_in_progress").tr,
        //           backgroundColor: Colors.red,
        //           colorText: Colors.white,
        //         );
        //         Get.closeAllSnackbars();
        //         customController.checkFueling.value = "";
        //         var posNumber = await customController.dbHelper
        //             .getTrxStatuspending(pumpNo!);
        //         print("posNumber${posNumber}");
        //         if (customController.SerialNumber.value.substring(
        //                 customController.SerialNumber.value.length - 5) ==
        //             posNumber) {
        //           Get.offAllNamed("/TransactionStatus",
        //               arguments: {'pumpName': pumpNo});
        //         }
        //       } else {
        //         customController.pumpNo.value = pumpNo!;
        //         Get.toNamed("/Nozzles", arguments: {'pumpName': pumpNo});
        //       }
        //     }
        //   }
        // });
      },
      child: SizedBox(
        width: 170, // Set a fixed width for each card
        child: Card(
          color: themeController.isDarkMode.value
              ? color
              : Colors.white.withOpacity(0.8),
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Align(
                        alignment:
                            localController.getCurrentLang()?.languageCode ==
                                    "ar"
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Text(
                          ("PUMP").tr,
                          style: TextStyle(
                              color: themeController.isDarkMode.value
                                  ? Colors.white.withOpacity(0.8)
                                  : color,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment:
                            localController.getCurrentLang()?.languageCode ==
                                    "ar"
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle, // Circle background
                            color: Color(0xED166E36), // Green circle color
                          ),
                          child: Center(
                            child: Text(
                              pumpName,
                              style: const TextStyle(
                                fontSize: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10), // Space between rows
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Align(
                        alignment:
                            localController.getCurrentLang()?.languageCode ==
                                    "ar"
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Text(
                          ("Nozzles").tr,
                          style: TextStyle(
                            color: themeController.isDarkMode.value
                                ? Colors.white.withOpacity(0.8)
                                : color,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment:
                            localController.getCurrentLang()?.languageCode ==
                                    "ar"
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: localController
                                            .getCurrentLang()
                                            ?.languageCode ==
                                        "ar"
                                    ? Alignment.centerLeft
                                    : Alignment.centerRight,
                                child: Text(
                                  nozzlesCount,
                                  style: TextStyle(
                                      color: themeController.isDarkMode.value
                                          ? Colors.white.withOpacity(0.8)
                                          : color,
                                      fontSize: 20),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.local_gas_station_rounded,
                                color: themeController.isDarkMode.value
                                    ? Colors.white.withOpacity(0.8)
                                    : color,
                                size: 25,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                // const Row(
                //   children: [
                //     Text("Gasoline: ",
                //         style: TextStyle(color: Colors.white, fontSize: 20)),
                //     Text("95,92",
                //         style: TextStyle(color: Colors.white, fontSize: 20)),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
