// To parse this JSON data, do
//
//     final clockInModel = clockInModelFromJson(jsonString);

import 'dart:convert';

ClockInModel clockInModelFromJson(String str) =>
    ClockInModel.fromJson(json.decode(str));

String clockInModelToJson(ClockInModel data) => json.encode(data.toJson());

class ClockInModel {
  DateTime? clockedIn;

  ClockInModel({
    this.clockedIn,
  });

  factory ClockInModel.fromJson(Map<String, dynamic> json) => ClockInModel(
        clockedIn: json["clockedIn"] == null
            ? null
            : DateTime.parse(json["clockedIn"]),
      );

  Map<String, dynamic> toJson() => {
        "clockedIn": clockedIn?.toIso8601String(),
      };
}

ClockOutModel clockOutModelFromJson(String str) =>
    ClockOutModel.fromJson(json.decode(str));

String clockOutModelToJson(ClockOutModel data) => json.encode(data.toJson());

class ClockOutModel {
  DateTime? clockedOut;

  ClockOutModel({
    this.clockedOut,
  });

  factory ClockOutModel.fromJson(Map<String, dynamic> json) => ClockOutModel(
        clockedOut: json["clockedOut"] == null
            ? null
            : DateTime.parse(json["clockedOut"]),
      );

  Map<String, dynamic> toJson() => {
        "clockedOut": clockedOut?.toIso8601String(),
      };
}
