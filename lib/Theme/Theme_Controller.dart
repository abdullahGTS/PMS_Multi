import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Theme.dart';

class ThemeController extends GetxController {
  var isDarkMode = false.obs;

  ThemeData get theme =>
      isDarkMode.value ? Themes.darkTheme : Themes.lightTheme;

  @override
  void onInit() {
    super.onInit();
    _loadTheme();
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('mode') ?? false;
    Get.changeTheme(theme);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() async {
    print("okkkkkkkkkk");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode.value = !isDarkMode.value;
    prefs.setBool('mode', isDarkMode.value);
    Get.changeTheme(theme);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
