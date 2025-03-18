// To parse this JSON data, do
//
//     final errorModel = errorModelFromJson(jsonString);

import 'dart:convert';

ErrorModel errorModelFromJson(String str) =>
    ErrorModel.fromJson(json.decode(str));

String errorModelToJson(ErrorModel data) => json.encode(data.toJson());

class ErrorModel {
  String? message;

  ErrorModel({
    this.message,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) => ErrorModel(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}

// To parse this JSON data, do
//
//     final errorModel2 = errorModel2FromJson(jsonString);

ErrorModel2 errorModel2FromJson(String str) =>
    ErrorModel2.fromJson(json.decode(str));

String errorModel2ToJson(ErrorModel2 data) => json.encode(data.toJson());

class ErrorModel2 {
  int? code;
  Body? body;

  ErrorModel2({
    this.code,
    this.body,
  });

  factory ErrorModel2.fromJson(Map<String, dynamic> json) => ErrorModel2(
        code: json["code"],
        body: json["body"] == null ? null : Body.fromJson(json["body"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "body": body?.toJson(),
      };
}

class Body {
  String? message;

  Body({
    this.message,
  });

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}
