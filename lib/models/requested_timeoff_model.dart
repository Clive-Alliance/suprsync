// To parse this JSON data, do
//
//     final requestedTimeoffModel = requestedTimeoffModelFromJson(jsonString);

import 'dart:convert';

List<RequestedTimeoffModel> requestedTimeoffModelFromJson(String str) =>
    List<RequestedTimeoffModel>.from(
        json.decode(str).map((x) => RequestedTimeoffModel.fromJson(x)));

String requestedTimeoffModelToJson(List<RequestedTimeoffModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RequestedTimeoffModel {
  String? id;
  DateTime? start;
  DateTime? end;
  String? reason;
  String? status;
  String? vacationType;
  DateTime? createdOn;
  Admin? requester;
  Admin? admin;

  RequestedTimeoffModel({
    this.id,
    this.start,
    this.end,
    this.reason,
    this.status,
    this.vacationType,
    this.createdOn,
    this.requester,
    this.admin,
  });

  factory RequestedTimeoffModel.fromJson(Map<String, dynamic> json) =>
      RequestedTimeoffModel(
        id: json["id"],
        start: json["start"] == null ? null : DateTime.parse(json["start"]),
        end: json["end"] == null ? null : DateTime.parse(json["end"]),
        reason: json["reason"],
        status: json["status"],
        vacationType: json["vacationType"],
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
        requester: json["requester"] == null
            ? null
            : Admin.fromJson(json["requester"]),
        admin: json["admin"] == null ? null : Admin.fromJson(json["admin"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start": start?.toIso8601String(),
        "end": end?.toIso8601String(),
        "reason": reason,
        "status": status,
        "vacationType": vacationType,
        "createdOn": createdOn?.toIso8601String(),
        "requester": requester?.toJson(),
        "admin": admin?.toJson(),
      };
}

class Admin {
  String? id;
  String? firstName;
  String? lastName;

  Admin({
    this.id,
    this.firstName,
    this.lastName,
  });

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
      };
}
