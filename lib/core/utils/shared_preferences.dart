import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

savePrefs(title, value) async {
  final prefs = await SharedPreferences.getInstance();
  var result = prefs.setString(title, value);
  print(value);
  return result;
}

getPrefs(String key) async {
  final prefs = await SharedPreferences.getInstance();
  var result = prefs.getString(key);
  print('your prefs result is $result');
  return result;
}

saveDetails(String key, value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, json.encode(value));
}

readString(String key) async {
  final prefs = await SharedPreferences.getInstance();
  var value = prefs.getString(key);
  return value;
}

read(String key) async {
  final prefs = await SharedPreferences.getInstance();
  var json = prefs.getString(key);
  print(json);
  if (json != null) {
    return jsonDecode(json!);
  }
  return null;
}

clearPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}
