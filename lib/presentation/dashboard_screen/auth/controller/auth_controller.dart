import 'dart:convert';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:suprsync/core/utils/loader.dart';
import 'package:suprsync/core/utils/show_snackbar.dart';
import 'package:suprsync/models/error_model.dart';
import 'package:suprsync/models/signin_model.dart';
import 'package:suprsync/presentation/dashboard_screen/auth/login_page.dart';
import 'package:suprsync/presentation/dashboard_screen/homepage.dart';
import 'package:suprsync/presentation/dashboard_screen/shift_set/shift_set_controller.dart';
import 'package:suprsync/presentation/dashboard_screen/shift_set/shift_set_tour_page.dart';
import 'package:suprsync/services/auth_service.dart';
import '../../../../core/utils/shared_preferences.dart';

class AuthController extends GetxController {
  final Authentication _authentication = Authentication();
  final LocalAuthentication localAuth = LocalAuthentication();

  var userAuth = Rxn<SignInUserModel>();
  var userId = ''.obs; // Define userAuth as private variable
  final Rx<String> userDp = ''.obs;
  final Rx<String> firstName = ''.obs;
  final Rx<String> lastName = ''.obs;
  final Rx<String> email = ''.obs;
  final Rx<String> gender = ''.obs;
  final Rx<String> token = ''.obs;
  Rx<String> membershipId = ''.obs;
  Rx<bool> isEditMode = false.obs;

  // final Rx<String> firstName = ''.obs;

  // Getter to access the current userAuth
  // final Rx<String> email = ''.obs;

  updateUserDetails(SignInUserModel value) {
    firstName(value.user?.firstName ?? '');
    lastName(value.user?.lastName ?? '');
    email(value.user?.email ?? '');
    gender(value.user?.gender ?? '');
    token(value.accessToken ?? '');
    final memberships = value.activeCompany?.memberships;
    membershipId(
      memberships != null && memberships.isNotEmpty
          ? (memberships.first.id ?? '')
          : '',
    );
    userDp(value.user?.picture?.url ?? '');
  }

  Future<void> _openAfterAuth() async {
    final shiftSets = Get.find<ShiftSetController>();
    var hasShiftSet = false;
    try {
      hasShiftSet = await shiftSets.loadCurrent(
        token: token.value,
        userId: userId.value,
        companyId: userAuth.value?.activeCompany?.id,
      );
    } catch (_) {
      hasShiftSet = shiftSets.shiftSet.value != null;
    }
    if (hasShiftSet) {
      Get.offAll(() => const HomePage());
    } else {
      Get.offAll(() => const ShiftSetTourPage());
    }
  }

  void loadDetails() {
    read("user").then((value) async {
      if (value == null) {
        Get.to(() => const LoginScreen());
      } else if (value['accessToken'] != null) {
        userAuth(SignInUserModel.fromJson(value));
        updateUserDetails(userAuth.value!);
        // _userAuth.value = SignInUserModel.fromJson(value);
        // saveUserDp(_userAuth.value!.user!.pprefs!.avatar);
        userId(userAuth.value!.user!.id.toString());
        await _openAfterAuth();
      }
      // else {
      //     // userAuth2 = UserModelUseUnverified.fromJson(value);
      //   }
      //   // notifyListeners();
    });
  }

  void signIn(email, password) {
    showLoading();
    _authentication.signIn(email, password).then((value) async {
      if (value is SignInUserModel) {
        userAuth(value);
        saveDetails("user", value);
        updateUserDetails(value);
        userId(value.user!.id.toString());
        Get.back();
        await _openAfterAuth();
      }
    }).catchError((onError) {
      ErrorModel errorModel = ErrorModel.fromJson(jsonDecode(onError['body']));
      showSnackBar(errorModel.message.toString());
    });
  }

  forgotPassword(revoveryEmail) {
    _authentication.forgotPassword(revoveryEmail).then((value) {
      return value;
    }).catchError((onError) {
      showSnackBar(onError.toString());
    });
  }

  //  final user = context.read<AuthProvider>().getuser;
  // biometricCheckin(type) async {
  //   log('this was called');
  //   bool hasBioMetrics =
  //       await localAuth.canCheckBiometrics; //check if there is authencations,
  //   if (hasBioMetrics) {
  //     log('has biometrics');
  //     List<BiometricType> availableBiometrics =
  //         await localAuth.getAvailableBiometrics();
  //     print('your available biometrics $availableBiometrics');
  //     // if (Platform.isIOS) {
  //     if (availableBiometrics.contains(BiometricType.face) ||
  //         availableBiometrics.contains(BiometricType.weak)) {
  //       try {
  //         log('tried this');
  //         bool pass = await localAuth.authenticate(
  //           localizedReason: 'Scan Face To Check in',
  //           options: const AuthenticationOptions(
  //               useErrorDialogs: true, stickyAuth: true, biometricOnly: true),
  //         );

  //         if (pass) {
  //           // setState(() => isLoading = true);
  //           print('you passed');
  //           _clockinServices
  //               .clockInAndOut(
  //                   userAuth.value!.user!.id.toString(), type.toString())
  //               .then((value) {
  //             if (value is ClockInModel) {
  //               print(value);
  //               Get.back();
  //             } else {}
  //             // setState(() => isLoading = false);
  //           }).catchError((onError) {
  //             // setState(() => isLoading = false);
  //             ErrorModel err = ErrorModel.fromJson(jsonDecode(onError['body']));
  //             // showMessage(err.message, context);
  //           });
  //         } else {
  //           // setState(() => login = true);
  //           print('did not pass');
  //         }
  //       } on PlatformException catch (e) {
  //         print(e);
  //         // setState(() {
  //         //   login = true;
  //         // });
  //       }
  //     } else {
  //       localAuth.authenticate(
  //         localizedReason: 'Scan fface to check in',
  //         options: const AuthenticationOptions(
  //             useErrorDialogs: true, stickyAuth: true, biometricOnly: true),
  //       );
  //     }
  // else if (availableBiometrics.contains(BiometricType.fingerprint)) {
  //   try {
  //     bool pass = await localAuth.authenticate(
  //       localizedReason: 'Scan Face To Login',
  //       options: const AuthenticationOptions(
  //           useErrorDialogs: true, stickyAuth: true, biometricOnly: true),
  //     );

  //     if (pass) {
  //       // setState(() => isLoading = true);
  //       auth
  //           .signIn(user.user!.email.toString(), value.toString())
  //           .then((value) {
  //         setState(() => isLoading = false);
  //         context.read<AuthProvider>().setUpUserInfo(value, context);
  //       }).catchError((onError) {
  //         setState(() => isLoading = false);
  //         ErrorModel err =
  //             ErrorModel.fromJson(jsonDecode(onError['body']));
  //         showMessage(err.message, context);
  //       });
  //     }
  //   } on PlatformException catch (e) {
  //     setState(() {
  //       login = true;
  //     });
  //   }
  // }
  // }
  // } else {
  //   // setState(() => login = true);
  // }
  // }
}
