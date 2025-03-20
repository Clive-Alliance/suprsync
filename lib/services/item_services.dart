import 'package:suprsync/core/utils/conn.dart';
import 'package:suprsync/core/utils/error_handler.dart';
import 'package:suprsync/core/utils/network_helper.dart';
import 'package:suprsync/models/all_items_model.dart';

class ItemsServices {
  final NetworkHelper _networkHelper = NetworkHelper();
  ErrorHandler errorHandler = ErrorHandler();

  Future fetchAllItems(
    token,
  ) async {
    List<AllItemsModel> allItemsModel = [];
    Map<String, String> headers;

    String url = '$prodUrl/inventory/get-all-items';

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
        final res = AllItemsModel.fromJson(itm);
        allItemsModel.add(res);
      }
      return allItemsModel;
    }).catchError((onError) {
      errorHandler.handleError(onError);
    });
  }
}
