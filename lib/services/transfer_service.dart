import 'package:suprsync/core/utils/conn.dart';
import 'package:suprsync/core/utils/error_handler.dart';
import 'package:suprsync/core/utils/network_helper.dart';
import 'package:suprsync/models/transfer_request_mdel.dart';

class TransferService {
  final NetworkHelper _networkHelper = NetworkHelper();
  ErrorHandler errorHandler = ErrorHandler();

  Future getRequestTransferItems(from, to, token) async {
    List<TransferRequestModel> transferRequestModel = [];
    Map<String, String> headers;

// shift-templates?jobRoleId=734a2345-5ad5-4694-8858-61f9aeafb1ff
    // String url = '$prodUrl/shift-templates?jobRoleId=$userId';
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
}
