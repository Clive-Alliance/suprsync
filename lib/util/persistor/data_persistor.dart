import 'package:shared_preferences/shared_preferences.dart';
import 'data_persistor_keys.dart';

class DataPersistor {

  static void saveAccessToken({required String? token}) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(token == null){
      prefs.remove(DataPersistorKeys.prefsAccessToken);
      return;
    }
    prefs.setString(DataPersistorKeys.prefsAccessToken, token);
  }

  static Future<String> getAccessToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(DataPersistorKeys.prefsAccessToken);
    if(value==null){
      return "";
    }
    return value;
  }

  static void saveRefreshToken({required String? token}) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(token == null){
      prefs.remove(DataPersistorKeys.prefsRefreshToken);
      return;
    }
    prefs.setString(DataPersistorKeys.prefsRefreshToken, token);
  }

  static Future<String> getRefreshToken() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(DataPersistorKeys.prefsRefreshToken);
    if(value==null){
      return "";
    }
    return value;
  }

  static void saveLoginTime({required DateTime? time}) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(time == null){
      prefs.remove(DataPersistorKeys.prefsLoginTime);
      return;
    }
    prefs.setString(DataPersistorKeys.prefsLoginTime, time.toIso8601String());
  }

  static Future<DateTime?> getLoginTime() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(DataPersistorKeys.prefsLoginTime);
    if(value==null){
      return null;
    }
    return DateTime.parse(value);
  }

  static Future<void> logoutUser() async{
    // var notifications = await NotificationManager.sharedInstance.getAllNotifications();
    SharedPreferences prefs = await SharedPreferences.getInstance();

  }

  static Future<void> clearAllPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

}