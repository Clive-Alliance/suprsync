import 'package:suprsync/core/utils/conn.dart';
import 'package:suprsync/core/utils/error_handler.dart';
import 'package:suprsync/core/utils/network_helper.dart';
import 'package:suprsync/models/location_model.dart';

class LocationServices {
  final NetworkHelper _networkHelper = NetworkHelper();
  ErrorHandler errorHandler = ErrorHandler();

  Future fetchAvailableLocations(
    token,
  ) async {
    List<LocationModel> locationModel = [];
    Map<String, String> headers;

    String url = '$prodUrl/company/branches';

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
        final res = LocationModel.fromJson(itm);
        locationModel.add(res);
      }
      return locationModel;
    }).catchError((onError) {
      errorHandler.handleError(onError);
    });
  }
}
