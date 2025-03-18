import 'package:flutter/material.dart';
import 'package:get/get.dart' hide ContextExtensionss;
import 'package:suprsync/core/utils/app_button.dart';
import 'package:suprsync/core/constants/extentions/theme_extention.dart';

showAlertDialog(VoidCallback onTapFunction) {
  Get.dialog(Dialog(
      insetPadding: EdgeInsets.zero,
      child: Container(
        width: 300,
        height: 280,
        decoration: const BoxDecoration(
          // borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        // size.width,
        padding:
            const EdgeInsets.only(left: 16.0, right: 16.0, top: 20, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.close)),
            ]),
            const Text("Unavailable",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff2C2C2C))),
            const SizedBox(
              height: 16,
            ),
            const Text(
              "Selected day is unavailable.\nDo you want to make it available?",
              style: TextStyle(
                // fontSize: 12,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 24,
            ),
            RectangularButton(
              onPress: () {
                Get.back();
                onTapFunction();
              },
              buttonTitle: "Make Available",
              height: 40,
              colour: const Color(0xff056033),
              textStyleColor: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.white),
            )
          ],
        ),
      )));
}
