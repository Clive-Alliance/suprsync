import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:suprsync/core/utils/loader.dart';
import 'package:suprsync/core/utils/shared_preferences.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/models/checkin_schedule_model.dart';
import 'package:suprsync/models/clockin_model.dart';
import 'package:suprsync/models/error_model.dart';
import 'package:suprsync/presentation/homepage/auth/controller/auth_controller.dart';
import 'package:suprsync/services/clock_in_services.dart';

class ClockInAndOutController extends GetxService {
  final ClockinServices _clockinServices = ClockinServices();
  Rx<String> swapId = ''.obs;
  Rx<bool> clockedIn = false.obs;
  Rx<String> shiftId = ''.obs;
  Rx<String> clockOutShiftId = ''.obs;
  RxList<CheckInScheduleModel> pastScheduleModel = <CheckInScheduleModel>[].obs;
  final AuthController _authController = Get.find();
  Rx<DateTime> from = DateTime(DateTime.now().year, DateTime.now().month, 1)
      .obs; // Default: 2 weeks ago
  Rx<DateTime> to = DateTime.now().obs;
  final LocalAuthentication localAuth = LocalAuthentication();
  final Rx<String> firstClockedInShiftId = ''.obs;

  updateClockoutid(value) {
    firstClockedInShiftId(value);
  }

  Future clockinController(
    type,
  ) {
    showLoading();
    // shiftId(id);
    print('your shiftId is ${firstClockedInShiftId.value}');
    ClockInModel clockInModel;
    return _clockinServices
        .clockInAndOut(
      type,
      shiftId.value,
      _authController.token.toString(),
    )
        .then((value) async {
      if (type == 'clockIn') {
        updateClockoutid(shiftId.value);

        // Save the first clocked-in shift ID if not already set
      }

      Get.back();
      return value;
      // showSnackBar('time off requested successfully');
    }).catchError((error) {
      print('Error fetching blocked dates: $error');
      Get.back();

      showSnackBar(error);
    });
  }

  Future clockOutController(
    type,
  ) {
    showLoading();
    // shiftId(id);
    print('your shiftId is ${firstClockedInShiftId.value}');
    ClockInModel clockInModel;
    return _clockinServices
        .clockInAndOut(
      type,
      type == 'clockIn' ? shiftId.value : firstClockedInShiftId.value,
      _authController.token.toString(),
    )
        .then((value) async {
      Get.back();
      return value;
    }).catchError((error) {
      print('Error fetching blocked dates: $error');
      Get.back();

      showSnackBar(error);
    });
  }

  Future getClockInSchedule() {
    return _clockinServices
        .clockInSchedule(
      from.value,
      to.value,
      _authController.userId.value,
      _authController.token.value,
    )
        .then((value) {
      pastScheduleModel(value);
      print(pastScheduleModel.value.first);

      print(from.value);
      print(to.value);
      return pastScheduleModel;
    }).catchError((onError) {
      showSnackBar(onError.toString());
    });
  }

//   useBiometrics(    Function(String) onReply, // Pass the callback method
// ) {
//     readString("user").then((value) async {
//       bool hasBioMetrics =
//           await localAuth.canCheckBiometrics; //check if there is authencations,
//       if (hasBioMetrics) {
//         List<BiometricType> availableBiometrics =
//             await localAuth.getAvailableBiometrics();
//         if (Platform.isIOS) {
//           if (availableBiometrics.contains(BiometricType.face)) {
//             try {
//               bool pass = await localAuth.authenticate(
//                 localizedReason: 'Scan Face To Login',
//                 options: const AuthenticationOptions(
//                     useErrorDialogs: true,
//                     stickyAuth: true,
//                     biometricOnly: true),
//               );

//               if (pass) {
//                 checkIn(onReply:onReply);
//               }
//             } on PlatformException catch (e) {
//               // setState(() {
//               //   login = true;
//               // });
//             }
//           } else if (availableBiometrics.contains(BiometricType.fingerprint)) {
//             try {
//               bool pass = await localAuth.authenticate(
//                 localizedReason: 'Scan Face To Login',
//                 options: const AuthenticationOptions(
//                     useErrorDialogs: true,
//                     stickyAuth: true,
//                     biometricOnly: true),
//               );

//               if (pass) {
//                 checkIn();
//               }
//             } on PlatformException catch (e) {
//               // setState(() {
//               //   login = true;
//               // });
//             }
//           }
//         }
//       } else {
//         // setState(() => login = true);
//       }
//     });
//   }

//   checkIn(
//     clockInType,
//     Function(String) onReply, // Pass the callback method
//   ) {
//     clockinAndOutController(
//       clockInType,
//     ).then((value) {
//       // if (value.clockedIn == Datetime) {
//       if (value is ClockInModel) {
//         onReply('Clock In');

//         // Call toggleActiveState with appropriate state after successful response
//         // Get.back();
//       } else {}

//       // }
//     });

//     // Get.back();
//     // widget.onReply('Clock In');
//   }
}
