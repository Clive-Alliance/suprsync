import 'package:get/get.dart';
import 'package:suprsync/core/utils/conn.dart';
import 'package:suprsync/core/utils/error_handler.dart';
import 'package:suprsync/core/utils/network_helper.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/models/request_timeoff.dart';
import 'package:suprsync/models/requested_timeoff_model.dart';
import 'package:suprsync/models/unavailable_days_model.dart';

class CalendarServices {
  final NetworkHelper _networkHelper = NetworkHelper();
  ErrorHandler errorHandler = ErrorHandler();

  Future blockDays(teamMembershipId, branchId, blockedDays, token) async {
    Map<String, String> headers;
    Map<String, dynamic> body;
    String url = '$prodUrl/blockdays';
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };
    body = {
      "teamMembershipId": teamMembershipId,
      "branchId": branchId,
      "blockedDays": blockedDays
    };

    return await _networkHelper
        .post(url, headers: headers, body: body)
        .then((value) {})
        .catchError((onError) {
      Get.back();
      showSnackBar(onError.toString());
    });
  }

  Future getBlockedDays(id, token) async {
    UnavailableDaysModel unavailbleDays;
    Map<String, String> headers;
    String url = '$prodUrl/getblockdays/$id';
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };

    return await _networkHelper
        .get(
      url,
      headers: headers,
    )
        .then((value) {
      unavailbleDays = UnavailableDaysModel.fromJson(value);
      return unavailbleDays;
    }).catchError((onError) {
      Get.back();
      showSnackBar(onError.toString());
    });
  }

  Future unblockDays(selectedDay, token) async {
    Map<String, String> headers;
    String url = '$prodUrl/unblock/$selectedDay';
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };
    return await _networkHelper
        .delete(
          url,
          headers: headers,
        )
        .then((value) {})
        .catchError((onError) {
      Get.back();
      showSnackBar(onError.toString());
    });
  }

  Future requestUserTimeOff(
      reason, startDate, endDate, timeoffType, token) async {
    RequestTimeoffModel requestTimeOff;
    Map<String, String> headers;
    Map<String, dynamic> body;
    String url = '$prodUrl/time-off/request';
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };

    body = {
      "reason": reason,
      "start": startDate,
      "end": endDate,
      "type": timeoffType.replaceAll(' ', '_').toString().toLowerCase()
    };
    return await _networkHelper
        .post(url, headers: headers, body: body)
        .then((value) {
      requestTimeOff = RequestTimeoffModel.fromJson(value);
      Get.back();
      return requestTimeOff;
    }).catchError((onError) {
      Get.back();
      showSnackBar(onError.toString());
    });
  }

  Future getRequestedTimeOffs(token) async {
    List<RequestedTimeoffModel> requestedTimeOff = [];

    Map<String, String> headers;
    String url = '$prodUrl/time-off';
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };

    return await _networkHelper
        .get(
      url,
      headers: headers,
    )
        .then((value) {
      for (Map<String, dynamic> itm in value) {
        final res = RequestedTimeoffModel.fromJson(itm);
        requestedTimeOff.add(res);
      }

      return requestedTimeOff;
    }).catchError((onError) {
      showSnackBar(onError.toString());
    });
  }
}
