// To parse this JSON data, do
//
//     final checkInScheduleModel = checkInScheduleModelFromJson(jsonString);

import 'dart:convert';

List<CheckInScheduleModel> checkInScheduleModelFromJson(String str) =>
    List<CheckInScheduleModel>.from(
        json.decode(str).map((x) => CheckInScheduleModel.fromJson(x)));

String checkInScheduleModelToJson(List<CheckInScheduleModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CheckInScheduleModel {
  String? id;
  DateTime? start;
  DateTime? end;
  DateTime? clockedIn;
  dynamic clockedOut;
  String? status;
  bool? swappable;
  String? clockedInLatitude;
  String? clockedInLongitude;
  String? branchId;
  String? companyId;
  String? userId;
  String? slotId;
  List<String>? calendarsSynced;
  DateTime? createdOn;
  Slot? slot;
  User? user;
  Availability? availability;
  JobRole? jobRole;
  JobGroup? jobGroup;
  List<dynamic>? skillset;
  int? totalPages;
  int? totalRecords;

  CheckInScheduleModel({
    this.id,
    this.start,
    this.end,
    this.clockedIn,
    this.clockedOut,
    this.status,
    this.swappable,
    this.clockedInLatitude,
    this.clockedInLongitude,
    this.branchId,
    this.companyId,
    this.userId,
    this.slotId,
    this.calendarsSynced,
    this.createdOn,
    this.slot,
    this.user,
    this.availability,
    this.jobRole,
    this.jobGroup,
    this.skillset,
    this.totalPages,
    this.totalRecords,
  });

  factory CheckInScheduleModel.fromJson(Map<String, dynamic> json) =>
      CheckInScheduleModel(
        id: json["id"],
        start: json["start"] == null ? null : DateTime.parse(json["start"]),
        end: json["end"] == null ? null : DateTime.parse(json["end"]),
        clockedIn: json["clockedIn"] == null
            ? null
            : DateTime.parse(json["clockedIn"]),
        clockedOut: json["clockedOut"],
        status: json["status"],
        swappable: json["swappable"],
        clockedInLatitude: json["clockedInLatitude"],
        clockedInLongitude: json["clockedInLongitude"],
        branchId: json["branchId"],
        companyId: json["companyId"],
        userId: json["userId"],
        slotId: json["slotId"],
        calendarsSynced: json["calendarsSynced"] == null
            ? []
            : List<String>.from(json["calendarsSynced"]!.map((x) => x)),
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
        slot: json["slot"] == null ? null : Slot.fromJson(json["slot"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        availability: json["availability"] == null
            ? null
            : Availability.fromJson(json["availability"]),
        jobRole:
            json["jobRole"] == null ? null : JobRole.fromJson(json["jobRole"]),
        jobGroup: json["jobGroup"] == null
            ? null
            : JobGroup.fromJson(json["jobGroup"]),
        skillset: json["skillset"] == null
            ? []
            : List<dynamic>.from(json["skillset"]!.map((x) => x)),
        totalPages: json["totalPages"],
        totalRecords: json["totalRecords"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start": start?.toIso8601String(),
        "end": end?.toIso8601String(),
        "clockedIn": clockedIn?.toIso8601String(),
        "clockedOut": clockedOut,
        "status": status,
        "swappable": swappable,
        "clockedInLatitude": clockedInLatitude,
        "clockedInLongitude": clockedInLongitude,
        "branchId": branchId,
        "companyId": companyId,
        "userId": userId,
        "slotId": slotId,
        "calendarsSynced": calendarsSynced == null
            ? []
            : List<dynamic>.from(calendarsSynced!.map((x) => x)),
        "createdOn": createdOn?.toIso8601String(),
        "slot": slot?.toJson(),
        "user": user?.toJson(),
        "availability": availability?.toJson(),
        "jobRole": jobRole?.toJson(),
        "jobGroup": jobGroup?.toJson(),
        "skillset":
            skillset == null ? [] : List<dynamic>.from(skillset!.map((x) => x)),
        "totalPages": totalPages,
        "totalRecords": totalRecords,
      };
}

class Availability {
  int? maxStaffRequired;
  int? staffBooked;
  int? staffConfirmed;
  int? staffUnconfirmed;

  Availability({
    this.maxStaffRequired,
    this.staffBooked,
    this.staffConfirmed,
    this.staffUnconfirmed,
  });

  factory Availability.fromJson(Map<String, dynamic> json) => Availability(
        maxStaffRequired: json["maxStaffRequired"],
        staffBooked: json["staffBooked"],
        staffConfirmed: json["staffConfirmed"],
        staffUnconfirmed: json["staffUnconfirmed"],
      );

  Map<String, dynamic> toJson() => {
        "maxStaffRequired": maxStaffRequired,
        "staffBooked": staffBooked,
        "staffConfirmed": staffConfirmed,
        "staffUnconfirmed": staffUnconfirmed,
      };
}

class JobGroup {
  String? roleTagId;

  JobGroup({
    this.roleTagId,
  });

  factory JobGroup.fromJson(Map<String, dynamic> json) => JobGroup(
        roleTagId: json["roleTagId"],
      );

  Map<String, dynamic> toJson() => {
        "roleTagId": roleTagId,
      };
}

class JobRole {
  String? id;
  String? title;
  String? hexcode;
  String? symbol;

  JobRole({
    this.id,
    this.title,
    this.hexcode,
    this.symbol,
  });

  factory JobRole.fromJson(Map<String, dynamic> json) => JobRole(
        id: json["id"],
        title: json["title"],
        hexcode: json["hexcode"],
        symbol: json["symbol"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "hexcode": hexcode,
        "symbol": symbol,
      };
}

class Slot {
  String? id;
  String? startTime;
  String? endTime;
  int? maxStaffRequired;
  String? timeZone;
  Branch? branch;
  JobRole? jobRole;

  Slot({
    this.id,
    this.startTime,
    this.endTime,
    this.maxStaffRequired,
    this.timeZone,
    this.branch,
    this.jobRole,
  });

  factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        id: json["id"],
        startTime: json["startTime"],
        endTime: json["endTime"],
        maxStaffRequired: json["maxStaffRequired"],
        timeZone: json["timeZone"],
        branch: json["branch"] == null ? null : Branch.fromJson(json["branch"]),
        jobRole:
            json["jobRole"] == null ? null : JobRole.fromJson(json["jobRole"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "startTime": startTime,
        "endTime": endTime,
        "maxStaffRequired": maxStaffRequired,
        "timeZone": timeZone,
        "branch": branch?.toJson(),
        "jobRole": jobRole?.toJson(),
      };
}

class Branch {
  String? id;
  String? name;
  String? hexcode;
  String? symbol;

  Branch({
    this.id,
    this.name,
    this.hexcode,
    this.symbol,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        id: json["id"],
        name: json["name"],
        hexcode: json["hexcode"],
        symbol: json["symbol"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "hexcode": hexcode,
        "symbol": symbol,
      };
}

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  dynamic picture;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.picture,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        picture: json["picture"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "picture": picture,
      };
}
