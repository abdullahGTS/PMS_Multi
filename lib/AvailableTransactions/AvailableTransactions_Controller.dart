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
              await getTrxDetailsBySeqNo(TransactionSeqNo);
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

  getTrxDetailsBySeqNo(TrxSeqNo) async {
    customController.trxAttendant.value = customController.managershift.value;
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

    TrxListener = customController.xmlData.listen((data) async {
      var document = XmlDocument.parse(data);
      var serviceResponse = document.getElement('ServiceResponse');
      if (serviceResponse != null) {
        var RequestType = serviceResponse.getAttribute('RequestType');
        var OverallResult = serviceResponse.getAttribute('OverallResult');
        if (RequestType == 'GetFuelSaleTrxDetailsByNo' &&
            OverallResult == 'Success') {
          customController.statevalue.value =
              document.findAllElements('State').first.text;
          print("statevalue${customController.statevalue}");

          customController.AuthorisationApplicationSender.value = document
              .findAllElements('AuthorisationApplicationSender')
              .first
              .text;
          print(
              "AuthorisationApplicationSender${customController.AuthorisationApplicationSender}");

          customController.counterTrans++;
          customController
              .updateCounterTrans(customController.counterTrans.value);
          // Send counterTrans to HomeController
          customController.fdCTimeStamp.value =
              document.findAllElements('FDCTimeStamp').first.text;

          customController.type.value = document
                  .findAllElements('DeviceClass')
                  .first
                  .getAttribute('Type') ??
              '';

          customController.deviceID.value = document
                  .findAllElements('DeviceClass')
                  .first
                  .getAttribute('DeviceID') ??
              '';

          customController.pumpNo.value = document
                  .findAllElements('DeviceClass')
                  .first
                  .getAttribute('PumpNo') ??
              '';

          customController.nozzleNo.value = document
                  .findAllElements('DeviceClass')
                  .first
                  .getAttribute('NozzleNo') ??
              '';
          customController.transactionSeqNo.value = document
                  .findAllElements('DeviceClass')
                  .first
                  .getAttribute('TransactionSeqNo') ??
              '';
          customController.fusionSaleId.value = document
                  .findAllElements('DeviceClass')
                  .first
                  .getAttribute('FusionSaleId') ??
              '';
          print("fdCTimeStamp${customController.fdCTimeStamp.value}");

          print("type${customController.type.value}");
          print("deviceID${customController.deviceID.value}");
          print("pumpNo${customController.pumpNo.value}");
          print("nozzleNo${customController.nozzleNo.value}");
          print("transactionSeqNo${customController.transactionSeqNo.value}");

          // fusionSaleId.value = document
          //         .findAllElements('DeviceClass')
          //         .first
          //         .getAttribute('FusionSaleId') ??
          //     '';
          customController.releaseToken.value =
              document.findAllElements('ReleaseToken').first.text;
          // completionReason.value =
          //     document.findAllElements('CompletionReason').first.text;
          customController.fuelMode.value = document
                  .findAllElements('FuelMode')
                  .first
                  .getAttribute('ModeNo') ??
              '';
          customController.productUM.value =
              document.findAllElements('ProductUM').first.text ?? '';

          customController.productNo.value =
              document.findAllElements('ProductNo').first.text;
          customController.amountVal.value =
              double.tryParse(document.findAllElements('Amount').first.text) ??
                  0.0;
          customController.volume.value =
              double.tryParse(document.findAllElements('Volume').first.text) ??
                  0.0;
          customController.unitPrice.value = double.tryParse(
                  document.findAllElements('UnitPrice').first.text) ??
              0.0;
          customController.volumeProduct1.value = double.tryParse(
                  document.findAllElements('VolumeProduct1').first.text) ??
              0.0;
          customController.volumeProduct2.value = double.tryParse(
                  document.findAllElements('VolumeProduct2').first.text) ??
              0.0;
          customController.productNo1.value =
              int.tryParse(document.findAllElements('ProductNo1').first.text) ??
                  0;
          // productUM.value = document.findAllElements('ProductUM').first.text;
          customController.productName.value = customController.getProductName(
                  int.parse(customController.productNo.value)) ??
              'No Product';
          // productName.value = document.findAllElements('ProductName').first.text;
          customController.blendRatio.value =
              int.tryParse(document.findAllElements('BlendRatio').first.text) ??
                  0;
          customController.startTimeStamp.value =
              document.findAllElements('StartTimeStamp').first.text ?? "";
          customController.endTimeStamp.value =
              document.findAllElements('EndTimeStamp').first.text ?? "";
        }
      }
    });
    customController.socketConnection
        .sendMessage(customController.getXmlHeader(xmlContentreq));
    await Future.delayed(Duration(seconds: 1));

    AvailableTrxTempList.add({
      'Start_Date': "${customController.fdCTimeStamp.value}",
      'pumpNo': "${customController.pumpNo.value}",
      'nozzleNo': "${customController.nozzleNo.value}",
      'productName':
          '${customController.getProductNameByNozzleNum(int.parse(customController.nozzleNo.value!))}',
      'transactionSeqNo': TrxSeqNo,
      'amountVal': '${customController.amountVal.value}',
      'volume': '${customController.volume.value}',
      'unitPrice': '${customController.unitPrice.value}',
      'AuthorisationApplicationSender':
          '${customController.AuthorisationApplicationSender.value}',
      'End_Date': '${customController.endTimeStamp.value}',
      'POS': '${customController.AuthorisationApplicationSender.value}',
    });

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
    print("AvailableTrxTempList${AvailableTrxTempList}");
    AvailableTrxTempList.sort((a, b) {
      final aSeq = int.tryParse(a['transactionSeqNo'] as String) ?? 0;
      final bSeq = int.tryParse(b['transactionSeqNo'] as String) ?? 0;
      return bSeq.compareTo(aSeq); // For descending order
    });
    AvailableTrxList.value = AvailableTrxTempList;
  }
}
