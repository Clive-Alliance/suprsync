import 'package:get/get.dart';
import 'package:suprsync/core/utils/loader.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/models/shifts_model.dart';
import 'package:suprsync/presentation/dashboard_screen/auth/controller/auth_controller.dart';
import 'package:suprsync/services/shifts_services.dart';

class ShiftController extends GetxController {
  final ShiftsServices _shiftsServices = ShiftsServices();
  final RxList<ShiftsModel> _shiftsModel = <ShiftsModel>[].obs;
  final RxList<ShiftsModel> _userShiftsModel = <ShiftsModel>[].obs;

  // Fixed getter - was returning _shiftsModel for both
  List<ShiftsModel> get shiftsModel => _shiftsModel;
  List<ShiftsModel> get userShiftsModel =>
      _userShiftsModel; // Fixed: was _shiftsModel

  // This getter returns the appropriate list based on filter state
  List<ShiftsModel> get currentShifts =>
      filterApplied.value ? _userShiftsModel : _shiftsModel;

  final AuthController _authController = Get.find();
  Rx<String> shiftId = ''.obs;

  var isLoading = false.obs;
  Rx<DateTime> from = DateTime(DateTime.now().year, DateTime.now().month, 1)
      .obs; // Default: 2 weeks ago
  Rx<DateTime> to = DateTime(
    DateTime.now().year,
    DateTime.now().month + 2,
    1,
  ).subtract(const Duration(seconds: 1)).obs;

  Rx<bool> filterApplied = false.obs;
  Rx<bool> rangeSelected = false.obs;

  ShiftsModel? get nextShift =>
      upcomingShifts.isNotEmpty ? upcomingShifts.first : null;

  List<ShiftsModel> get upcomingShifts {
    final today = DateTime.now();

    final shifts = _userShiftsModel.where((shift) {
      if (shift.start == null) return false;
      if (shift.slot == null) return false; // ✅ ensure slot exists
      if (shift.slot?.branch == null) return false; // ✅ ensure branch exists

      try {
        final start = DateTime.parse(shift.start.toString());
        return !start.isBefore(today);
      } catch (e) {
        return false;
      }
    }).toList();

    shifts.sort((a, b) {
      try {
        final startA = DateTime.parse(a.start.toString());
        final startB = DateTime.parse(b.start.toString());
        return startA.compareTo(startB);
      } catch (e) {
        return 0;
      }
    });

    return shifts;
  }

  void toggleFilter() {
    filterApplied.value = !filterApplied.value;
  }

  // Set filter state directly
  void setFilter(bool showUserShiftsOnly) {
    filterApplied.value = showUserShiftsOnly;
  }

  Future fetchAllShifts() {
    isLoading(true);

    return _shiftsServices
        .fetchAllShifts(
      _authController.userId.value,
      from.value,
      to.value,
      _authController.token.value,
      isfiltered: false,
    )
        .then((value) {
      var filteredShifts = value.where((ShiftsModel shift) {
        return shift.start != null;
      }).toList();
      // var swappableFilteredShifts = value.where((ShiftsModel shift) {
      //   return shift.start != null && shift.swappable == true;
      // }).toList();
      // var inSwappableFilteredShifts = value.where((ShiftsModel shift) {
      //   return shift.start != null && shift.swappable == false;
      // }).toList();

      _shiftsModel(filteredShifts);
      isLoading(false);

      return shiftsModel;
    });
  }

  // Fetch user shifts only - always pass true for isfiltered
  Future fetchUserShifts() {
    isLoading(true);

    return _shiftsServices
        .fetchUserShifts(
      _authController.userId.value,
      from.value,
      to.value,
      _authController.token.value,
      isfiltered: true, // Always true to get user shifts only
    )
        .then((value) {
      // Filter the list for valid start dates
      var filteredShifts = value.where((ShiftsModel shift) {
        return shift.start != null;
      }).toList();
      // var swappableFilteredShifts = value.where((ShiftsModel shift) {
      //   return shift.start != null && shift.swappable == true;
      // }).toList();
      // var inSwappableFilteredShifts = value.where((ShiftsModel shift) {
      //   return shift.start != null && shift.swappable == false;
      // }).toList();

      _userShiftsModel(filteredShifts);
      isLoading(false);
      print('Fetched ${filteredShifts.length} user shifts');
      print('Date range: ${from.value} to ${to.value}');

      return userShiftsModel;
    });
  }

  // Fetch both types of shifts
  Future fetchBothShiftTypes() async {
    try {
      await Future.wait([
        fetchAllShifts(),
        fetchUserShifts(),
      ]);
      print('Both shift types fetched successfully');
    } catch (e) {
      print('Error fetching shifts: $e');
      isLoading(false);
    }
  }

  Future swapShift(
    value,
  ) {
    showLoading();
    // shiftId(id);
    print('your shiftId is ${shiftId.value}');
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
