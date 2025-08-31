import 'package:get/get.dart';
import 'package:suprsync/core/utils/conn.dart';
import 'package:suprsync/core/utils/error_handler.dart';
import 'package:suprsync/core/utils/network_helper.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/models/checkin_schedule_model.dart';
import 'package:suprsync/models/clockin_model.dart';

class ClockinServices {
  final NetworkHelper _networkHelper = NetworkHelper();
  ErrorHandler errorHandler = ErrorHandler();

  Future clockInAndOut(type, id, token, lng, lat, wifiName) async {
    ClockInModel? clockInModel;
    Map<String, String> headers;
    Map<String, String> body;

    String url = '$prodUrl/shifts/$id/clock-in-or-out';

    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };
    body = {"type": type, "long": lng, "lat": lat, "wifiSSID": wifiName};
    print('$body and $id');
    return await _networkHelper
        .post(url, headers: headers, body: body)
        .then((value) {
      clockInModel = ClockInModel.fromJson(value);
      Get.back();
      return clockInModel;
    }).catchError((onError) {
      errorHandler.handleError(onError);
      showSnackBar(onError.toString());

      // Get.back();
    });
  }

  Future clockInSchedule(from, to, userId, token) async {
    List<CheckInScheduleModel> clockinSchedule = [];

    Map<String, String> headers;
    String url =
        '$prodUrl/shifts/schedule/clock-ins?from=$from&to=$to&userId=$userId';
    // String url = '$prodUrl/shifts/:$id/clock-in-or-out';
    // 10af7739-9d0a-456a-9a33-2a411f79f151
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };
    return _networkHelper
        .get(
      url,
      headers: headers,
    )
        .then((dynamic value) async {
      for (Map<String, dynamic> itm in value) {
        final res = CheckInScheduleModel.fromJson(itm);
        clockinSchedule.add(res);
      }
      return clockinSchedule;
    }).catchError((onError) {
      errorHandler.handleError(onError);
    });
  }
}
