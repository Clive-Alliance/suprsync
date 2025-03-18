// To parse this JSON data, do
//
//     final shiftsModel = shiftsModelFromJson(jsonString);

import 'dart:convert';

List<ShiftsModel> shiftsModelFromJson(String str) => List<ShiftsModel>.from(
    json.decode(str).map((x) => ShiftsModel.fromJson(x)));

String shiftsModelToJson(List<ShiftsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ShiftsModel {
  String? id;
  DateTime? start;
  DateTime? end;
  dynamic clockedIn;
  dynamic clockedOut;
  String? status;
  bool? swappable;
  dynamic clockedInLatitude;
  dynamic clockedInLongitude;
  String? branchId;
  String? companyId;
  String? userId;
  String? slotId;
  dynamic calendarsSynced;
  dynamic fillInRole;
  dynamic templateId;
  DateTime? createdOn;
  Slot? slot;
  User? user;
  dynamic template;
  dynamic jobrole;
  Availability? availability;
  JobRole? slotjobRole;
  dynamic jobGroup;
  int? totalPages;
  int? totalRecords;

  ShiftsModel({
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
    this.fillInRole,
    this.templateId,
    this.createdOn,
    this.slot,
    this.user,
    this.template,
    this.jobrole,
    this.availability,
    this.slotjobRole,
    this.jobGroup,
    this.totalPages,
    this.totalRecords,
  });

  factory ShiftsModel.fromJson(Map<String, dynamic> json) => ShiftsModel(
        id: json["id"],
        start: json["start"] == null ? null : DateTime.parse(json["start"]),
        end: json["end"] == null ? null : DateTime.parse(json["end"]),
        clockedIn: json["clockedIn"],
        clockedOut: json["clockedOut"],
        status: json["status"],
        swappable: json["swappable"],
        clockedInLatitude: json["clockedInLatitude"],
        clockedInLongitude: json["clockedInLongitude"],
        branchId: json["branchId"],
        companyId: json["companyId"],
        userId: json["userId"],
        slotId: json["slotId"],
        calendarsSynced: json["calendarsSynced"],
        fillInRole: json["fillInRole"],
        templateId: json["templateId"],
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
        slot: json["slot"] == null ? null : Slot.fromJson(json["slot"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        template: json["template"],
        jobrole: json["jobrole"],
        availability: json["availability"] == null
            ? null
            : Availability.fromJson(json["availability"]),
        slotjobRole: json["slotjobRole"] == null
            ? null
            : JobRole.fromJson(json["slotjobRole"]),
        jobGroup: json["jobGroup"],
        totalPages: json["totalPages"],
        totalRecords: json["totalRecords"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "start": start?.toIso8601String(),
        "end": end?.toIso8601String(),
        "clockedIn": clockedIn,
        "clockedOut": clockedOut,
        "status": status,
        "swappable": swappable,
        "clockedInLatitude": clockedInLatitude,
        "clockedInLongitude": clockedInLongitude,
        "branchId": branchId,
        "companyId": companyId,
        "userId": userId,
        "slotId": slotId,
        "calendarsSynced": calendarsSynced,
        "fillInRole": fillInRole,
        "templateId": templateId,
        "createdOn": createdOn?.toIso8601String(),
        "slot": slot?.toJson(),
        "user": user?.toJson(),
        "template": template,
        "jobrole": jobrole,
        "availability": availability?.toJson(),
        "slotjobRole": slotjobRole?.toJson(),
        "jobGroup": jobGroup,
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

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  dynamic picture;
  List<UserSkillSet>? userSkillSets;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.picture,
    this.userSkillSets,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        gender: json["gender"],
        picture: json["picture"],
        userSkillSets: json["userSkillSets"] == null
            ? []
            : List<UserSkillSet>.from(
                json["userSkillSets"]!.map((x) => UserSkillSet.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "gender": gender,
        "picture": picture,
        "userSkillSets": userSkillSets == null
            ? []
            : List<dynamic>.from(userSkillSets!.map((x) => x.toJson())),
      };
}

class UserSkillSet {
  String? id;
  bool? verified;
  String? userId;
  String? skillSetId;
  dynamic companyId;
  DateTime? dateAdded;

  UserSkillSet({
    this.id,
    this.verified,
    this.userId,
    this.skillSetId,
    this.companyId,
    this.dateAdded,
  });

  factory UserSkillSet.fromJson(Map<String, dynamic> json) => UserSkillSet(
        id: json["id"],
        verified: json["verified"],
        userId: json["userId"],
        skillSetId: json["skillSetId"],
        companyId: json["companyId"],
        dateAdded: json["dateAdded"] == null
            ? null
            : DateTime.parse(json["dateAdded"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "verified": verified,
        "userId": userId,
        "skillSetId": skillSetId,
        "companyId": companyId,
        "dateAdded": dateAdded?.toIso8601String(),
      };
}
