import 'package:suprsync/core/utils/conn.dart';
import 'package:suprsync/core/utils/error_handler.dart';
import 'package:suprsync/core/utils/network_helper.dart';
import 'package:suprsync/models/measurement_unit_model.dart';

class WithdrawalService {
  final NetworkHelper _networkHelper = NetworkHelper();
  ErrorHandler errorHandler = ErrorHandler();

  // Future withdrawItems(
  //   membershipId,
  //   inventoryItemId,
  //   quantity,
  //   measurementUnit,
  //   location,
  //   token,
  // ) async {
  //   Map<String, String> headers;
  //   Map<String, dynamic> body;

  //   String url = '$prodUrl/inventory/withdraw-items';
  //   headers = {
  //     "Accept": "application/json",
  //     "Content-Type": "application/json",
  //     'Authorization': 'Bearer $token',
  //   };

  //   body = {
  //     "teamMembershipId": membershipId,
  //     "withdrawalData": [
  //       {
  //         "inventoryItemsId": inventoryItemId,
  //         "quantityToWithdraw": quantity,
  //         "measurementUnitId": measurementUnit,
  //         "withdrawLocationId": location,
  //       }
  //     ]
  //   };
  //   print('your body is $body');
  //   return _networkHelper
  //       .post(url, headers: headers, body: body)
  //       .then((dynamic value) async {
  //     return value;
  //   }).catchError((onError) {
  //     errorHandler.handleError(onError);
  //   });
  // }

  Future withdrawItems(
    String membershipId,
    List<Map<String, dynamic>> withdrawalData, // 👈 accept list of items
    String token,
  ) async {
    final String url = '$prodUrl/inventory/withdraw-items';

    final headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };

    final body = {
      "teamMembershipId": membershipId,
      "withdrawalData": withdrawalData, // 👈 directly use list
    };

    print('your body is $body');

    return _networkHelper
        .post(url, headers: headers, body: body)
        .then((dynamic value) async => value)
        .catchError((onError) {
      errorHandler.handleError(onError);
    });
  }

  Future fetchMeasumenentUnit(
    token,
  ) async {
    List<MeasurementUnitModel> measurementUnit = [];
    Map<String, String> headers;

    String url = '$prodUrl/inventory/measurement-unit';

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
        final res = MeasurementUnitModel.fromJson(itm);
        measurementUnit.add(res);
      }
      return measurementUnit;
    }).catchError((onError) {
      errorHandler.handleError(onError);
    });
  }
}
