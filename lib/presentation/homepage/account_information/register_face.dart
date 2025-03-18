// import 'package:face_camera/face_camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FaceRegistration extends StatefulWidget {
  const FaceRegistration({
    super.key,
  });

  @override
  State<FaceRegistration> createState() => _FaceRegistrationState();
}

class _FaceRegistrationState extends State<FaceRegistration> {
  // ClockInAndOutController clockInController = Get.find();
  // final AuthController _authController = Get.find();
  bool hasScannedFace = false;
  checkIn() {
    setState(() {
      hasScannedFace = true;
    });
    // clockInController
    //     .clockInAndOut(widget.userId, widget.clockInType,
    //         _authController.userAuth.value!.accessToken)
    //     .then((value) {});

    const AlertDialog(
      icon: CircularProgressIndicator(
        color: Colors.green,
      ),
    );
    Get.back();
    // widget.onReply('Clock In');
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
          'Register face',
          style: context.textTheme.bodyLarge,
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              // Center(
              //   child:
              //       // Text('Checkin')
              //       // !hasScannedFace
              //       //     ? SmartFaceCamera(
              //       //         onCapture: (file) {
              //       //           checkIn();
              //       //         },
              //       //         defaultCameraLens: CameraLens.front,
              //       //         autoCapture: true,
              //       //         showControls: false,
              //       //       )
              //       //     : CircularProgressIndicator(
              //       //         color: Colors.green,
              //       //       ),
              // ),
            ],
          ),
          Text(
            'VScanning',
            style: context.textTheme.bodyLarge,
          ),
          Text(
            'Make sure your head is in the circle while\nwe scan your face',
            style: context.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
