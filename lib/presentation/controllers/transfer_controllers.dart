import 'package:get/get.dart';
import 'package:suprsync/core/utils/loader.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/models/transfer_request_mdel.dart';
import 'package:suprsync/services/transfer_service.dart';

import '../dashboard_screen/auth/controller/auth_controller.dart';

class TransferController extends GetxController {
  TransferService _transferService = TransferService();

  RxList<TransferRequestModel> transferRequestModel =
      <TransferRequestModel>[].obs;
  RxList<TransferRequestModel> specifiedTransferList =
      <TransferRequestModel>[].obs;

  AuthController _authController = Get.find();
  Rx<String> from = ''.obs;
  Rx<String> to = ''.obs;

  var isLoading = false.obs;
  Future requestTransferItemsList() {
    isLoading(true);

    return _transferService
        .getRequestTransferItems(
      from.value,
      to.value,
      _authController.token.value,
    )
        .then((value) {
      transferRequestModel(value);
      isLoading(false);
      print(transferRequestModel);
      return transferRequestModel;
    }).catchError((error) {
      print('Error fwithdrawing items: $error');
      // Get.back();

      showSnackBar(error);
    });
  }

  Future requestSpecifiedTransferItemsList() {
    isLoading(true);

    return _transferService
        .getLocationTransferItems(
      from.value,
      to.value,
      _authController.token.value,
    )
        .then((value) {
      specifiedTransferList(value);
      isLoading(false);

      return transferRequestModel;
    }).catchError((error) {
      print('Error fwithdrawing items: $error');
      Get.back();

      showSnackBar(error);
    });
  }

  Future stockItems(TransferRequestModel stockedItem) {
    showLoading();

    return _transferService
        .stockUpItems(
      stockedItem,
      _authController.token.value,
    )
        .then((value) {
      isLoading(false);
      Get.back();
      showSnackBar(value['message'].toString());
    }).catchError((error) {
      print('Error fwithdrawing items: $error');
      // Get.back();

      showSnackBar(error);
    });
  }

  /// Filter the list based on selected from and to locations
}
