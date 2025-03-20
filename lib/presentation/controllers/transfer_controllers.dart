import 'package:get/get.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/models/transfer_request_mdel.dart';
import 'package:suprsync/services/transfer_service.dart';

import '../homepage/auth/controller/auth_controller.dart';

class TransferController extends GetxController {
  TransferService _transferService = TransferService();

  RxList<TransferRequestModel> transferRequestModel =
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

      return transferRequestModel;
    }).catchError((error) {
      print('Error fwithdrawing items: $error');
      Get.back();

      showSnackBar(error);
    });
  }
}
