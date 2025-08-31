import 'dart:async';

import 'package:geolocator/geolocator.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:suprsync/core/utils/loader.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/models/checkin_schedule_model.dart';
import 'package:suprsync/presentation/dashboard_screen/auth/controller/auth_controller.dart';
import 'package:suprsync/presentation/dashboard_screen/schedules/shedules_controller/available_shifts_controller.dart';
import 'package:suprsync/services/clock_in_services.dart';

enum ShiftStatus {
  offClock,
  clockingIn,
  onClock,
  onBreak,
  clockedOut,
}

enum InfoType { none, success, error }

// class ClockInAndOutController extends GetxService {
//   final ClockinServices _clockinServices = ClockinServices();
//   Rx<String> swapId = ''.obs;
//   Rx<bool> clockedIn = false.obs;
//   Rx<String> shiftId = ''.obs;
//   Rx<String> clockOutShiftId = ''.obs;
//   RxList<CheckInScheduleModel> pastScheduleModel = <CheckInScheduleModel>[].obs;
//   final AuthController _authController = Get.find();
//   final ShiftController _shiftController = Get.put(ShiftController());
//   Rx<DateTime> from =
//       DateTime(DateTime.now().year, DateTime.now().month, 1).obs;
//   Rx<DateTime> to = DateTime.now().obs;
//   final LocalAuthentication localAuth = LocalAuthentication();

//   ///
//   final Rx<String> firstClockedInShiftId = ''.obs;

//   /// new flow
//   ///
//   var status = ShiftStatus.offClock.obs;
//   var timerText = "00:00:00".obs;

//   DateTime? _clockInTime;
//   Timer? _timer;

//   // ✅ Set your shift location (example: Lagos coordinates)
//   // final double shiftLat = 6.5244;
//   // final double shiftLng = 3.3792;
//   final double radiusMeters = 100; // how close they must be (100m)

//   var infoMessage = "".obs;
//   var infoType = InfoType.none.obs; // success, error, none

//   void showError(String msg) {
//     infoMessage.value = msg;
//     infoType.value = InfoType.error;
//   }

//   void showSuccess(String msg) {
//     infoMessage.value = msg;
//     infoType.value = InfoType.success;
//   }

//   String get statusText {
//     switch (status.value) {
//       case ShiftStatus.onClock:
//         return "You are clocked in";
//       default:
//         return "You are off the clock";
//     }
//   }

//   Future<bool> _checkLocationPermission() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         Get.snackbar(
//             "Permission Denied", "Location access is required to clock in.");
//         return false;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       Get.snackbar("Permission Blocked", "Enable location access in settings.");
//       return false;
//     }
//     return true;
//   }

//   // // 📍 Verify location against shift location
//   Future<Position?> _getUserLocation() async {
//     final hasPermission = await _checkLocationPermission();
//     if (!hasPermission) return null;

//     try {
//       return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//     } catch (e) {
//       Get.snackbar("Location Error", "Unable to fetch location: $e");
//       return null;
//     }
//   }

//    Future<void> attemptClockIn() async {
//     status.value = ShiftStatus.clockingIn;
//     showLoading();

//     // Clear previous messages
//     infoMessage.value = "";
//     infoType.value = InfoType.none;

//     final pos = await _getUserLocation();
//     if (pos == null) {
//       status.value = ShiftStatus.offClock;
//       Get.back();
//       return;
//     }

//     final nextShift = _shiftController.nextShift;
//     if (nextShift == null) {
//       status.value = ShiftStatus.offClock;
//       Get.back();
//       showError("No upcoming shift found.");
//       return;
//     }

//   //   print('your next shift is ${nextShift.id}');
//   //   final success = await clockin(
//   //       'clockIn',
//   //       '2922ed5b-3e8c-42c1-ae7b-9c0ab115c409',
//   //       // nextShift.id,
//   //       28.443787400,
//   //       -81.475699400
//   //       // pos.longitude,
//   //       // pos.latitude
//   //       );
//   //   if (success) {
//   //     _clockInTime = DateTime.now();
//   //     status.value = ShiftStatus.onClock;
//   //     _startTimer();
//   //   } else {
//   //     status.value = ShiftStatus.offClock;
//   //   }
//   // }

//    print('your next shift is ${nextShift.id}');
//     try {
//       final success = await clockin(
//           'clockIn',
//           '2922ed5b-3e8c-42c1-ae7b-9c0ab115c409',
//           28.443787400,
//           -81.475699400
//       );

//       if (success) {
//         _clockInTime = DateTime.now();
//         status.value = ShiftStatus.onClock;
//         _startTimer();
//         showSuccess("Successfully clocked in!");
//       } else {
//         status.value = ShiftStatus.offClock;
//         showError("Clock in failed. Please try again.");
//       }
//     } catch (e) {
//       status.value = ShiftStatus.offClock;
//       showError("Clock in failed: ${e.toString()}");
//     }
//   }

//   Future<void> attemptClockOut() async {
//     showLoading();

//     // Clear previous messages
//     infoMessage.value = "";
//     infoType.value = InfoType.none;

//     final pos = await _getUserLocation();
//     if (pos == null) {
//       Get.back();
//       return;
//     }

//     try {
//       final success = await clockin(
//           'clockOut',
//           firstClockedInShiftId.value,
//           pos.longitude,
//           pos.latitude
//       );

//       if (success) {
//         _stopAllTimers();
//         status.value = ShiftStatus.offClock; // Reset to off clock
//         timerText.value = "00:00:00";
//         breakTimerText.value = "00:00:00";
//         showSuccess("Successfully clocked out!");
//       } else {
//         showError("Clock out failed. Please try again.");
//       }
//     } catch (e) {
//       showError("Clock out failed: ${e.toString()}");
//     }
//   }

//   // ⏱ Start timer after clock-in
//    void _startTimer() {
//     _timer?.cancel();
//     _timer = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (_clockInTime != null) {
//         final elapsed = DateTime.now().difference(_clockInTime!);
//         if (elapsed >= const Duration(hours: 8)) {
//           _timer?.cancel();
//         }
//         timerText.value = _formatDuration(elapsed);
//       }
//     });
//   }

//   // Start break timer
//   void _startBreakTimer() {
//     _breakTimer?.cancel();
//     _breakStartTime = DateTime.now();
//     _breakTimer = Timer.periodic(const Duration(seconds: 1), (_) {
//       if (_breakStartTime != null) {
//         final elapsed = DateTime.now().difference(_breakStartTime!);
//         breakTimerText.value = _formatDuration(elapsed);
//       }
//     });
//   }

//   // Stop break timer and resume work timer
//   void _stopBreakTimer() {
//     _breakTimer?.cancel();
//     breakTimerText.value = "00:00:00";
//     // Resume the main timer
//     _startTimer();
//   }

//   String _formatDuration(Duration d) {
//     final h = d.inHours.toString().padLeft(2, '0');
//     final m = (d.inMinutes % 60).toString().padLeft(2, '0');
//     final s = (d.inSeconds % 60).toString().padLeft(2, '0');
//     return "$h:$m:$s";
//   }

//   // ✅ Clock out
//   void startBreak() {
//     _timer?.cancel(); // Stop work timer
//     status.value = ShiftStatus.onBreak;
//     _startBreakTimer();
//     showSuccess("Break started!");
//   }

//   // End break
//   void endBreak() {
//     _stopBreakTimer();
//     status.value = ShiftStatus.onClock;
//     showSuccess("Break ended. Back to work!");
//   }

//   // Stop all timers
//   void _stopAllTimers() {
//     _timer?.cancel();
//     _breakTimer?.cancel();
//   }

//   @override
//   void onClose() {
//     _timer?.cancel();
//     super.onClose();
//   }

//   updateClockoutid(value) {
//     firstClockedInShiftId(value);
//   }

//   Future clockin(type, shiftId, long, lat) {
//     // shiftId(id);

//     return _clockinServices
//         .clockInAndOut(
//             type,
//             shiftId,
//             _authController.token.toString(),
//             // "27.6648", "81.5158"
//             long.toString(),
//             lat.toString())
//         .then((value) async {
//       if (type == 'clockIn') {
//         updateClockoutid(shiftId.value);
//       }
//       showSuccess(value);
//       Get.back();
//       return value;
//     }).catchError((error) {
//       print('$error');
//       Get.back();
//       showError(error);
//       // showSnackBar(error);
//     });
//   }

//   // Future clockOutController(type, shiftId, long, lat) {
//   //   showLoading();

//   //   return _clockinServices
//   //       .clockInAndOut(
//   //           type,
//   //           shiftId
//   //           _authController.token.toString(),
//   //           long,
//   //           lat)
//   //       .then((value) async {
//   //     Get.back();
//   //     return value;
//   //   }).catchError((error) {
//   //     print('Error fetching blocked dates: $error');
//   //     Get.back();

//   //     showSnackBar(error);
//   //   });
//   // }

//   Future getClockInSchedule() {
//     return _clockinServices
//         .clockInSchedule(
//       from.value,
//       to.value,
//       _authController.userId.value,
//       _authController.token.value,
//     )
//         .then((value) {
//       pastScheduleModel(value);
//       print(pastScheduleModel.value.first);

//       print(from.value);
//       print(to.value);
//       return pastScheduleModel;
//     }).catchError((onError) {
//       showSnackBar(onError.toString());
//     });
//   }
// }
class ClockInAndOutController extends GetxService {
  final ClockinServices _clockinServices = ClockinServices();
  final info = NetworkInfo();

  Rx<String> swapId = ''.obs;
  Rx<bool> clockedIn = false.obs;
  Rx<String> shiftId = ''.obs;
  Rx<String> clockOutShiftId = ''.obs;
  Rx<String> wifiName = ''.obs;
  RxList<CheckInScheduleModel> pastScheduleModel = <CheckInScheduleModel>[].obs;
  final AuthController _authController = Get.find();
  final ShiftController _shiftController = Get.put(ShiftController());
  Rx<DateTime> from =
      DateTime(DateTime.now().year, DateTime.now().month, 1).obs;
  Rx<DateTime> to = DateTime.now().obs;
  final LocalAuthentication localAuth = LocalAuthentication();

  ///
  final Rx<String> firstClockedInShiftId = ''.obs;

  /// new flow
  ///
  var status =
      ShiftStatus.offClock.obs; // Only use: offClock, clockedIn, onBreak
  var timerText = "00h:00m:00s".obs;
  var breakTimerText = "00h:00m:00s".obs; // Add break timer text

  DateTime? _clockInTime;
  DateTime? _breakStartTime;
  Timer? _timer;
  Timer? _breakTimer;

  final double radiusMeters = 100;

  var infoMessage = "".obs;
  var infoType = InfoType.none.obs;

  void showError(String msg) {
    infoMessage.value = msg;
    infoType.value = InfoType.error;
  }

  void showSuccess(String msg) {
    infoMessage.value = msg;
    infoType.value = InfoType.success;
  }

  String get statusText {
    switch (status.value) {
      case ShiftStatus.clockingIn:
        return "You're clocked in";
      case ShiftStatus.onBreak:
        return "You're on break";
      default:
        return "You're off the clock";
    }
  }

  Future<void> getWifiName() async {
    final name = await info.getWifiName();
    print('your wifi name is $name');
    wifiName.value = name.toString();
  }

  Future<bool> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showError("Location access is required to clock in.");
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      showError("Enable location access in settings.");
      return false;
    }
    return true;
  }

  Future<Position?> _getUserLocation() async {
    final hasPermission = await _checkLocationPermission();
    if (!hasPermission) return null;

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      showError("Unable to fetch location: $e");
      return null;
    }
  }

  // This method is called when ActionCircle completes the press-and-hold for clock in
  Future<void> attemptClockIn() async {
    // Clear previous messages
    infoMessage.value = "";
    infoType.value = InfoType.none;
    showLoading();
    final pos = await _getUserLocation();
    if (pos == null) {
      showError("Unable to get location. Please enable location services.");
      return;
    }

    final nextShift = _shiftController.nextShift;
    if (nextShift == null) {
      showError("No upcoming shift found.");
      return;
    }

    print('your next shift is ${nextShift.id}');
    try {
      final success = await clockin(
          'clockIn', nextShift.id.toString(), -81.475699400, 28.443787400);
      print('your res is $success');

      if (success) {
        _clockInTime = DateTime.now();
        status.value = ShiftStatus.clockingIn;
        _startTimer();
        // _shiftController.markShiftAsActivated(nextShift.id.toString());
        showSuccess("Successfully clocked in!");
      } else {
        showError("Clock in failed. Please try again.");
      }
    } catch (e) {
      showError(e.toString());
    }
  }

  Future<void> attemptClockOut() async {
    showLoading();
    infoMessage.value = "";
    infoType.value = InfoType.none;

    final pos = await _getUserLocation();
    if (pos == null) {
      showError("Unable to get location for clock out.");
      return;
    }

    try {
      final success = await clockin(
          'clockOut', firstClockedInShiftId.value, -81.475699400, 28.443787400
          //  pos.longitude, pos.latitude
          );

      if (success) {
        _stopAllTimers();
        status.value = ShiftStatus.offClock;
        timerText.value = "00h:00m:00s";
        breakTimerText.value = "00h:00m:00s";
        showSuccess("Successfully clocked out!");
      } else {
        showError("Clock out failed. Please try again.");
      }
    } catch (e) {
      showError("Clock out failed: ${e.toString()}");
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_clockInTime != null) {
        final elapsed = DateTime.now().difference(_clockInTime!);
        if (elapsed >= const Duration(hours: 8)) {
          _timer?.cancel();
        }
        timerText.value = _formatDuration(elapsed);
      }
    });
  }

  void _startBreakTimer() {
    _breakTimer?.cancel();
    _breakStartTime = DateTime.now();
    _breakTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_breakStartTime != null) {
        final elapsed = DateTime.now().difference(_breakStartTime!);
        breakTimerText.value = _formatDuration(elapsed);
      }
    });
  }

  void _stopBreakTimer() {
    _breakTimer?.cancel();
    breakTimerText.value = "00:00:00";
    _startTimer();
  }

  String _formatDuration(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$h:$m:$s";
  }

  void startBreak() {
    _timer?.cancel();
    status.value = ShiftStatus.onBreak;
    _startBreakTimer();
    showSuccess("Break started!");
  }

  void endBreak() {
    _stopBreakTimer();
    status.value = ShiftStatus.clockingIn;
    showSuccess("Break ended. Back to work!");
  }

  void _stopAllTimers() {
    _timer?.cancel();
    _breakTimer?.cancel();
  }

  @override
  void onClose() {
    _stopAllTimers();
    super.onClose();
  }

  updateClockoutid(value) {
    firstClockedInShiftId(value);
  }

  Future<bool> clockin(
      String type, String shiftId, double long, double lat) async {
    try {
      final result = await _clockinServices.clockInAndOut(
          type,
          shiftId,
          _authController.token.toString(),
          long.toString(),
          lat.toString(),
          wifiName.value);
      print('clockin result $result');
      if (type == 'clockIn') {
        updateClockoutid(shiftId);
      }
      // Don't call Get.back() here since we're not using showLoading
      return true;
    } catch (error) {
      Get.back();
      print('Clock in/out error: $error');
      throw error;
    }
  }
}
