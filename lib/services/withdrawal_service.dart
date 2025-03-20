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
      "teamMembershipId": "46bd1868-df1d-429e-8e72-2d6a72a88e5d",
      "withdrawalData": [
        {
          "inventoryItemsId": "0ad3022b-a334-4378-825b-c9c9e19c07d8",
          "quantityToWithdraw": 1,
          "measurementUnitId": "edaf4f44-e9a2-46de-8c2a-5bf929ad1f09",
          "withdrawLocationId": "649f886b-bd7b-4ccc-87c4-57b6cef79248"
          // "patientId": "" optional
        }
      ]
    };
    //  {
    //   "teamMembershipId": membershipId,
    //   "withdrawalData": [
    //     {
    //       "inventoryItemsId":
    //           inventoryItemId ?? '0c943148-fcf7-4a43-a061-8302ee506953',
    //       "quantityToWithdraw": quantity ?? 1,
    //       "measurementUnitId":
    //           measurementUnit ?? '46c7bef2-fa38-4c1c-b689-04c1e24e15dd',
    //       "withdrawLocationId":
    //           location ?? '471b2996-8fab-49f1-9ad6-a5f4fa512074',
    //     }
    //   ]
    // };
    print(body);
    return _networkHelper
        .post(url, headers: headers, body: body)
        .then((dynamic value) async {
      // for (Map<String, dynamic> itm in value) {
      //   final res = ShiftsModel.fromJson(itm);
      //   shiftsModel.add(res);
      // }
      return 'Successful';
    }).catchError((onError) {
      errorHandler.handleError(onError);
    });
  }
}
