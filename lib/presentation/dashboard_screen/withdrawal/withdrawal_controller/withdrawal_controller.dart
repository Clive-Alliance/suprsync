import 'package:get/get.dart';
import 'package:suprsync/core/utils/loader.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/models/all_items_model.dart';
import 'package:suprsync/models/location_model.dart';
import 'package:suprsync/models/measurement_unit_model.dart';
import 'package:suprsync/presentation/dashboard_screen/auth/controller/auth_controller.dart';
import 'package:suprsync/services/location_item_service.dart';
import 'package:suprsync/services/withdrawal_service.dart';

class WithdrawalController extends GetxController {
  LocationServices _locationServices = LocationServices();
  WithdrawalService _withdrawalService = WithdrawalService();
  RxList<LocationModel> locationsModel = <LocationModel>[].obs;
  final Rxn<AllItemsModel> selectedValue = Rxn<AllItemsModel>();

  RxList<MeasurementUnitModel> measurementUnitModel =
      <MeasurementUnitModel>[].obs;
  AuthController _authController = Get.find();
  var isLoading = false.obs;
  Rx<int> quantity = 0.obs;
  Rx<String> inventoryItemId = ''.obs;

  Rx<String> measurementUnit = ''.obs;
  Rx<String> measurementUnitId = ''.obs;
  Rx<String> location = ''.obs;
  Rx<String> toLocation = ''.obs;

  Rx<String> value = ''.obs;

  Future fetchAvailableLocatios() {
    isLoading(true);

    return _locationServices
        .fetchAvailableLocations(_authController.token.value)
        .then((value) {
      // Filter the list for valid start dates

      locationsModel(value);

      isLoading(false);

      return locationsModel;
    });
  }

  Future withdrawItem() {
    Get.back();

    print('called here ${location.value}');
    showLoading();
    // shiftId(id);
    // SwapShiftModel swapShiftModel;
    return _withdrawalService
        .withdrawItems(
      _authController.membershipId.value,
      inventoryItemId.value,
      quantity.value,
      measurementUnitId.value.toString(),
      location.value.toString(),
      _authController.token.value,
    )
        .then((value) async {
      Get.back();

      return value;
    }).catchError((error) {
      print('Error fwithdrawing items: $error');
      Get.back();
      showSnackBar(error);
    });
  }

  Future fetchMeasurementunit() {
    isLoading(true);

    return _withdrawalService
        .fetchMeasumenentUnit(_authController.token.value)
        .then((value) {
      // Filter the list for valid start dates

      measurementUnitModel(value);

      isLoading(false);

      return measurementUnit;
    });
  }
}
