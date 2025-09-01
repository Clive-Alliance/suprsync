import 'package:get/get.dart';
import 'package:suprsync/core/utils/loader.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/models/all_items_model.dart';
import 'package:suprsync/models/location_model.dart';
import 'package:suprsync/models/measurement_unit_model.dart';
import 'package:suprsync/models/withdrawal_selection.dart';
import 'package:suprsync/presentation/dashboard_screen/auth/controller/auth_controller.dart';
import 'package:suprsync/services/location_item_service.dart';
import 'package:suprsync/services/withdrawal_service.dart';

class WithdrawalController extends GetxController {
  final LocationServices _locationServices = LocationServices();
  final WithdrawalService _withdrawalService = WithdrawalService();
  final Rxn<LocationModel> selectedLocation = Rxn<LocationModel>();
  RxList<LocationModel> locationsModel = <LocationModel>[].obs;
  final Rxn<AllItemsModel> selectedValue = Rxn<AllItemsModel>();
  final RxList<WithdrawalSelection> selectedWithdrawals =
      <WithdrawalSelection>[].obs;

  RxList<MeasurementUnitModel> measurementUnitModel =
      <MeasurementUnitModel>[].obs;

  final AuthController _authController = Get.find();
  var isLoading = false.obs;
  Rx<int> quantity = 0.obs;
  Rx<String> inventoryItemId = ''.obs;
  Rx<String> measurementUnit = ''.obs;
  Rx<String> measurementUnitId = ''.obs;
  Rx<String> location = ''.obs;
  Rx<String> toLocation = ''.obs;
  Rx<String> value = ''.obs;

  RxList<AllItemsModel> selectedItems = <AllItemsModel>[].obs;
  final RxBool isListVisible = false.obs;

  // Method to toggle item selection
  void toggleItemSelection(AllItemsModel item) {
    print('this was triggered');
    if (selectedItems.contains(item)) {
      selectedItems.remove(item);
      // Also remove from withdrawals
      selectedWithdrawals
          .removeWhere((w) => w.inventoryItemId == item.id.toString());
      print('Removed item: ${item.name}');
    } else {
      selectedItems.add(item);
      // Add to withdrawals with default values
      selectedWithdrawals.add(
        WithdrawalSelection(
          inventoryItemId: item.id.toString(),
          quantity: 1, // Default quantity
          measurementUnitId: null,
          locationId: selectedLocation.value?.id?.toString(),
        ),
      );
      print('Added item: ${item.name}');
    }

    // Update visibility based on list length
    isListVisible.value = selectedItems.isNotEmpty;

    print('Total selected items: ${selectedItems.length}');
    print('Total withdrawals: ${selectedWithdrawals.length}');
    print('List visible: ${isListVisible.value}');
  }

  bool isItemSelected(AllItemsModel item) {
    return selectedItems.contains(item);
  }

  void clearAllSelections() {
    selectedItems.clear();
    selectedWithdrawals.clear();
    isListVisible.value = false;
    print('All selections cleared');
  }

  // Update quantity for specific item
  void updateQuantity(String itemId, int qty) {
    final index =
        selectedWithdrawals.indexWhere((w) => w.inventoryItemId == itemId);
    if (index != -1) {
      selectedWithdrawals[index].quantity = qty;
      selectedWithdrawals.refresh();
      print('Updated quantity for item $itemId to $qty');
    }
  }

  // Update measurement unit for specific item
  void updateMeasurementUnit(String itemId, String unitId, String unitName) {
    final index =
        selectedWithdrawals.indexWhere((w) => w.inventoryItemId == itemId);
    if (index != -1) {
      selectedWithdrawals[index].measurementUnitId = unitId;
      selectedWithdrawals[index].measurementUnitName = unitName;
      selectedWithdrawals.refresh();
      print(
          'Updated measurement unit for item $itemId to $unitId and $unitName');
    }
  }

  // void updateMeasurementUnit(String itemId, String measurementUnitId) {
  //   final index =
  //       selectedWithdrawals.indexWhere((w) => w.inventoryItemId == itemId);
  //   if (index != -1) {
  //     // Store the measurement unit ID (not the unit name or object)
  //     selectedWithdrawals[index].measurementUnitId = measurementUnitId;
  //     selectedWithdrawals.refresh();
  //     print(
  //         'Updated measurement unit ID for item $itemId to $measurementUnitId');
  //   }
  // }

  // Get withdrawal data for specific item
  WithdrawalSelection? getWithdrawalForItem(String itemId) {
    try {
      return selectedWithdrawals.firstWhere((w) => w.inventoryItemId == itemId);
    } catch (e) {
      return null;
    }
  }

  void updateLocationForAllItems() {
    for (var withdrawal in selectedWithdrawals) {
      withdrawal.locationId = selectedLocation.value?.id?.toString();
    }
    selectedWithdrawals.refresh();
  }

  Future fetchAvailableLocations() {
    isLoading(true);

    return _locationServices
        .fetchAvailableLocations(_authController.token.value)
        .then((value) {
      locationsModel(value);

      isLoading(false);

      return locationsModel;
    });
  }

  // Future withdrawItem() {
  // Get.back();
  // showLoading();

  // Build withdrawalData list from selectedItems
//   final withdrawalData = selectedItems.map((item) {
//     return {
//       "inventoryItemsId": item.id,
//       "quantityToWithdraw": item.quantity, // 👈 you must track quantity per item
//       "measurementUnitId": item.measurementUnitId,
//       "withdrawLocationId": selectedLocation.value!.id.toString(),
//     };
//   }).toList();

//   return _withdrawalService
//       .withdrawItems(
//         _authController.membershipId.value,
//         withdrawalData, // 👈 pass list
//         _authController.token.value,
//       )
//       .then((value) async {
//         Get.back();
//         return value;
//       })
//       .catchError((error) {
//         Get.back();
//         showSnackBar(error);
//       });
// }

  Future withdrawItem() {
    // Validate that all required fields are filled
    for (var withdrawal in selectedWithdrawals) {
      if (withdrawal.quantity == null || withdrawal.quantity! <= 0) {
        showSnackBar("Please set quantity for all selected items");
        return Future.error("Invalid quantity");
      }
      if (withdrawal.measurementUnitName == null ||
          withdrawal.measurementUnitName!.isEmpty) {
        showSnackBar("Please select measurement unit for all selected items");
        return Future.error("Missing measurement unit");
      }
    }

    if (selectedLocation.value == null) {
      showSnackBar("Please select a location");
      return Future.error("Missing location");
    }

    // Update location for all items
    updateLocationForAllItems();

    Get.back();
    showLoading();

    final withdrawalData = selectedWithdrawals.map((w) => w.toJson()).toList();

    print('Final withdrawal data: $withdrawalData');

    return _withdrawalService
        .withdrawItems(
      _authController.membershipId.value,
      withdrawalData,
      _authController.token.value,
    )
        .then((value) async {
      Get.back();
      // Clear selections after successful withdrawal
      clearAllSelections();
      showSnackBar(
        "Items withdrawn successfully",
      );
      return value;
    }).catchError((error) {
      Get.back();
      showSnackBar(error.toString());
    });
  }

  Future fetchMeasurementunit() {
    isLoading(true);

    return _withdrawalService
        .fetchMeasumenentUnit(_authController.token.value)
        .then((value) {
      measurementUnitModel(value);
      isLoading(false);
      return measurementUnit;
    });
  }
}
