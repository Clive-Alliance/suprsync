import 'package:flutter/material.dart';

void showMessage(message, context) {
  print('called here $message');

  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.black,
    duration: const Duration(seconds: 1),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
