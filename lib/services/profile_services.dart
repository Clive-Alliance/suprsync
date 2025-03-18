import 'package:suprsync/core/utils/conn.dart';
import 'package:suprsync/core/utils/error_handler.dart';
import 'package:suprsync/core/utils/network_helper.dart';
import 'package:suprsync/models/upload_picture.dart';

class AccountServices {
  final NetworkHelper _networkHelper = NetworkHelper();
  ErrorHandler errorHandler = ErrorHandler();
  String setProfilePicture = "$prodUrl/users/profile-picture";

  Future uploadPicture(token, imageFile) async {
    UploadPictureModel? url;
    Map<String, String> headers;
    Map<String, String> body;
    String uploadUrl = setProfilePicture;
    // 10af7739-9d0a-456a-9a33-2a411f79f151
    headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };
    body = {"file": imageFile};

    return _networkHelper
        .put(uploadUrl, headers: headers, body: body)
        .then((dynamic value) async {
      url = UploadPictureModel.fromJson(value);
      return url;
    }).catchError((onError) {
      errorHandler.handleError(onError);
    });
  }
}
