// To parse this JSON data, do
//
//     final requestTimeoffModel = requestTimeoffModelFromJson(jsonString);

import 'dart:convert';

RequestTimeoffModel requestTimeoffModelFromJson(String str) =>
    RequestTimeoffModel.fromJson(json.decode(str));

String requestTimeoffModelToJson(RequestTimeoffModel data) =>
    json.encode(data.toJson());

class RequestTimeoffModel {
  DateTime? start;
  DateTime? end;
  String? reason;
  String? status;
  String? vacationType;
  String? requesterId;
  String? companyId;
  dynamic adminId;
  String? id;
  DateTime? createdOn;

  RequestTimeoffModel({
    this.start,
    this.end,
    this.reason,
    this.status,
    this.vacationType,
    this.requesterId,
    this.companyId,
    this.adminId,
    this.id,
    this.createdOn,
  });

  factory RequestTimeoffModel.fromJson(Map<String, dynamic> json) =>
      RequestTimeoffModel(
        start: json["start"] == null ? null : DateTime.parse(json["start"]),
        end: json["end"] == null ? null : DateTime.parse(json["end"]),
        reason: json["reason"],
        status: json["status"],
        vacationType: json["vacationType"],
        requesterId: json["requesterId"],
        companyId: json["companyId"],
        adminId: json["adminId"],
        id: json["id"],
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
      );

  Map<String, dynamic> toJson() => {
        "start": start?.toIso8601String(),
        "end": end?.toIso8601String(),
        "reason": reason,
        "status": status,
        "vacationType": vacationType,
        "requesterId": requesterId,
        "companyId": companyId,
        "adminId": adminId,
        "id": id,
        "createdOn": createdOn?.toIso8601String(),
      };
}
