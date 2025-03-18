import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:suprsync/core/utils/error_handler.dart';
import 'package:suprsync/core/utils/network_helper.dart';
import 'package:suprsync/models/forgot_password.dart';
import 'package:suprsync/models/signin_model.dart';

import '../core/utils/conn.dart';
import '../core/utils/shared_preferences.dart';

class Authentication {
  NetworkHelper networkHelper = NetworkHelper();
  ErrorHandler errorHandler = ErrorHandler();

  String signInUrl = "$prodUrl/users/signin";
  String forgotPasswordUrl = "$prodUrl/users/forgot-password";
  String deviceType = '';

  Future signIn(email, password) async {
    SignInUserModel? signInModel;
    Map<String, String> headers;
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    String? deviceToken = await getDeviceUUID();
    return networkHelper.post(signInUrl, headers: headers, body: {
      "email": email,
      "password": password,
      "device": {"type": "ios", "token": deviceToken.toString()}
    }).then((dynamic value) async {
      Get.back();
      final response = value;
      print('your resposnse is $response');
      final token = value['accessToken'];
      if (token == null) {
      } else {
        savePrefs('password', password);
        signInModel = SignInUserModel.fromJson(response);
        return signInModel;
      }
    }).catchError((onError) {
      Get.back();
      errorHandler.handleError(onError);
    });
  }

  Future forgotPassword(email) async {
    Map<String, String> headers;
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    return networkHelper.post(forgotPasswordUrl,
        headers: headers, body: {"email": email}).then((value) {
      print('your value is $value');
      ForgotPasswordModel forgotPassword = ForgotPasswordModel.fromJson(value);
      return forgotPassword;
    }).catchError((onError) {
      errorHandler.handleError(onError);
    });
  }

  Future<String?> getDeviceUUID() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    String? deviceUUID;

    try {
      if (Platform.isAndroid) {
        deviceType = 'android';
        var build = await deviceInfoPlugin.androidInfo;
        deviceUUID = build.id; // This is not a true UUID, but a device ID
      } else if (Platform.isIOS) {
        deviceType = 'ios';

        var data = await deviceInfoPlugin.iosInfo;
        deviceUUID = data.identifierForVendor; // Unique identifier for iOS
      }
    } on PlatformException {
      // Handle exception if device info cannot be retrieved
      print('Failed to get device UUID');
    }

    return deviceUUID;
  }
}
