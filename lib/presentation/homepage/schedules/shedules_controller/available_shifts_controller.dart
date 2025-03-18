import 'package:get/get.dart';
import 'package:suprsync/core/utils/loader.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/models/shifts_model.dart';
import 'package:suprsync/models/swap_shift_model.dart';
import 'package:suprsync/presentation/homepage/auth/controller/auth_controller.dart';
import 'package:suprsync/services/shifts_services.dart';

class ShiftController extends GetxController {
  ShiftsServices _shiftsServices = ShiftsServices();
  RxList<ShiftsModel> shiftsModel = <ShiftsModel>[].obs;
  AuthController _authController = Get.find();
  Rx<String> shiftId = ''.obs;

  var isLoading = false.obs;
  Rx<DateTime> from = DateTime(DateTime.now().year, DateTime.now().month, 1)
      .obs; // Default: 2 weeks ago
  Rx<DateTime> to = DateTime(
    DateTime.now().year,
    DateTime.now().month + 1,
    1,
  ).subtract(Duration(seconds: 1)).obs;

  // Getter to format dates for the backend
  Rx<bool> filterApplied = false.obs;
  Rx<bool> rangeSelected = false.obs;

  Future fetchAvailableShift() {
    isLoading(true);

    return _shiftsServices
        .fetchAvailableShifts(
      _authController.userId.value,
      from.value,
      to.value,
      _authController.token.value,
      isfiltered: filterApplied.value,
    )
        .then((value) {
      // Filter the list for valid start dates
      var filteredShifts = value.where((ShiftsModel shift) {
        return shift.start != null;
      }).toList();
      var swappableFilteredShifts = value.where((ShiftsModel shift) {
        return shift.start != null && shift.swappable == true;
      }).toList();
      var inSwappableFilteredShifts = value.where((ShiftsModel shift) {
        return shift.start != null && shift.swappable == false;
      }).toList();
      // swappableShiftsModel(swappableFilteredShifts);
      // inSwappableShiftsModel(inSwappableFilteredShifts);
      shiftsModel(filteredShifts);
      // print(shiftsModel.value.first);
      isLoading(false);
      print(from.value);
      print(to.value);

      return shiftsModel;
    });
  }

  Future swapShift(
    value,
  ) {
    showLoading();
    // shiftId(id);
    print('your shiftId is ${shiftId.value}');
    SwapShiftModel swapShiftModel;
    return _shiftsServices
        .swapshifts(
      shiftId.value,
      value,
      _authController.token.value,
    )
        .then((value) async {
      Get.back();
      return value;
      // showSnackBar('time off requested successfully');
    }).catchError((error) {
      print('Error fetching blocked dates: $error');
      Get.back();

      showSnackBar(error);
    });
  }
}
