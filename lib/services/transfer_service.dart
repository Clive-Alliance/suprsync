import 'package:suprsync/core/utils/conn.dart';
import 'package:suprsync/core/utils/error_handler.dart';
import 'package:suprsync/core/utils/network_helper.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/models/transfer_request_mdel.dart';

class TransferService {
  final NetworkHelper _networkHelper = NetworkHelper();
  final ErrorHandler errorHandler = ErrorHandler();

  Future<List<TransferRequestModel>> getRequestTransferItems(
      String token) async {
    try {
      String url = '$prodUrl/inventory/get-transfer-request-items';
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      };
      final dynamic response = await _networkHelper.get(url, headers: headers);
      List<TransferRequestModel> transferRequestModel = [];
      for (Map<String, dynamic> item in response) {
        transferRequestModel.add(TransferRequestModel.fromJson(item));
      }
      return transferRequestModel;
    } catch (error) {
      errorHandler.handleError(error);
      return <TransferRequestModel>[];
    }
  }

  Future<List<TransferRequestModel>> getLocationTransferItems(
      String from, String to, String token) async {
    try {
      String url = to.isEmpty
          ? '$prodUrl/inventory/get-transfer-request-items?withdrawLocationId=$from'
          : '$prodUrl/inventory/get-transfer-request-items?withdrawLocationId=$from&transferLocationId=$to';

      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      };
      final dynamic response = await _networkHelper.get(url, headers: headers);
      List<TransferRequestModel> transferRequestModel = [];
      for (Map<String, dynamic> item in response) {
        transferRequestModel.add(TransferRequestModel.fromJson(item));
      }
      return transferRequestModel;
    } catch (error) {
      errorHandler.handleError(error);
      return <TransferRequestModel>[];
    }
  }

  Future<dynamic> stockUpItems(
      TransferRequestModel stockedItem, String token) async {
    try {
      String url = '$prodUrl/inventory/stock-up-transfer-item';
      List<Item>? items = stockedItem.items;
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      };
      final body = {
        "transferItemsData": items!
            .map((item) => {
                  "transferItemId": item.id.toString(),
                  "quantityReceived": item.quantityWithdrawn,
                  "locationId": stockedItem.toLocation!.locationId.toString()
                })
            .toList()
      };
      final response =
          await _networkHelper.post(url, headers: headers, body: body);
      return response;
    } catch (error) {
      errorHandler.handleError(error);
      showSnackBar(error.toString());
      return null;
    }
  }

  Future<bool> stockUpItemsWithSuccess(
      TransferRequestModel stockedItem, String token) async {
    try {
      String url = '$prodUrl/inventory/stock-up-transfer-item';
      List<Item>? items = stockedItem.items;

      if (items == null || items.isEmpty) {
        showSnackBar("No items to stock up");
        return false;
      }
      Map<String, String> headers = {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token',
      };
      final body = {
        "transferItemsData": items
            .map((item) => {
                  "transferItemId": item.id.toString(),
                  "quantityReceived": item.quantityWithdrawn,
                  "locationId": stockedItem.toLocation!.locationId.toString()
                })
            .toList()
      };
      await _networkHelper.post(url, headers: headers, body: body);
      return true; // Success
    } catch (error) {
      errorHandler.handleError(error);
      showSnackBar(error.toString());
      return false; // Failure
    }
  }
}
