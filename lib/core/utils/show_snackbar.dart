import 'package:flutter/material.dart';
import 'package:get/get.dart';

showSnackBar(String message) {
  Get.snackbar(
    message, // Snackbar title
    '',
    snackPosition: SnackPosition.TOP,
    messageText: const SizedBox(),
    // padding: EdgeInsets.all(8),
// Position of the snackbar
    borderWidth: 1,
    duration: const Duration(seconds: 1),
    borderRadius: 20,
    borderColor: const Color(0xffE4F4EF),
    backgroundColor: Color(0xffEBFFF5), // Background color of the snackbar
    colorText: const Color(0xff056033), // Text color of the snackbar
  );
  print('snackbar message $message');
}
