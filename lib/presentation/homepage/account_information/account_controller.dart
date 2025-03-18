import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suprsync/models/upload_picture.dart';
import 'package:suprsync/presentation/homepage/auth/controller/auth_controller.dart';
import 'package:suprsync/services/profile_services.dart';

class AccountController extends GetxController {
  Rx<File>? _imageFile;
  Rx<String> base64String = ''.obs;
  Rx<String> imageUrl = ''.obs;

  AuthController _authController = Get.find();
  AccountServices _accountServices = AccountServices();
  Future<UploadPictureModel> uploadImage() {
    return _accountServices
        .uploadPicture(_authController.token.value, _imageFile)
        .then((value) {
      UploadPictureModel url = value;
      imageUrl(url.url);
      Get.back();
      return url;
    });
  }

  Future<void> openCamera() async {
    print("opening camera");
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _imageFile!(File(pickedFile.path));
    }

    // Get.back();
  }

  Future<void> openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _imageFile!(File(pickedFile.path));

      Uint8List _bytes = await _imageFile!.value.readAsBytes();

      // base64 encode the bytes
      String _base64String = base64.encode(_bytes);

      base64String(_base64String);
    }
    // showLoading
    await uploadImage();
    // Get.back();
  }

  void _removeImage() {
    _imageFile = null;

    Get.back();
  }
}
