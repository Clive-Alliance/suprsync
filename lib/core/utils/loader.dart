import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';

loader() => const Stack(
      children: [
        SpinKitDoubleBounce(
          color: Colors.white,
          size: 50.0,
        )
      ],
    );

showLoading({String? text}) {
  Get.dialog(
      AlertDialog(
        elevation: 0,
        contentPadding: const EdgeInsets.all(20),
        backgroundColor: Colors.transparent,
        content: Center(
          child: SizedBox(
            height: 150,
            width: 150,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black54, // Add a background color
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  loader(),
                  const SizedBox(height: 10),
                  Text(
                    text ?? 'Loading',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 14),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      barrierColor: Colors.transparent,
      barrierDismissible: true);
}
