// To parse this JSON data, do
//
//     final swapShiftModel = swapShiftModelFromJson(jsonString);

import 'dart:convert';

SwapShiftModel swapShiftModelFromJson(String str) =>
    SwapShiftModel.fromJson(json.decode(str));

String swapShiftModelToJson(SwapShiftModel data) => json.encode(data.toJson());

class SwapShiftModel {
  String? message;

  SwapShiftModel({
    this.message,
  });

  factory SwapShiftModel.fromJson(Map<String, dynamic> json) => SwapShiftModel(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
