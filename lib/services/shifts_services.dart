import 'package:get/get.dart';
import 'package:suprsync/core/utils/conn.dart';
import 'package:suprsync/core/utils/error_handler.dart';
import 'package:suprsync/core/utils/network_helper.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/models/shifts_model.dart';
import 'package:suprsync/models/swap_shift_model.dart';

class ShiftsServices {
  final NetworkHelper _networkHelper = NetworkHelper();
  ErrorHandler errorHandler = ErrorHandler();

  Future fetchAllShifts(userId, from, to, token, {isfiltered}) async {
    List<ShiftsModel> shiftsModel = [];
    Map<String, String> headers;

    String url = '$prodUrl/shifts/schedule?from=$from&to=$to';

    headers = {
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

  Future fetchUserShifts(userId, from, to, token, {isfiltered}) async {
    List<ShiftsModel> userShiftModel = [];
    Map<String, String> headers;

    String url = '$prodUrl/shifts/schedule?from=$from&to=$to&userId=$userId';
    headers = {
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
        userShiftModel.add(res);
      }
      return userShiftModel;
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
      swapShiftModel = SwapShiftModel.fromJson(value);

      Get.back();
      return swapShiftModel;
    }).catchError((onError) {
      errorHandler.handleError(onError);
      showSnackBar(onError.toString());
    });
  }
}
