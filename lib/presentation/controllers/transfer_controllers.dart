import 'package:get/get.dart';
import 'package:suprsync/core/utils/loader.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/models/location_model.dart';
import 'package:suprsync/models/transfer_request_mdel.dart';
import 'package:suprsync/presentation/dashboard_screen/withdrawal/withdrawal_controller/withdrawal_controller.dart';
import 'package:suprsync/services/transfer_service.dart';
import '../dashboard_screen/auth/controller/auth_controller.dart';

class TransferController extends GetxController {
  TransferService _transferService = TransferService();

  RxList<TransferRequestModel> transferRequestModel =
      <TransferRequestModel>[].obs;
  RxList<TransferRequestModel> specifiedTransferList =
      <TransferRequestModel>[].obs;

  final AuthController _authController = Get.find();
  final WithdrawalController _withdrawalController = Get.find();
  Rx<String> from = ''.obs;
  Rx<String> to = ''.obs;
  Rxn<LocationModel> fromLocation = Rxn<LocationModel>();
  Rxn<LocationModel> toLocation = Rxn<LocationModel>();
  RxList<LocationModel> fromLocations = <LocationModel>[].obs;
  RxList<LocationModel> toLocations = <LocationModel>[].obs;

  List<LocationModel> get allLocations => [
        LocationModel(id: "ALL", name: "ALL LOCATIONS"),
        ..._withdrawalController.locationsModel,
      ];

  var isLoading = false.obs;
  Future requestTransferItemsList() {
    isLoading(true);

    return _transferService
        .getRequestTransferItems(
      _authController.token.value,
    )
        .then((value) {
      transferRequestModel(value);
      isLoading(false);
      return transferRequestModel;
    }).catchError((error) {
      showSnackBar(error);
    });
  }

  void updateFromLocations(List<LocationModel> selected) {
    if (selected.contains("ALL LOCATIONS")) {
      fromLocations.assignAll(_withdrawalController.locationsModel);
    } else {
      fromLocations.assignAll(selected);
    }
    filterTransferItems();
  }

  void updateToLocations(List<LocationModel> selected) {
    if (selected.contains("ALL LOCATIONS")) {
      toLocations.assignAll(_withdrawalController.locationsModel);
    } else {
      toLocations.assignAll(selected);
    }
    filterTransferItems();
  }

  void filterTransferItems() {
    if (fromLocations.any((loc) => loc.id == "ALL") &&
        toLocations.any((loc) => loc.id == "ALL")) {
      specifiedTransferList.assignAll(transferRequestModel);
      return;
    }

    final filtered = transferRequestModel.where((item) {
      final matchesFrom = fromLocations.any((loc) => loc.id == "ALL") ||
          fromLocations.any((loc) => loc.id == item.batchIdentifier);
      final matchesTo = toLocations.any((loc) => loc.id == "ALL") ||
          toLocations.any((loc) => loc.id == item.batchIdentifier);
      return matchesFrom && matchesTo;
    }).toList();

    specifiedTransferList.assignAll(filtered);
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
      showSnackBar(error);
    });
  }

  // @override
  // void onClose() {
  //   // Clear values when controller is disposed
  //   fromLocation.value = null;
  //   toLocation.value = null;
  //   super.onClose();
  // }
}
