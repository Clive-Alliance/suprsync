class OffDaySchedule {
  List<UnavailableDay>? unavailableDays;
  List<TimeOff>? timeOff;
  Month? month;

  OffDaySchedule({
    this.unavailableDays,
    this.timeOff,
    this.month,
  });

  factory OffDaySchedule.fromJson(Map<String, dynamic> json) => OffDaySchedule(
    unavailableDays: json["unavailableDays"] == null ? [] : List<UnavailableDay>.from(json["unavailableDays"]!.map((x) => UnavailableDay.fromJson(x))),
    timeOff: json["timeOff"] == null ? [] : List<TimeOff>.from(json["timeOff"]!.map((x) => TimeOff.fromJson(x))),
    month: json["month"] == null ? null : Month.fromJson(json["month"]),
  );

  Map<String, dynamic> toJson() => {
    "unavailableDays": unavailableDays == null ? [] : List<dynamic>.from(unavailableDays!.map((x) => x.toJson())),
    "timeOff": timeOff == null ? [] : List<dynamic>.from(timeOff!.map((x) => x.toJson())),
    "month": month?.toJson(),
  };
}

class Month {
  DateTime? start;
  DateTime? end;
  int? year;
  int? month;

  Month({
    this.start,
    this.end,
    this.year,
    this.month,
  });

  factory Month.fromJson(Map<String, dynamic> json) => Month(
    start: json["start"] == null ? null : DateTime.parse(json["start"]),
    end: json["end"] == null ? null : DateTime.parse(json["end"]),
    year: json["year"],
    month: json["month"],
  );

  Map<String, dynamic> toJson() => {
    "start": "${start!.year.toString().padLeft(4, '0')}-${start!.month.toString().padLeft(2, '0')}-${start!.day.toString().padLeft(2, '0')}",
    "end": "${end!.year.toString().padLeft(4, '0')}-${end!.month.toString().padLeft(2, '0')}-${end!.day.toString().padLeft(2, '0')}",
    "year": year,
    "month": month,
  };
}

class TimeOff {
  String? id;
  DateTime? start;
  DateTime? end;
  String? reason;
  String? status;
  String? vacationType;
  DateTime? createdOn;
  Admin? requester;
  Admin? admin;

  TimeOff({
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

  factory TimeOff.fromJson(Map<String, dynamic> json) => TimeOff(
    id: json["id"],
    start: json["start"] == null ? null : DateTime.parse(json["start"]),
    end: json["end"] == null ? null : DateTime.parse(json["end"]),
    reason: json["reason"],
    status: json["status"],
    vacationType: json["vacationType"],
    createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
    requester: json["requester"] == null ? null : Admin.fromJson(json["requester"]),
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

class UnavailableDay {
  String? id;
  String? userId;
  String? companyId;
  String? teamMembershipId;
  String? branchId;
  DateTime? blockedDays;

  UnavailableDay({
    this.id,
    this.userId,
    this.companyId,
    this.teamMembershipId,
    this.branchId,
    this.blockedDays,
  });

  factory UnavailableDay.fromJson(Map<String, dynamic> json) => UnavailableDay(
    id: json["id"],
    userId: json["userId"],
    companyId: json["companyId"],
    teamMembershipId: json["teamMembershipId"],
    branchId: json["branchId"],
    blockedDays: json["blocked_days"] == null ? null : DateTime.parse(json["blocked_days"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "companyId": companyId,
    "teamMembershipId": teamMembershipId,
    "branchId": branchId,
    "blocked_days": "${blockedDays!.year.toString().padLeft(4, '0')}-${blockedDays!.month.toString().padLeft(2, '0')}-${blockedDays!.day.toString().padLeft(2, '0')}",
  };
}
