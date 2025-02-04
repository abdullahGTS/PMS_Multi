// ignore_for_file: unrelated_type_equality_checks, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../CustomAppbar/CustomAppbar_Controller.dart';
import '../Pumps/Pumps_Controller.dart';
import '../Theme/Theme_Controller.dart';
import '../TransactionStatus/TransactionStatus_Controller.dart';
import 'package:xml/xml.dart';

class FooterTrxStatus extends StatelessWidget {
  // final customController = Get.put(CustomAppbarController());
  final customController = Get.find<CustomAppbarController>();
  final transactionStatusController = Get.find<TransactionStatusController>();
  final allpumpcont = Get.put(PumpsController());
  var themeController = Get.find<ThemeController>();
  var color = Color.fromARGB(255, 24, 24, 24);

  var andriodid;
  @override
  Widget build(BuildContext context) {
    return Stack(
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
          color: Colors.white.withOpacity(0),
          // width: double.infinity,
          padding: const EdgeInsets.all(16.0), // Add padding if needed
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center the content in the Row
            children: [
              GestureDetector(
                onTap: () {
                  Get.toNamed("/Pumps");
                },
                child: _buildCircleIcon(Icons.arrow_back_rounded, Colors.white),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  // transactionStatusController
                  //     .getTrxStatus(Get.arguments['pumpName']);
                  // Get.offAllNamed("/TransactionStatus",
                  //     arguments: {'pumpName': Get.arguments['pumpName']});
                  await transactionStatusController.GetAllTransaction(
                      Get.arguments['pumpName']);
                },
                child: _buildCircleIcon(Icons.refresh_rounded,
                    Colors.white), // New logo in the center
              ), // Spacer to push the logo to the center
              const Spacer(), // Spacer to push the fuel icon to the right
              GestureDetector(
                  onTap: () async {
                    await transactionStatusController.GetAllTransaction(
                        Get.arguments['pumpName']);
                    // await Future.delayed(Duration(milliseconds: 200));
                    await allpumpcont.checkFueling(Get.arguments['pumpName']);

                    allpumpcont.xmlDataPumpListener =
                        customController.xmlData.listen((data) async {
                      var document = XmlDocument.parse(data);

                      var serviceResponse =
                          document.getElement('ServiceResponse');
                      if (serviceResponse != null) {
                        var RequestType =
                            serviceResponse.getAttribute('RequestType');
                        var overallResult =
                            serviceResponse.getAttribute('OverallResult');
                        if (RequestType == 'GetFPState' &&
                            overallResult == "Success") {
                          var pumpNo = document
                              .findAllElements('DeviceClass')
                              .first
                              .getAttribute('DeviceID');
                          var status = document
                              .findAllElements('DeviceState')
                              .first
                              .text;
                          print('pumpNo-----------: $pumpNo');
                          print('status-----------: $status');

                          if (status == 'FDC_FUELLING' ||
                              status == 'FDC_AUTHORISED' ||
                              status == 'FDC_STARTED') {
                            Get.snackbar(
                              ("Alert").tr,
                              ("Sorry_the_pump").tr +
                                  " ${pumpNo} " +
                                  ("is_in_progress").tr,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            // Get.closeAllSnackbars();
                            customController.checkFueling.value = "";
                            allpumpcont.xmlDataPumpListener!.cancel();
                            allpumpcont.xmlDataPumpListener = null;
                          } else {
                            print(
                                "customController.pumpNo.value ${customController.pumpNo.value}-${Get.arguments['pumpName']}----${transactionStatusController.AvailableTrxList.value.isNotEmpty}--${transactionStatusController.AvailableTrxTempList.isNotEmpty}");
                            print(
                                "customController.argument.value${Get.arguments['pumpName']}");
                            print(
                                "pumpNocustomController${transactionStatusController.AvailableTrxList.value.isNotEmpty}");
                            customController.pumpNo.value = pumpNo!;

                            if (transactionStatusController
                                    .AvailableTrxTempList.isNotEmpty &&
                                pumpNo == Get.arguments['pumpName']) {
                              // if (transactionStatusController
                              //         .AvailableTrxList.value.isNotEmpty &&
                              //     pumpNo == Get.arguments['pumpName']) {
                              // allpumpcont.xmlDataPumpListener?.cancel();
                              Get.snackbar(
                                ("Alert").tr,
                                ("You_should_pay_transaction_first").tr,
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                              transactionStatusController.GetAllTransaction(
                                  pumpNo);
                              // Get.offAllNamed("/TransactionStatus",
                              //     arguments: {'pumpName': pumpNo});
                              allpumpcont.xmlDataPumpListener!.cancel();
                              allpumpcont.xmlDataPumpListener = null;
                            } else {
                              allpumpcont.xmlDataPumpListener!.cancel();
                              allpumpcont.xmlDataPumpListener = null;
                              Get.toNamed("/Nozzles",
                                  arguments: {'pumpName': pumpNo});
                            }
                          }
                          // allpumpcont.xmlDataPumpListener!.cancel();
                          // allpumpcont.xmlDataPumpListener = null;
                        }
                      }
                    });
                  },
                  child: _buildCircleIcon(Icons.local_gas_station,
                      Colors.white) // Fuel on the right
                  ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircleImage(String assetPath) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: themeController.isDarkMode.value
            ? color
            : Colors.white
                .withOpacity(0.5), // Background color for the circular area
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
              color: Colors.white.withOpacity(0.3),
              offset: Offset(0, 8),
              blurRadius: 3,
              spreadRadius: 0)
        ],
      ),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(assetPath),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Future<void> _saveSalepint(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('salepint', value); // Save salepint value
  }

  Widget _buildCircleIcon(IconData iconData, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(
          10.0), // Add 10 pixels of padding for the circular container
      decoration: BoxDecoration(
        color: themeController.isDarkMode.value
            ? color
            : Colors.white
                .withOpacity(0.5), // Background color for the circular area
        shape: BoxShape.circle, // Makes the container circular
        boxShadow: [
          BoxShadow(
              color: Colors.white.withOpacity(0.3),
              offset: Offset(0, 8),
              blurRadius: 3,
              spreadRadius: 0)
        ],
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
}


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../Home/home_controller.dart';
// import '../allpump/allpump_controller.dart';
// import '../pre sale val/pre_sale_value_controller.dart';

// class FooterPresetval extends StatelessWidget {
//   final presalecontroller = Get.find<PreSaleValueController>();
//   final homeController = Get.find<HomeController>();

//   @override
//   Widget build(BuildContext context) {
//     // Lazy load the controller if it hasn't been instantiated
//     Get.lazyPut<AllPumpController>(() => AllPumpController());

//     return Container(
//       color: const Color.fromARGB(255, 24, 24, 24),
//       width: double.infinity,
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         mainAxisAlignment:
//             MainAxisAlignment.center, // Center the content in the Row
//         children: [
//           GestureDetector(
//             onTap: () {
//               Navigator.pushNamed(context, '/AllPump');
//             },
//             child: _buildCircleImage('media/leftarrow.png'),
//           ),
//           const Spacer(),
//           _buildCircleImage('media/new_logo.png'),
//           const Spacer(),
//           GestureDetector(
//             onTap: () async {
//               await _saveSalepint(homeController.salepint.value);

//               if (presalecontroller.value != 0 &&
//                   presalecontroller.value.isNotEmpty) {
//                 homeController.salepint.value++;
//                 await presalecontroller.Auturizednozzle();
//                 Navigator.pushNamed(context, '/ChoosePayment',
//                     arguments: presalecontroller.value);
//                 presalecontroller.presetvalueController.clear();
//               } else {
//                 _showFullPageDialog(context);
//               }
//             },
//             child: _buildCircleImage('media/start.png'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showFullPageDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return Dialog(
//           backgroundColor: Colors.transparent,
//           child: Container(
//             color: const Color(0xFF2B2B2B),
//             padding: const EdgeInsets.all(10),
//             child: SingleChildScrollView(
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   buildPumpRow(context, '1', 'media/petro.png'),
//                   const SizedBox(height: 20),
//                   buildPumpRow(context, '2', 'media/petro.png'),
//                   const SizedBox(height: 20),
//                   buildPumpRow(context, '3', 'media/petro.png'),
//                   const SizedBox(height: 20),
//                   buildPumpRow(context, '4', 'media/petro.png'),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget buildPumpRow(BuildContext context, String pumpName, String imagePath) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         buildPumpCard(context, pumpName, imagePath),
//       ],
//     );
//   }

//   Widget buildPumpCard(
//       BuildContext context, String pumpName, String imagePath) {
//     final allpumpcont = Get.find<AllPumpController>();
//     return GestureDetector(
//       onTap: () async {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('pumpName', pumpName);
//         allpumpcont.showPumpDialog(context, pumpName);
//       },
//       child: SizedBox(
//         width: 300,
//         child: Card(
//           color: const Color.fromARGB(255, 24, 24, 24),
//           elevation: 5,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Image.asset(
//                         imagePath,
//                         width: 50,
//                         height: 50,
//                       ),
//                       const SizedBox(width: 30),
//                       Container(
//                         width: 40,
//                         height: 40,
//                         decoration: const BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Color(0xED166E36),
//                         ),
//                         child: Center(
//                           child: Text(
//                             pumpName,
//                             style: const TextStyle(
//                               fontSize: 25,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   const Row(
//                     children: [
//                       Text("Nozzle: ",
//                           style: TextStyle(color: Colors.white, fontSize: 20)),
//                       SizedBox(width: 20),
//                       Text("2",
//                           style: TextStyle(color: Colors.white, fontSize: 20)),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   const Row(
//                     children: [
//                       Text("Gasoline: ",
//                           style: TextStyle(color: Colors.white, fontSize: 20)),
//                       Text("95",
//                           style: TextStyle(color: Colors.white, fontSize: 20)),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCircleImage(String assetPath) {
//     return Container(
//       padding: const EdgeInsets.all(10.0),
//       decoration: const BoxDecoration(
//         color: Color(0xFF2B2B2B),
//         shape: BoxShape.circle,
//       ),
//       child: Container(
//         width: 60,
//         height: 60,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           image: DecorationImage(
//             image: AssetImage(assetPath),
//             fit: BoxFit.contain,
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _saveSalepint(int value) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setInt('salepint', value);
//   }
// }
