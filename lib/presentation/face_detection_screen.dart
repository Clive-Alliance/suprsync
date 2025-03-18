import 'dart:convert';
import 'dart:io';

// import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/_http/_stub/_file_decoder_stub.dart';
// import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:local_auth/local_auth.dart';
import 'package:suprsync/core/constants/app_images.dart';

import 'package:suprsync/core/utils/loader.dart';
import 'package:suprsync/core/utils/shared_preferences.dart';
import 'package:suprsync/models/clockin_model.dart';
import 'package:suprsync/models/error_model.dart';
import 'package:suprsync/presentation/homepage/auth/controller/auth_controller.dart';
import 'package:suprsync/presentation/homepage/clockin_page/clockin_controller.dart';

typedef StringToVoidFunc = void Function(String);

class FaceDetentionScreen extends StatefulWidget {
  const FaceDetentionScreen(
      {super.key,
      required this.clockInType,
      required this.shiftId,
      required this.onReply});
  final StringToVoidFunc onReply;

  final String clockInType;
  final String shiftId;
  // final String userId;

  @override
  State<FaceDetentionScreen> createState() => _FaceDetentionScreenState();
}

class _FaceDetentionScreenState extends State<FaceDetentionScreen> {
  ClockInAndOutController clockInController = Get.find();
  final AuthController _authController = Get.find();
  bool hasScannedFace = false;
  checkIn() {
    clockInController
        .clockinController(
      widget.clockInType,
    )
        .then((value) {
      // if (value.clockedIn == Datetime) {
      if (value is ClockInModel) {
        setState(() {
          hasScannedFace = true;
        });
        // Call toggleActiveState with appropriate state after successful response
        // Get.back();

        widget.onReply('Clock In');
      } else {}

      // }
    });

    // Get.back();
    // widget.onReply('Clock In');
  }

  final LocalAuthentication localAuth = LocalAuthentication();

  @override
  void initState() {
    print('your shiftId is ${widget.shiftId}');
    // TODO: implement initState
    super.initState();
    handleBiometrics();
  }

  @override
  Widget build(BuildContext context) {
    // checkIn();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: Image.asset(
                  'assets/icons/arrow-left.png',
                  width: 18,
                  // height: 18,
                ),
              ),
              // const SizedBox(
              //   width: 5,
              // ),
              Text(
                'Back',
                style: context.textTheme.bodySmall
                    ?.copyWith(color: const Color(0xff000000)),
              )
            ],
          ),
        ),
        title: Text(
          'Clock in',
          style: context.textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Obx(() {
          //   return clockInController.loading.value
          //       ? const AlertDialog(
          //           icon: CircularProgressIndicator(
          //             color: Colors.green,
          //           ),
          //         )
          //       : SizedBox();
          // }),
          const Stack(
            children: [
              // Center(
              //   child:
              //       // Text('Checkin'),
              //       !hasScannedFace
              //           ? SmartFaceCamera(
              //               onCapture: (file) {
              //                 checkIn();
              //               },
              //               defaultCameraLens: CameraLens.front,
              //               autoCapture: true,
              //               showControls: false,
              //             )
              //           : CircularProgressIndicator(
              //               color: Colors.green,
              //             ),
              // ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  // checkIn();
                  handleBiometrics();
                  // clockInController.clockinAndOutController(
                  //   widget.userId,
                  //   widget.clockInType,
                  //   id: _authController.userAuth.value!.accessToken,
                  // );
                },
                child: Column(
                  children: [
                    Platform.isAndroid
                        ? SvgPicture.asset(
                            'assets/icons/face_id_image.svg',
                            height: 100,
                            width: 100,
                          )
                        : const Icon(
                            Icons.fingerprint,
                            size: 100,
                          ),
                    Text(
                      'Verify to check in',
                      style: context.textTheme.titleLarge,
                    ),
                  ],
                ),
              )
            ],
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       'Make sure your head is in the circle while\nwe scan your face',
          //       style: context.textTheme.bodySmall,
          //       textAlign: TextAlign.center,
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  handleBiometrics() {
    readString("user").then((value) async {
      bool hasBioMetrics = await localAuth.canCheckBiometrics;
      print(
          'got android, has biometric $hasBioMetrics'); //check if there is authencations,
      if (hasBioMetrics) {
        List<BiometricType> availableBiometrics =
            await localAuth.getAvailableBiometrics();
        if (Platform.isIOS) {
          if (availableBiometrics.contains(BiometricType.face)) {
            try {
              bool pass = await localAuth.authenticate(
                localizedReason: 'Scan Face To Login',
                options: const AuthenticationOptions(
                    useErrorDialogs: true,
                    stickyAuth: true,
                    biometricOnly: true),
              );

              if (pass) {
                checkIn();
              }
            } on PlatformException catch (e) {
              // setState(() {
              //   login = true;
              // });
            }
          }
        } else {
          print(
              'platform is android section, has biometric $hasBioMetrics'); //check if there is authencations,
          print(availableBiometrics);
          // if (availableBiometrics.contains(BiometricType.fingerprint)) {
          print('tireddd $hasBioMetrics'); //check if there is authencations,

          try {
            bool pass = await localAuth.authenticate(
              localizedReason: 'Touch fingerprint to scan',
              options: const AuthenticationOptions(
                  useErrorDialogs: true, stickyAuth: true, biometricOnly: true),
            );

            if (pass) {
              checkIn();
            }
          } on PlatformException catch (e) {
            // setState(() {
            //   login = true;
            // });
          }
          // }
        }
      }
    });
  }
}
