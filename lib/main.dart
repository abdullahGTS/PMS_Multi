import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pms/Local/Local_Controller.dart';

import 'package:pms/Report/Report_Binding.dart';
import 'package:pms/ReportShifts/ReportShift_Binding.dart';

import 'AuthorizedPage/AuthorizedPage.dart';
import 'AuthorizedPage/Authorized_Binding.dart';
import 'AvailableTrxDetails/AvailableTrxDetails.dart';
import 'AvailableTrxDetails/AvailableTrxDetails_Binding.dart';
import 'ChoosePayment/ChoosePayment.dart';
import 'ChoosePayment/ChoosePayment_Binding.dart';
import 'CloseRequest/CloseRequestPage.dart';
import 'CloseRequest/CloseRequest_Binding.dart';
import 'CloseRequest/CloseRequest_MiddleWare.dart';
import 'CustomAppbar/CustomAppbar_Controller.dart';
import 'Fueling/Fueling.dart';
import 'Fueling/Fueling_Binding.dart';
import 'Home/Home.dart';
import 'Home/Home_Binding.dart';
import 'Maiarshift/Maiar_Binding.dart';
import 'Maiarshift/Maiar_Page.dart';
import 'Nozzles/Nozzles_Binding.dart';
import 'Nozzles/Nozzles_Page.dart';
import 'PresetValue/PresetValue_Binding.dart';
import 'PresetValue/PresetValue_Page.dart';
import 'Pumps/Pumps_Binding.dart';
import 'Pumps/Pumps_Page.dart';
import 'Receipt/Receipt.dart';
import 'Receipt/Receipt_Binding.dart';
import 'Report/Report.dart';
import 'ReportShifts/ReportShift.dart';
import 'ResetPayment/ResetPayment.dart';
import 'ResetPayment/ResetPayment_Binding.dart';
import 'Setting/Setting.dart';
import 'Setting/Setting_Binding.dart';
import 'Shared/password_Controller.dart';
import 'Shifts/Shift_Binding.dart';
import 'Shifts/Shift_Page.dart';
import 'SuperVisourCloseShift/VerifyCloseShift_Binding.dart';
import 'SuperVisourCloseShift/VerifyCloseShift_Page.dart';
import 'SuperVisourSetlemment/VerifySetlemment_Binding.dart';
import 'SuperVisourSetlemment/VerifySetlemment_Page.dart';
import 'Syncing/SyncingPage.dart';
import 'Syncing/Syncing_Binding.dart';
import 'Syncing/Syncing_MiddleWare.dart';
import 'Theme/Theme.dart';
import 'Theme/Theme_Controller.dart';
import 'Tips/Tips.dart';
import 'Tips/Tips_Binding.dart';
import 'AvailableTransactions/AvailableTransactions.dart';
import 'AvailableTransactions/AvailableTransactions_Binding.dart';
import 'TransactionStatus/TransactionStatus.dart';
import 'TransactionStatus/TransactionStatus_Binding.dart';
import 'TransactionStatusDetails/TransactionStatusDetails.dart';
import 'TransactionStatusDetails/TransactionStatusDetails_Binding.dart';
import 'Transactions/Transactions.dart';
import 'Transactions/Transactions_Binding.dart';
import 'Local/Local.dart';
import 'VerifyAttendent/Verify_Binding.dart';
import 'VerifyAttendent/Verify_Page.dart';
import 'VerifyAvailableTrx/VerifyAvailableTrx_Binding.dart';
import 'VerifyAvailableTrx/VerifyAvailableTrx_Page.dart';
import 'VerifyShiftReprot/VerifyShiftReprot_Binding.dart';
import 'VerifyShiftReprot/VerifyShiftReprot_Page.dart';
import 'VerifyTransactionAll/VerifyTransactionAll_Binding.dart';
import 'VerifyTransactionAll/VerifyTransactionAll_Page.dart';
import 'VerifyTransactionReprot/VerifyTransactionReprot_Binding.dart';
import 'VerifyTransactionReprot/VerifyTransactionReprot_Page.dart';
import 'my_http_overrides.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background/flutter_background.dart';

SharedPreferences? prefs;
final customappbar = Get.put(CustomAppbarController());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  Get.put(PasswordController());
  HttpOverrides.global = MyHttpOverrides(); // Bypass SSL
  Get.put(CustomAppbarController());
  // Get.put(LocalController());
  // initBackgroundService();
  runApp(const MyApp());
}

// Future<void> initBackgroundService() async {
//   bool success = await FlutterBackground.initialize();
//   if (success) {
//     FlutterBackground.enableBackgroundExecution();
//     runBackgroundTask();
//   }
// }

// void runBackgroundTask() {
//   Future.delayed(Duration(seconds: 10), () {
//     // Add the task you want to run in the background
//     customappbar.startConnection();
//     print("Background task is running!");
//   });
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    LocalController localeController = Get.put(LocalController());
    final ThemeController themeController = Get.put(ThemeController());
    print("localeController.initLang${localeController.initLang}");
    var isArabic = localeController.getCurrentLang()?.languageCode == "ar";
    return GetMaterialApp(
      defaultTransition: isArabic
          ? Transition.leftToRightWithFade
          : Transition.rightToLeftWithFade,
      translations: Messages(),
      locale: localeController.initLang, // default locale
      // fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      title: 'PMS',
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      themeMode:
          themeController.isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => SyncingPage(),
          binding: SyncingBinding(),
          middlewares: [
            SyncingMiddleware(),
          ],
        ),
        // GetPage(
        //     name: '/Setting',
        //     page: () => SettingPage(),
        //     binding: SettingBinding()),
        GetPage(
            name: '/Shift', page: () => ShiftPage(), binding: ShiftBinding()),
        GetPage(
          name: '/CloseShift',
          page: () => CloseRequestPage(),
          binding: CloseRequestBinding(),
          // middlewares: [
          //   CloseRequestMiddleware(),
          // ],
        ),
        GetPage(
            name: '/Mair', page: () => MaiarPage(), binding: MaiarBinding()),
        GetPage(
            name: '/VerifyCloseShift',
            page: () => VerifycloseshiftPage(),
            binding: VerifycloseshiftBinding()),
        GetPage(
            name: '/VerifySetlemment',
            page: () => VerifySetlemmentPage(),
            binding: VerifySetlemmentBinding()),
        GetPage(name: '/Home', page: () => HomePage(), binding: HomeBinding()),
        GetPage(
            name: '/verify',
            page: () => VerifyPage(),
            binding: VerifyBinding()),
        GetPage(
            name: "/Pumps", page: () => PumpsPage(), binding: PumpsBinding()),
        GetPage(
            name: "/Nozzles",
            page: () => NozzelsPage(),
            binding: NozzlesBinding()),
        GetPage(
            name: "/PresetValue",
            page: () => PresetvaluePage(),
            binding: PresetvalueBinding()),
        // GetPage(
        //     name: "/Authorize",
        //     page: () => Authorized(),
        //     binding: AuthorizedBinding()),
        GetPage(
            name: "/Fueling",
            page: () => FuelingPage(),
            binding: FuelingBinding()),
        GetPage(
            name: "/authorizedpage",
            page: () => Authorizedpage(),
            binding: AuthorizedBinding()),
        GetPage(
            name: "/ChoosePayment",
            page: () => ChoosePayment(),
            binding: ChoosePaymentBinding()),

        GetPage(
            name: "/Availabletrxdetails",
            page: () => Availabletrxdetails(),
            binding: AvailabletrxdetailsBinding()),

        GetPage(
            name: "/TransactionStatusDetails",
            page: () => TransactionStatusDetails(),
            binding: TransactionStatusDetailsBinding()),
        GetPage(
            name: "/TransactionStatus",
            page: () => TransactionStatus(),
            binding: TransactionStatusBinding()),
        GetPage(
          name: '/Receipt',
          page: () => Receipt(),
          binding: ReceiptBinding(),
        ),
        GetPage(
          name: '/Tips',
          page: () => Tips(),
          binding: TipsBinding(),
        ),
        GetPage(
          name: '/Transactions',
          page: () => Transactions(),
          binding: TransactionsBinding(),
        ),
        GetPage(
            name: "/Verifyavailabletrx",
            page: () => VerifyavailabletrxPage(),
            binding: VerifyavailabletrxBinding()),
        GetPage(
            name: "/VerifyTransactionAllPage",
            page: () => VerifyTransactionAllPage(),
            binding: VerifyTransactionAllBinding()),
        GetPage(
            name: "/VerifyTransactionReprot",
            page: () => VerifyTransactionReprotPage(),
            binding: VerifyTransactionReprotBinding()),
        GetPage(
            name: "/VerifyShiftReprotPage",
            page: () => VerifyShiftReprotPage(),
            binding: VerifyShiftReprotBinding()),
        GetPage(
          name: '/Availabletransactions',
          page: () => Availabletransactions(),
          binding: AvailabletransactionsBinding(),
        ),
        GetPage(
            name: "/ResetPayment",
            page: () => ResetPayment(),
            binding: ResetPaymentBinding()),
        GetPage(
            name: "/Report", page: () => Report(), binding: ReportBinding()),
        GetPage(
            name: "/ReportShift",
            page: () => Reportshift(),
            binding: ReportshiftBinding()),
        // GetPage(
        //   name: '/Resetpage',
        //   page: () => Resetpage(
        //     pumpNo: Get.arguments['pumpNo'],
        //     nozzleNo: Get.arguments['nozzleNo'],
        //     transactionSeqNo: Get.arguments['transactionSeqNo'],
        //     amountVal: Get.arguments['amountVal'],
        //     volume: Get.arguments['volume'],
        //     unitPrice: Get.arguments['unitPrice'],
        //     volumeProduct1: Get.arguments['volumeProduct1'],
        //     volumeProduct2: Get.arguments['volumeProduct2'],
        //     productNo1: Get.arguments['productNo1'],
        //     blendRatio: Get.arguments['blendRatio'],
        //     selectedPaymentOption: Get.arguments['selectedPaymentOption'],
        //     productName: Get.arguments['productName'],
        //   ),
        //   // binding: ResetBinding(),
        // ),
        // GetPage(name: "/Tips", page: () => TipsPage(), binding: TipsBinding()),
        // GetPage(
        //     name: "/TipsAfterVoid",
        //     page: () => TipsPageAfterVoid(),
        //     binding: TipsBindingAfterVoid()),
        // GetPage(
        //     name: "/Alltrans",
        //     page: () => AllTransactionPage(),
        //     binding: AllTransactyionBinding()),
      ],
    );
  }
}
