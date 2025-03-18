import 'dart:convert';

ForgotPasswordModel forgotPasswordModelFromJson(String str) =>
    ForgotPasswordModel.fromJson(json.decode(str));

String forgotPasswordModelToJson(ForgotPasswordModel data) =>
    json.encode(data.toJson());

class ForgotPasswordModel {
  ForgotPasswordModel({
    this.message,
  });

  String? message;

  factory ForgotPasswordModel.fromJson(Map<String, dynamic> json) =>
      ForgotPasswordModel(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
