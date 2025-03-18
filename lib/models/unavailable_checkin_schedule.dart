// To parse this JSON data, do
//
//     final unavilableCheckInScheduleModel = unavilableCheckInScheduleModelFromJson(jsonString);

import 'dart:convert';

List<UnavilableCheckInScheduleModel> unavilableCheckInScheduleModelFromJson(
        String str) =>
    List<UnavilableCheckInScheduleModel>.from(json
        .decode(str)
        .map((x) => UnavilableCheckInScheduleModel.fromJson(x)));

String unavilableCheckInScheduleModelToJson(
        List<UnavilableCheckInScheduleModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UnavilableCheckInScheduleModel {
  int? totalPages;
  int? totalRecords;

  UnavilableCheckInScheduleModel({
    this.totalPages,
    this.totalRecords,
  });

  factory UnavilableCheckInScheduleModel.fromJson(Map<String, dynamic> json) =>
      UnavilableCheckInScheduleModel(
        totalPages: json["totalPages"],
        totalRecords: json["totalRecords"],
      );

  Map<String, dynamic> toJson() => {
        "totalPages": totalPages,
        "totalRecords": totalRecords,
      };
}
