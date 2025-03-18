import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeService {
  final _themeMode = ThemeMode.light.obs;

  ThemeMode get theme => _themeMode.value;

  void switchTheme() {
    _themeMode.value =
        _themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    Get.changeThemeMode(_themeMode.value);
  }
}
