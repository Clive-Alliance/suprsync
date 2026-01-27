class EventSchedule {
  String? id;
  DateTime? start;
  DateTime? end;
  bool? clockedIn;
  bool? clockedOut;
  String? status;
  bool? swappable;
  String? clockedInLatitude;
  String? clockedInLongitude;
  String? branchId;
  String? companyId;
  String? userId;
  String? slotId;
  bool? calendarsSynced;
  String? fillInRole;
  String? templateId;
  String? shiftName;
  String? shiftColor;
  int? isPublished;
  int? openShift;
  int? isOncall;
  int? unpaidBreak;
  String? writeUp;
  String? breakStartTime;
  String? breakEndTime;
  int? totalBreakTime;
  int? breakCount;
  int? isOnBreak;
  String? breakHistory;
  DateTime? createdOn;
  Slot? slot;
  User? user;
  String? template;
  String? jobrole;
  Availability? availability;
  SlotjobRole? slotjobRole;
  String? jobGroup;

  EventSchedule({
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
    this.shiftName,
    this.shiftColor,
    this.isPublished,
    this.openShift,
    this.isOncall,
    this.unpaidBreak,
    this.writeUp,
    this.breakStartTime,
    this.breakEndTime,
    this.totalBreakTime,
    this.breakCount,
    this.isOnBreak,
    this.breakHistory,
    this.createdOn,
    this.slot,
    this.user,
    this.template,
    this.jobrole,
    this.availability,
    this.slotjobRole,
    this.jobGroup,
  });

  factory EventSchedule.fromJson(Map<String, dynamic> json) => EventSchedule(
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
    shiftName: json["shiftName"],
    shiftColor: json["shiftColor"],
    isPublished: json["isPublished"],
    openShift: json["OpenShift"],
    isOncall: json["isOncall"],
    unpaidBreak: json["unpaidBreak"],
    writeUp: json["writeUp"],
    breakStartTime: json["breakStartTime"],
    breakEndTime: json["breakEndTime"],
    totalBreakTime: json["totalBreakTime"],
    breakCount: json["breakCount"],
    isOnBreak: json["isOnBreak"],
    breakHistory: json["breakHistory"],
    createdOn: json["createdOn"] == null ? null : DateTime.parse(json["createdOn"]),
    slot: json["slot"] == null ? null : Slot.fromJson(json["slot"]),
    user: json["user"] == null ? null : User.fromJson(json["user"]),
    template: json["template"],
    jobrole: json["jobrole"],
    availability: json["availability"] == null ? null : Availability.fromJson(json["availability"]),
    slotjobRole: json["slotjobRole"] == null ? null : SlotjobRole.fromJson(json["slotjobRole"]),
    jobGroup: json["jobGroup"],
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
    "shiftName": shiftName,
    "shiftColor": shiftColor,
    "isPublished": isPublished,
    "OpenShift": openShift,
    "isOncall": isOncall,
    "unpaidBreak": unpaidBreak,
    "writeUp": writeUp,
    "breakStartTime": breakStartTime,
    "breakEndTime": breakEndTime,
    "totalBreakTime": totalBreakTime,
    "breakCount": breakCount,
    "isOnBreak": isOnBreak,
    "breakHistory": breakHistory,
    "createdOn": createdOn?.toIso8601String(),
    "slot": slot?.toJson(),
    "user": user?.toJson(),
    "template": template,
    "jobrole": jobrole,
    "availability": availability?.toJson(),
    "slotjobRole": slotjobRole?.toJson(),
    "jobGroup": jobGroup,
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
  SlotjobRole? branch;
  SlotjobRole? jobRole;

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
    branch: json["branch"] == null ? null : SlotjobRole.fromJson(json["branch"]),
    jobRole: json["jobRole"] == null ? null : SlotjobRole.fromJson(json["jobRole"]),
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

class SlotjobRole {
  String? id;
  String? name;
  String? hexcode;
  String? symbol;
  String? title;

  SlotjobRole({
    this.id,
    this.name,
    this.hexcode,
    this.symbol,
    this.title,
  });

  factory SlotjobRole.fromJson(Map<String, dynamic> json) => SlotjobRole(
    id: json["id"],
    name: json["name"],
    hexcode: json["hexcode"],
    symbol: json["symbol"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "hexcode": hexcode,
    "symbol": symbol,
    "title": title,
  };
}

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  dynamic gender;
  dynamic picture;
  List<dynamic>? userSkillSets;

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
    userSkillSets: json["userSkillSets"] == null ? [] : List<dynamic>.from(json["userSkillSets"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "firstName": firstName,
    "lastName": lastName,
    "email": email,
    "gender": gender,
    "picture": picture,
    "userSkillSets": userSkillSets == null ? [] : List<dynamic>.from(userSkillSets!.map((x) => x)),
  };
}
