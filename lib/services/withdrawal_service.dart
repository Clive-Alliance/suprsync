import 'dart:convert';

import 'package:suprsync/core/utils/conn.dart';
import 'package:suprsync/core/utils/error_handler.dart';
import 'package:suprsync/core/utils/network_helper.dart';

class WithdrawalService {
  final NetworkHelper _networkHelper = NetworkHelper();
  ErrorHandler errorHandler = ErrorHandler();

  Future withdrawItems(
    membershipId,
    inventoryItemId,
    quantity,
    measurementUnit,
    location,
    token,
  ) async {
    Map<String, String> headers;
    Map<String, dynamic> body;

    String url = '$prodUrl/inventory/withdraw-items';
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };
    body = {
      "teamMembershipId": membershipId,
      "withdrawalData": [
        {
          "inventoryItemsId":
              inventoryItemId ?? '0c943148-fcf7-4a43-a061-8302ee506953',
          "quantityToWithdraw": quantity ?? 1,
          "measurementUnitId":
              measurementUnit ?? '46c7bef2-fa38-4c1c-b689-04c1e24e15dd',
          "withdrawLocationId":
              location ?? '471b2996-8fab-49f1-9ad6-a5f4fa512074',
        }
      ]
    };

    return _networkHelper
        .post(url, headers: headers, body: jsonEncode(body))
        .then((dynamic value) async {
      // for (Map<String, dynamic> itm in value) {
      //   final res = ShiftsModel.fromJson(itm);
      //   shiftsModel.add(res);
      // }
      // return shiftsModel;
    }).catchError((onError) {
      errorHandler.handleError(onError);
    });
  }
}
