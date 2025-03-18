// To parse this JSON data, do
//
//     final unavailableDaysModel = unavailableDaysModelFromJson(jsonString);

import 'dart:convert';

UnavailableDaysModel unavailableDaysModelFromJson(String str) =>
    UnavailableDaysModel.fromJson(json.decode(str));

String unavailableDaysModelToJson(UnavailableDaysModel data) =>
    json.encode(data.toJson());

class UnavailableDaysModel {
  List<UnavailableDay>? unavailableDays;
  List<Membership>? memberships;

  UnavailableDaysModel({
    this.unavailableDays,
    this.memberships,
  });

  factory UnavailableDaysModel.fromJson(Map<String, dynamic> json) =>
      UnavailableDaysModel(
        unavailableDays: json["unavailableDays"] == null
            ? []
            : List<UnavailableDay>.from(json["unavailableDays"]!
                .map((x) => UnavailableDay.fromJson(x))),
        memberships: json["memberships"] == null
            ? []
            : List<Membership>.from(
                json["memberships"]!.map((x) => Membership.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "unavailableDays": unavailableDays == null
            ? []
            : List<dynamic>.from(unavailableDays!.map((x) => x.toJson())),
        "memberships": memberships == null
            ? []
            : List<dynamic>.from(memberships!.map((x) => x.toJson())),
      };
}

class Membership {
  String? id;
  String? jobrole;
  String? hexcode;

  Membership({
    this.id,
    this.jobrole,
    this.hexcode,
  });

  factory Membership.fromJson(Map<String, dynamic> json) => Membership(
        id: json["id"],
        jobrole: json["jobrole"],
        hexcode: json["hexcode"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "jobrole": jobrole,
        "hexcode": hexcode,
      };
}

class UnavailableDay {
  String? id;
  String? userId;
  String? companyId;
  String? teamMembershipId;
  String? branchId;
  DateTime? blockedDays;
  User? user;

  UnavailableDay({
    this.id,
    this.userId,
    this.companyId,
    this.teamMembershipId,
    this.branchId,
    this.blockedDays,
    this.user,
  });

  factory UnavailableDay.fromJson(Map<String, dynamic> json) => UnavailableDay(
        id: json["id"],
        userId: json["userId"],
        companyId: json["companyId"],
        teamMembershipId: json["teamMembershipId"],
        branchId: json["branchId"],
        blockedDays: json["blocked_days"] == null
            ? null
            : DateTime.parse(json["blocked_days"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "companyId": companyId,
        "teamMembershipId": teamMembershipId,
        "branchId": branchId,
        "blocked_days":
            "${blockedDays!.year.toString().padLeft(4, '0')}-${blockedDays!.month.toString().padLeft(2, '0')}-${blockedDays!.day.toString().padLeft(2, '0')}",
        "user": user?.toJson(),
      };
}

class User {
  String? firstName;
  String? lastName;

  User({
    this.firstName,
    this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstName: json["firstName"],
        lastName: json["lastName"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
      };
}
