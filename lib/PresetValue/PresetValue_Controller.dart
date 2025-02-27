import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xml/xml.dart';
import 'dart:convert'; // For encoding and decoding data
import 'dart:typed_data';

import '../CustomAppbar/CustomAppbar_Controller.dart';
import '../Models/transactiontable.dart';
import '../models/database_helper.dart';

class PresetvalueController extends GetxController {
  late String pumpName;
  late String nozzleNum;
  late String valueargs; // Ensure you have a value to display
  late String product_number;
  // Ensure you have a value to display
  final presetvalueController = TextEditingController();
  var value = '';
  var dropdownvalue = 'Price';
  String? NozzelNum = ''; // Nullable variable
  String? pumpnum = ''; // Nullable variable
  // final customController = Get.put(CustomAppbarController());
  final customController = Get.find<CustomAppbarController>();
  var isDropdownDisabled = false.obs; // Observable for dropdown disabled state
  var isInputDisabled = false.obs; // Observable for input disabled state
  final RxList<String> cardValues = [
    'Full_Tank'.tr,
    '200 ' + 'EGP'.tr,
    '150 ' + 'EGP'.tr,
    '100 ' + 'EGP'.tr
  ].obs;
  var andriodid = ''.obs;
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void onInit() async {
    super.onInit();
    andriodid.value = customController.SerialNumber.value
        .substring(customController.SerialNumber.value.length - 5);

    if (customController.issupervisormaiar.value) {
      presetvalueController.text = "22"; // Set the input text
      updatedropdown("Liter"); // Call the dropdown update method
      disableDropdownAndInput();
      value = "22";
    }
    await getNozzleName();
    await getArguments();
    // await customController.startConnection(customController.socketConnection);
    Get.closeAllSnackbars();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void disableDropdownAndInput() {
    isDropdownDisabled.value = true;
    isInputDisabled.value = true;
    print("Dropdown and input disabled.");
  }

  void updateCardValues(String dropdownSelection) {
    if (dropdownSelection == 'Price') {
      cardValues.value = ['Full_Tank'.tr, '200 ', '150 ', '100 '];
    } else if (dropdownSelection == 'Liter') {
      cardValues.value = ['Full_Tank'.tr, '30LIT', '15LIT', '5LIT'];
    }
  }

  Future<String?> getNozzleName() async {
    final prefs = await SharedPreferences.getInstance();
    NozzelNum = prefs.getString('NozzelName');
    pumpnum = prefs.getString('pumpName');
    print("object${prefs.getString('pumpName')}");
    return prefs.getString('NozzelName');
  }

  getArguments() {
    final Map<String, String> args = Get.arguments as Map<String, String>;
    pumpName = args['pumpName'] ?? 'Unknown Pump';
    nozzleNum = args['nozzleNum'] ?? 'Unknown Nozzle';
    product_number = args['product_number'] ?? 'Unknown Nozzle';
    print("product_numbersssssssssss${product_number}");
    valueargs = args['value'] ?? '0'; // Initialize value if needed
  }

  Auturizednozzle() {
    print("teeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    // Increment RequestID
    customController.iD++;

    // Get the current time formatted for the XML
    String currentTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now());

    // Debugging outputs to ensure values are correct
    print("Value----: $value");
    print("Dropdown Value---------: $dropdownvalue");
    print("pumpName Value-----------: $pumpName");
    if (value == 0) {
      Get.snackbar(
        'Error'.tr,
        'Please_enter_your_Amount'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } else {
      String xmlContentreq = '''
<?xml version="1.0"?>
<ServiceRequest xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:xsd="http://www.w3.org/2001/XMLSchema" RequestType="AuthoriseFuelPoint"
ApplicationSender="${customController.SerialNumber.value.substring(customController.SerialNumber.value.length - 5)}" WorkstationID="PMS" RequestID="${customController.iD}">
  <POSdata>
    <POSTimeStamp>$currentTime</POSTimeStamp>
    <DeviceClass Type="FP" DeviceID="${pumpName}">
      ${dropdownvalue == 'Price' ? '<MaxTrxAmount>$value</MaxTrxAmount><MaxTrxVolume>0</MaxTrxVolume>' : '<MaxTrxAmount>0</MaxTrxAmount><MaxTrxVolume>$value</MaxTrxVolume>'}
      <FuelMode ModeNo="1" />
      <ReleasedProducts>
        <Product ProductNo="${product_number}" />
      </ReleasedProducts>
      <ReleaseToken>01</ReleaseToken>
      <LockFuelSaleTrx>False</LockFuelSaleTrx>
      <ReservingDeviceId>200</ReservingDeviceId>
      <FuellingType>2</FuellingType>
    </DeviceClass>
  </POSdata>
</ServiceRequest>
''';

      // Log the XML for debugging purposes

      // Send the constructed XML message through socket
      customController.socketConnection
          .sendMessage(customController.getXmlHeader(xmlContentreq));
    }
    // checktransseq();
    // Timer.periodic(const Duration(seconds: 3), (timer) async {
    //   checkFueling(pumpName);
    // });

    // Construct the XML content with dynamic values based on the dropdown selection

    // customController.payableTransaction.value = true;
  }

  GetNextTrxSeqNo() {
    // Increment RequestID
    customController.iD++;

    // Get the current time formatted for the XML
    String currentTime =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now());

    String xmlContentreq = '''
<?xml version="1.0" encoding="utf-8" ?>
<ServiceRequest RequestType="GetNextTransactionSequenceNo" ApplicationSender="${customController.SerialNumber.value.substring(customController.SerialNumber.value.length - 5)}"
WorkstationID="PMS" RequestID="${customController.iD}" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:noNamespaceSchemaLocation="FDC_GetNextTransactionSequenceNo_Request.xsd">
<POSdata>
<POSTimeStamp>$currentTime</POSTimeStamp>
</POSdata>
</ServiceRequest>
''';

    // Send the constructed XML message through socket
    customController.socketConnection
        .sendMessage(customController.getXmlHeader(xmlContentreq));
  }

//   checkFueling(pumpName) {
//     print("teeeeeeeeeeeeeeeeeeeeeeeeeeeee");
//     print("id1${customController.iD}");
//     // Increment RequestID
//     customController.iD++;
//     print("id2${customController.iD}");

//     // Get the current time formatted for the XML
//     String currentTime =
//         DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now());

//     String xmlContentreq = '''
// <?xml version="1.0"?>
// <ServiceRequest xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
// xmlns:xsd="http://www.w3.org/2001/XMLSchema" RequestType="GetCurrentFuellingStatus"
// ApplicationSender="${customController.androidId_id.split('.').join().substring(0, 5)}" WorkstationID="PMS" RequestID="${customController.iD}">
//  <POSdata>
//  <POSTimeStamp>$currentTime</POSTimeStamp>
//  <DeviceClass Type="FP" DeviceID="$pumpName" />
//  </POSdata>
// </ServiceRequest>
// ''';
//     print("xmlContentreqcheckFueling${xmlContentreq}");

//     // Log the XML for debugging purposes

//     // Send the constructed XML message through socket
//     customController.socketConnection
//         .sendMessage(customController.getXmlHeader(xmlContentreq));
//   }

//   checktransseq() {
//     print("teeeeeeeeeeeeeeeeeeeeeeeeeeeee");
//     print("id1${customController.iD}");
//     // Increment RequestID
//     customController.iD++;
//     print("id2${customController.iD}");

//     // Get the current time formatted for the XML
//     String currentTime =
//         DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now());
//     String xl = '''<?xml version="1.0" encoding="utf-8" ?>
// <ServiceRequest RequestType="GetFuelSaleTrxDetailsByNo" ApplicationSender="${customController.androidId_id.split('.').join().substring(0, 5)}"
// WorkstationID="PMS" RequestID="${customController.iD}" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
// xsi:noNamespaceSchemaLocation="FDC_GetFuelSaleTrxDetailsByNo_Request.xsd">
// <POSdata>
// <POSTimeStamp>$currentTime</POSTimeStamp>
// <DeviceClass Type="FP" DeviceID="*" TransactionSeqNo="565">
// </DeviceClass>
// </POSdata>
// </ServiceRequest>''';
// //     String xmlContentreq = '''
// // <?xml version="1.0"  encoding="utf-8" ?>
// // <ServiceRequest RequestType="GetFuelSaleTrxDetailsByNo" ApplicationSender="${customController.androidId_id.split('.').join().substring(0, 5)}"
// //  WorkstationID="PMS" RequestID="${customController.iD}"
// //  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
// // xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="FDC_GetFuelSaleTrxDetailsByNo_Request.xsd"
// //   >
// //  <POSdata>
// //  <POSTimeStamp>$currentTime</POSTimeStamp>
// //  <DeviceClass Type="FP" DeviceID="$pumpName" TransactionSeqNoh="565" />
// //  </POSdata>
// // </ServiceRequest>
// // ''';
//     print("xmlContentreqcheckFueling${xl}");

//     // Log the XML for debugging purposes

//     // Send the constructed XML message through socket
//     customController.socketConnection
//         .sendMessage(customController.getXmlHeader(xl));
//   }

  Map<String, String> getFormattedDate() {
    DateTime now = DateTime.now();
    var date = {
      'month':
          DateFormat('MMMM').format(now), // Full month name (e.g., "October")
      'day': DateFormat('d').format(now), // Day of the month (e.g., "16")
      'year': DateFormat('yyyy').format(now), // Full year (e.g., "2024")
    };
    return date; // Example: "Monday, October 16, 2024"
  }

  // String getFormattedTime() {
  //   DateTime now = DateTime.now();
  //   var date = {
  //     'hour': DateFormat('h').format(now), // Full month name (e.g., "October")
  //     'minute': DateFormat('mm').format(now), // Day of the month (e.g., "16")
  //     'format': DateFormat('a').format(now), // Full year (e.g., "2024")
  //   };
  //   return DateFormat('h:mm a').format(now); // Example: "10:35 AM"
  // }

  Map<String, String> getFormattedTime() {
    DateTime now = DateTime.now();
    var date = {
      'hour': DateFormat('h').format(now), // Example: "10"
      'minute': DateFormat('mm').format(now), // Example: "35"
      'format': DateFormat('a').format(now), // Example: "AM"
    };
    return date;
  }

  void updateValue() {
    print('presetvalueController.text${presetvalueController.text}');

    value = presetvalueController.text; // Update observable value
  }

  updatedropdown(String value) {
    print("dropdown: $value");
    dropdownvalue = value; // Assuming dropdownvalue is a String variable
    // Update any other state as needed
    // this.value =
    //     presetvalueController.text; // Ensure presetvalueController is defined
    // You might want to notify listeners or update UI here if needed
  }

  thevalue(String Text, BuildContext context) async {
    print("dropdownvalue------------??${dropdownvalue}");
    RegExp regex = RegExp(r'\d+');

    // Extract the first match
    String? number = regex.firstMatch(Text)?.group(0);

    if (number != null) {
      print("number${number}");
      value = number; // Output: 100
    } else {
      print("No number found");
    }
    // print("TTTTTTTTTTT${Text}");

    // print(Text);
    // value = Text;
    // customController.amountVal.value = double.parse(Text);
    // await Auturizednozzle();

    await GetNextTrxSeqNo();
    // Only navigate if the value is valid

    customController.xmlData.listen((data) async {
      var document = XmlDocument.parse(data);
      var serviceResponse = document.getElement('ServiceResponse');
      if (serviceResponse != null) {
        var RequestType = serviceResponse.getAttribute('RequestType');
        var OverallResult = serviceResponse.getAttribute('OverallResult');
        if (RequestType == 'GetNextTransactionSequenceNo' &&
            OverallResult == 'Success') {
          var tempTransactionSeqNo = document
                  .findAllElements('FuelSale')
                  .first
                  .getAttribute('NextTransactionSeqNo') ??
              '';
          print('abdullah Here${tempTransactionSeqNo}');
          customController.transactionSeqNo.value = tempTransactionSeqNo;
          print('Michael Here${customController.transactionSeqNo.value}');

          // andriodid = customController.androidId_id
          //     .split('.')
          //     .join()
          //     .substring(0, 5);
          // presalecontroller.presetvalueController.text = '';
          Get.offAllNamed('/Home'); // Get.snackbar(
          //   'Get Seq Number',
          //   '${tempTransactionSeqNo}',
          //   snackPosition: SnackPosition.TOP,
          //   backgroundColor: Colors.green,
          //   colorText: Colors.white,
          // );
        }
      }
    });
    await Auturizednozzle();
    print("pumpfooter${customController.pumpNo.value}");
  }

  void showExtractedValuesPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 24, 24, 24),
          titlePadding: EdgeInsets.zero,
          title: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              color: const Color(0xFF186937),
            ),
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Text(
              'Validate_Your_Transaction'.tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text("Product".tr + ": ",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                          customController
                                  .getProductName(int.parse(product_number))
                                  .toString()
                                  .tr ??
                              'No Product',
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text("U/P".tr + "",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                          '${customController.getProductPrice(int.parse(product_number))} ' +
                                  "EGP".tr ??
                              'No Product',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20)),
                    )
                  ],
                ),
                dropdownvalue == "Price"
                    ? Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text("Price".tr + ": ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                                value.tr == " " + "Full_Tank".tr
                                    ? "9999.99"
                                    : value.tr,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          )
                        ],
                      )
                    : Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text("Qty".tr + ": ",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(value,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 20)),
                          )
                        ],
                      ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text("Pump".tr + ": ",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(pumpName,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20)),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text("Nozzle".tr + ": ",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(nozzleNum,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20)),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text("Day".tr + ": ",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                          getFormattedDate()['day'].toString() +
                              " " +
                              getFormattedDate()['month'].toString().tr +
                              " , " +
                              getFormattedDate()['year'].toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20)),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text("Time".tr + ": ",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                          getFormattedTime()['hour'].toString() +
                              " : " +
                              getFormattedTime()['minute'].toString() +
                              " " +
                              getFormattedTime()['format'].toString().tr,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20)),
                    )
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // Distribute space evenly between buttons
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Container(
                    width: 75,
                    height: 50,
                    decoration: BoxDecoration(
                        color: const Color(0xFF2B2B2B),
                        borderRadius: BorderRadius.circular(7)),
                    child: Center(
                      child: Text('Cancel'.tr,
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      presetvalueController.text = '';
                      // await Auturizednozzle(); // Ensure this function is defined and works as expected
                      await thevalue(value, context);
                      // Get.toNamed('/Fueling');
                    } catch (e) {
                      print("Error".tr + ": $e"); // Handle any errors
                      // Optionally, show an error message to the user
                    }
                  },
                  child: Container(
                    width: 100,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF186937),
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Center(
                      child: Text(
                        'Confirm'.tr,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  //save the Trxstatus

  // Save Transaction For Cash
  saveTrxStatus() async {
    try {
      // Create a FuelSale instance with the current data
      var result = await dbHelper.lastShift();
      print("customController.pumpNo.value${customController.pumpNo.value}");
      print("customController.nozzleNo.value${nozzleNum}");
      print(
          "customController.transactionSeqNo.value${customController.transactionSeqNo.value}");
      print("customController.productNo.value${product_number}");
      print("customController.amountVal.value${presetvalueController.text}");
      print(
          "customController.unitPrice.value${customController.getProductPrice(int.parse(product_number))}");

      print(
          "customController.Product.value${customController.getProductName(int.parse(product_number))}");
      print("shift_id${result?['id']}");

      var trxStatus = TrxStatus(
        timeStamp: DateTime.now()
            .toString(), // Or use the parsed timestamp if available
        pumpNo: customController.pumpNo.value.toString(),
        nozzleNo: nozzleNum.toString(),
        transactionSeqNo: customController.transactionSeqNo.value.toString(),
        status: 'pending',
        productNo: product_number,
        amount: double.parse(presetvalueController.text),
        unitPrice: double.parse(
          customController.getProductPrice(int.parse(product_number)) ?? "0.0",
        ),
        productName:
            customController.getProductName(int.parse(product_number)) ??
                'No Product',
        pos: customController.SerialNumber.value
            .substring(customController.SerialNumber.value.length - 5),
        shift_id: result?['id'],
      );

      // Insert the FuelSale instance into the database
      await dbHelper.insertTrxStatus(trxStatus.toMap());
      print("trxStatus${trxStatus}");
    } catch (e) {
      print('Error saving transaction data: $e');
    }
  }
}
