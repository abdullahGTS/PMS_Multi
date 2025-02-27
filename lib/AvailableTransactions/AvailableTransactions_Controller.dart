import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:xml/xml.dart';
import '../CustomAppbar/CustomAppbar_Controller.dart';
import 'package:intl/intl.dart';

class AvailabletransactionsController extends GetxController {
  final customController = Get.find<CustomAppbarController>();
  var AvailableTrxList = [].obs;
  var NoAvailableTrx = "".obs;
  var AvailableTrxTempList = [];
  var AvailableTrxListener;
  var TrxListener;
  var SeqNoList = [].obs;
  var messagelog = "".obs;

  @override
  void onInit() async {
    super.onInit();
    // await customController.fetchTransactions();
    // displayAvailableTrx();
    // await GetAllTransaction();
    GetAllTransaction();
  }

  @override
  void onReady() {
    super.onReady();
    // GetAllTransaction();
  }

  @override
  void onClose() {
    super.onClose();
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

    AvailableTrxListener = customController.xmlData.listen((data) async {
      var document = XmlDocument.parse(data);
      var serviceResponse = document.getElement('ServiceResponse');

      if (serviceResponse != null) {
        var RequestType = serviceResponse.getAttribute('RequestType');
        var OverallResult = serviceResponse.getAttribute('OverallResult');
        if (RequestType == 'GetAvailableFuelSaleTrxs' &&
            OverallResult == 'Success') {
          var allClasses = document.findAllElements('DeviceClass');
          print('DeviceClass----->${allClasses}');
          allClasses.forEach((element) async {
            // var Type = element.getAttribute('Type');
            // var deviceID = element.getAttribute('DeviceID');
            // var PumpNo = element.getAttribute('PumpNo');
            var TransactionSeqNo = element.getAttribute('TransactionSeqNo');
            // var FusionSaleId = element.getAttribute('FusionSaleId');
            // var ReleaseToken = element.getAttribute('ReleaseToken');
            var errorCode = element.findAllElements('ErrorCode').first.text;
            if (errorCode == 'ERRCD_OK') {
              SeqNoList.add(TransactionSeqNo);
              if (AvailableTrxListener != null) {
                AvailableTrxListener!.cancel();
                AvailableTrxListener = null;
              }
              // await getTrxDetailsBySeqNo(TransactionSeqNo);
              // AvailableTrxTempList.add({
              //   // 'Type': Type,
              //   // 'NozzleNo': deviceID,
              //   'PumpNo': PumpNo,
              //   'TransactionSeqNo': TransactionSeqNo,
              //   // 'FusionSaleId': FusionSaleId,
              //   // 'ReleaseToken': ReleaseToken,
              //   'State': "Payable",
              //   'ProductName':
              //       customController.getProductName(int.parse(PumpNo!)),
              // });
            } else {
              NoAvailableTrx.value = "No_Available_Transactions".tr;
            }
          });
        }
      }
    });
    customController.socketConnection
        .sendMessage(customController.getXmlHeader(xmlContentreq));
    await Future.delayed(Duration(seconds: 1));
    print('tetstetstetste${SeqNoList.value}');
    await getTrxDetailsBySeqNo();
    // AvailableTrxList.value = AvailableTrxTempList;
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

  TransactionDetails(TrxSeqNo) {
    print('TrxSeqNo---->${TrxSeqNo}');

    Get.toNamed('/Availabletrxdetails', arguments: {'TrxSeqNo': TrxSeqNo});
  }

  getTrxDetailsBySeqNo() async {
    AvailableTrxTempList = [];

    customController.trxAttendant.value = customController.managershift.value;
    // print('AbdullahSeqNoListSeqNoListMichael${SeqNoList.value}');
    TrxListener = customController.xmlData.listen((data) async {
      var document = XmlDocument.parse(data);
      var serviceResponse = document.getElement('ServiceResponse');

      if (serviceResponse != null) {
        var RequestType = serviceResponse.getAttribute('RequestType');
        var OverallResult = serviceResponse.getAttribute('OverallResult');
        if (RequestType == 'GetFuelSaleTrxDetailsByNo' &&
            OverallResult == 'Success') {
          messagelog.value += data;
          var AuthorisationApplicationSender = document
              .findAllElements('AuthorisationApplicationSender')
              .first
              .text;
          print(
              "AuthorisationApplicationSender${AuthorisationApplicationSender}");

          customController.counterTrans++;
          customController
              .updateCounterTrans(customController.counterTrans.value);
          var pumpNo = document
                  .findAllElements('DeviceClass')
                  .first
                  .getAttribute('PumpNo') ??
              '';

          var nozzleNo = document
                  .findAllElements('DeviceClass')
                  .first
                  .getAttribute('NozzleNo') ??
              '';
          var transactionSeqNo = document
                  .findAllElements('DeviceClass')
                  .first
                  .getAttribute('TransactionSeqNo') ??
              '';

          print("pumpNo${pumpNo}");
          print("nozzleNo${nozzleNo}");
          print("transactionSeqNo${transactionSeqNo}");
          var errorcode = document.findAllElements('ErrorCode').first.text;
          print("errorcodeerrorcode-------${errorcode}");
          var amountVal =
              double.tryParse(document.findAllElements('Amount').first.text) ??
                  0.0;
          var volume =
              double.tryParse(document.findAllElements('Volume').first.text) ??
                  0.0;
          var unitPrice = double.tryParse(
                  document.findAllElements('UnitPrice').first.text) ??
              0.0;
          var startTimeStamp = document
                  .findAllElements('DeviceClass')
                  .first
                  .findAllElements('StartTimeStamp')
                  .first
                  .text ??
              '';
          var endTimeStamp = document
                  .findAllElements('DeviceClass')
                  .first
                  .findAllElements('EndTimeStamp')
                  .first
                  .text ??
              '';
          var productName = document.findAllElements('ProductName').first.text;

          AvailableTrxList.add({
            'Start_Date': "${startTimeStamp}",
            'pumpNo': "${pumpNo}",
            'nozzleNo': "${nozzleNo}",
            'productName': '${productName}',
            'transactionSeqNo': transactionSeqNo,
            'amountVal': '${amountVal}',
            'volume': '${volume}',
            'unitPrice': '${unitPrice}',
            'AuthorisationApplicationSender':
                '${AuthorisationApplicationSender}',
            'End_Date': '${endTimeStamp}',
            'POS': '${AuthorisationApplicationSender}',
          });
        }
      }
    });

    // AvailableTrxTempList.sort((a, b) {
    //   final aSeq = int.tryParse(a['transactionSeqNo'] as String) ?? 0;
    //   final bSeq = int.tryParse(b['transactionSeqNo'] as String) ?? 0;
    //   return bSeq.compareTo(aSeq); // For descending order
    // });
    // AvailableTrxList.value = AvailableTrxTempList;
    for (var TrxSeqNo in SeqNoList.value) {
      print('TrxSeqNoTrxSeqNo${TrxSeqNo}');
      customController.iD++;

      // Get the current time formatted for the XML
      String currentTime =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(DateTime.now());

      String xmlContentreq = '''
<?xml version="1.0" encoding="utf-8" ?>
<ServiceRequest RequestType="GetFuelSaleTrxDetailsByNo" ApplicationSender="${customController.SerialNumber.value.substring(customController.SerialNumber.value.length - 5)}"
WorkstationID="PMS" RequestID="${customController.iD}" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xsi:noNamespaceSchemaLocation="FDC_GetFuelSaleTrxDetailsByNo_Request.xsd">
<POSdata>
<POSTimeStamp>$currentTime</POSTimeStamp>
<DeviceClass Type="FP" DeviceID="*" TransactionSeqNo="${TrxSeqNo}">
</DeviceClass>
</POSdata>
</ServiceRequest>
''';
      customController.socketConnection
          .sendMessage(customController.getXmlHeader(xmlContentreq));
      await Future.delayed(Duration(seconds: 1));
    }

    // print("AvailableTrxTempList${AvailableTrxTempList}");

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
    // print("AvailableTrxTempList${AvailableTrxTempList}");
    // AvailableTrxTempList.sort((a, b) {
    //   final aSeq = int.tryParse(a['transactionSeqNo'] as String) ?? 0;
    //   final bSeq = int.tryParse(b['transactionSeqNo'] as String) ?? 0;
    //   return bSeq.compareTo(aSeq); // For descending order
    // });
    // AvailableTrxList.value = AvailableTrxTempList;
    // if (TrxListener != null) {
    //   TrxListener!.cancel();
    //   TrxListener = null;
    // }
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
              'log'.tr,
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
                Obx(() {
                  return Text(
                    messagelog.value,
                    style: TextStyle(color: Colors.white, fontSize: 7),
                  );
                })
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
                  onPressed: () {
                    messagelog.value = "";
                    // Close the dialog
                  },
                  child: Container(
                    width: 75,
                    height: 50,
                    decoration: BoxDecoration(
                        color: const Color(0xFF2B2B2B),
                        borderRadius: BorderRadius.circular(7)),
                    child: Center(
                      child: Text('clear'.tr,
                          style: TextStyle(color: Colors.white, fontSize: 20)),
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
}
