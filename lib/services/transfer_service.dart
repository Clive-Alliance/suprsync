import 'package:suprsync/core/utils/conn.dart';
import 'package:suprsync/core/utils/error_handler.dart';
import 'package:suprsync/core/utils/network_helper.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/models/transfer_request_mdel.dart';

class TransferService {
  final NetworkHelper _networkHelper = NetworkHelper();
  ErrorHandler errorHandler = ErrorHandler();

  Future getRequestTransferItems(from, to, token) async {
    List<TransferRequestModel> transferRequestModel = [];
    Map<String, String> headers;

    ;
    String url = '$prodUrl/inventory/get-transfer-request-items';

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
        final res = TransferRequestModel.fromJson(itm);
        transferRequestModel.add(res);
      }
      return transferRequestModel;
    }).catchError((onError) {
      errorHandler.handleError(onError);
    });
  }

  Future getLocationTransferItems(from, to, token) async {
    List<TransferRequestModel> transferRequestModel = [];
    Map<String, String> headers;
    String url = to == ''
        ? '$prodUrl/inventory/get-transfer-request-items?withdrawLocationId=$from'
        : '$prodUrl/inventory/get-transfer-request-items?withdrawLocationId=$from&transferLocationId=$to';
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
        final res = TransferRequestModel.fromJson(itm);
        transferRequestModel.add(res);
      }
      return transferRequestModel;
    }).catchError((onError) {
      errorHandler.handleError(onError);
    });
  }

  Future stockUpItems(TransferRequestModel stockedItem, token) async {
    Map<String, String> headers;

    String url = '$prodUrl/inventory/stock-up-transfer-item';
    List<Item>? items = stockedItem.items;
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };
    print('your items are $items');
    final body = {
      "transferItemsData": items!
          .map((item) => {
                "transferItemId": item.id.toString(),
                "quantityReceived": item.quantityWithdrawn,
                "locationId": stockedItem.toLocation!.locationId.toString()
              })
          .toList()
    };

    return await _networkHelper
        .post(url, headers: headers, body: body)
        .then((value) {
      print(value);
      return value;
    }).catchError((onError) {
      errorHandler.handleError(onError);
      print('it is not $onError');
      showSnackBar(onError.toString());
    });
  }
}
