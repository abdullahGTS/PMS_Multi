import '../main.dart';
import 'Local.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalController extends GetxController {
  Locale initLang = prefs!.getString('lang') == null
      ? Get.deviceLocale!
      : Locale(prefs!.getString('lang')!);
  changeLang(String codelang) {
    Locale locale = Locale(codelang);
    prefs!.setString('lang', codelang);
    Get.updateLocale(locale);
  }

  Locale? getCurrentLang() {
    return Get.locale ?? Get.deviceLocale;
  }
}
