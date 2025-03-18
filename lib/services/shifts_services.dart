import 'dart:convert';

import 'package:get/get.dart';
import 'package:suprsync/core/utils/conn.dart';
import 'package:suprsync/core/utils/error_handler.dart';
import 'package:suprsync/core/utils/network_helper.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/models/shifts_model.dart';
import 'package:suprsync/models/swap_shift_model.dart';
import 'package:suprsync/services/clock_in_services.dart';

import '../models/clockin_model.dart';

class ShiftsServices {
  final NetworkHelper _networkHelper = NetworkHelper();
  ErrorHandler errorHandler = ErrorHandler();
  ClockinServices _clockinServices = ClockinServices();

  Future fetchAvailableShifts(userId, from, to, token, {isfiltered}) async {
    List<ShiftsModel> shiftsModel = [];
    Map<String, String> headers;
    Map<String, String> body;
// shift-templates?jobRoleId=734a2345-5ad5-4694-8858-61f9aeafb1ff
    // String url = '$prodUrl/shift-templates?jobRoleId=$userId';
    String url = isfiltered == false
        ? '$prodUrl/shifts/schedule?from=$from&to=$to'
        : '$prodUrl/shifts/schedule?from=$from&to=$to&userId=$userId';
    headers = {
      // "Accept": "application/json",
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
        final res = ShiftsModel.fromJson(itm);
        shiftsModel.add(res);
      }
      return shiftsModel;
    }).catchError((onError) {
      errorHandler.handleError(onError);
    });
  }

  Future swapshifts(
    shiftId,
    value,
    token,
  ) async {
    SwapShiftModel swapShiftModel;
    Map<String, String> headers;
    Map<String, String> body;
    String url = '$prodUrl/shift-swap';
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };
    body = {"shiftId": shiftId, "value": value};

    return await _networkHelper
        .post(url, headers: headers, body: body)
        .then((value) {
      print('it is not ');
      swapShiftModel = SwapShiftModel.fromJson(value);
      print('it is not ');
      Get.back();
      return swapShiftModel;
    }).catchError((onError) {
      errorHandler.handleError(onError);
      print('it is not $onError');
      showSnackBar(onError.toString());

      // Get.back();
    });
  }
}
