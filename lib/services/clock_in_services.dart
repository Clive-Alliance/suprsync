import 'package:get/get.dart';
import 'package:suprsync/core/utils/conn.dart';
import 'package:suprsync/core/utils/error_handler.dart';
import 'package:suprsync/core/utils/network_helper.dart';
import 'package:suprsync/core/utils/show_message.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/models/checkin_schedule_model.dart';
import 'package:suprsync/models/clockin_model.dart';
import 'package:suprsync/models/error_model.dart';
import 'package:suprsync/presentation/homepage/clockin_page/clockin_controller.dart';

class ClockinServices {
  final NetworkHelper _networkHelper = NetworkHelper();
  ErrorHandler errorHandler = ErrorHandler();
  // final ClockInAndOutController _clockInAndOutController = Get.find();

  // String clockInUrl = "$prodUrl/shifts/id/clock-in-or-out";

  Future clockInAndOut(
    type,
    id,
    token,
  ) async {
    ClockInModel? clockInModel;
    Map<String, String> headers;
    Map<String, String> body;
    // String shiftId = type == 'clockOut'
    //     ? _clockInAndOutController.firstClockedInShiftId.value
    //     : id;
    String url = '$prodUrl/shifts/$id/clock-in-or-out';
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };
    body = {"type": type};
    print(" $id, $token, $body");
    return await _networkHelper
        .post(url, headers: headers, body: body)
        .then((value) {
      print('it is not ');
      clockInModel = ClockInModel.fromJson(value);
      print('it is not ');
      Get.back();
      return clockInModel;
    }).catchError((onError) {
      errorHandler.handleError(onError);
      print('it is not $onError');
      showSnackBar(onError.toString());

      // Get.back();
    });
  }

  Future clockInSchedule(from, to, userId, token) async {
    List<CheckInScheduleModel> clockinSchedule = [];

    CheckInScheduleModel? scheduleModel;
    Map<String, String> headers;
    Map<String, String> body;
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
