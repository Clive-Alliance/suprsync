// To parse this JSON data, do
//
//     final signInUserModel = signInUserModelFromJson(jsonString);

import 'dart:convert';

SignInUserModel signInUserModelFromJson(String str) =>
    SignInUserModel.fromJson(json.decode(str));

String signInUserModelToJson(SignInUserModel data) =>
    json.encode(data.toJson());

class SignInUserModel {
  String? accessToken;
  ActiveCompany? activeCompany;
  User? user;
  List<Company>? companies;

  SignInUserModel({
    this.accessToken,
    this.activeCompany,
    this.user,
    this.companies,
  });

  factory SignInUserModel.fromJson(Map<String, dynamic> json) =>
      SignInUserModel(
        accessToken: json["accessToken"],
        activeCompany: json["activeCompany"] == null
            ? null
            : ActiveCompany.fromJson(json["activeCompany"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        companies: json["companies"] == null
            ? []
            : List<Company>.from(
                json["companies"]!.map((x) => Company.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "activeCompany": activeCompany?.toJson(),
        "user": user?.toJson(),
        "companies": companies == null
            ? []
            : List<dynamic>.from(companies!.map((x) => x.toJson())),
      };
}

class ActiveCompany {
  String? id;
  String? name;
  String? writeUp;
  String? ein;
  String? teamSize;
  String? zipCode;
  String? address;
  String? ownerId;
  String? countryId;
  String? stateId;
  String? cityId;
  String? categoryId;
  DateTime? createdOn;
  Category? city;
  Category? state;
  Category? country;
  Logo? logo;
  Category? category;
  List<Membership>? memberships;

  ActiveCompany({
    this.id,
    this.name,
    this.writeUp,
    this.ein,
    this.teamSize,
    this.zipCode,
    this.address,
    this.ownerId,
    this.countryId,
    this.stateId,
    this.cityId,
    this.categoryId,
    this.createdOn,
    this.city,
    this.state,
    this.country,
    this.logo,
    this.category,
    this.memberships,
  });

  factory ActiveCompany.fromJson(Map<String, dynamic> json) => ActiveCompany(
        id: json["id"],
        name: json["name"],
        writeUp: json["writeUp"],
        ein: json["ein"],
        teamSize: json["teamSize"],
        zipCode: json["zipCode"],
        address: json["address"],
        ownerId: json["ownerId"],
        countryId: json["countryId"],
        stateId: json["stateId"],
        cityId: json["cityId"],
        categoryId: json["categoryId"],
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
        city: json["city"] == null ? null : Category.fromJson(json["city"]),
        state: json["state"] == null ? null : Category.fromJson(json["state"]),
        country:
            json["country"] == null ? null : Category.fromJson(json["country"]),
        logo: json["logo"] == null ? null : Logo.fromJson(json["logo"]),
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        memberships: json["memberships"] == null
            ? []
            : List<Membership>.from(
                json["memberships"]!.map((x) => Membership.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "writeUp": writeUp,
        "ein": ein,
        "teamSize": teamSize,
        "zipCode": zipCode,
        "address": address,
        "ownerId": ownerId,
        "countryId": countryId,
        "stateId": stateId,
        "cityId": cityId,
        "categoryId": categoryId,
        "createdOn": createdOn?.toIso8601String(),
        "city": city?.toJson(),
        "state": state?.toJson(),
        "country": country?.toJson(),
        "logo": logo?.toJson(),
        "category": category?.toJson(),
        "memberships": memberships == null
            ? []
            : List<dynamic>.from(memberships!.map((x) => x.toJson())),
      };
}

class Category {
  String? id;
  String? name;

  Category({
    this.id,
    this.name,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Logo {
  String? url;

  Logo({
    this.url,
  });

  factory Logo.fromJson(Map<String, dynamic> json) => Logo(
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
      };
}

class Membership {
  String? id;
  String? title;
  int? privilege;
  String? assignedBranchId;
  String? userId;
  String? companyId;
  dynamic jobRoleId;
  DateTime? createdOn;

  Membership({
    this.id,
    this.title,
    this.privilege,
    this.assignedBranchId,
    this.userId,
    this.companyId,
    this.jobRoleId,
    this.createdOn,
  });

  factory Membership.fromJson(Map<String, dynamic> json) => Membership(
        id: json["id"],
        title: json["title"],
        privilege: json["privilege"],
        assignedBranchId: json["assignedBranchId"],
        userId: json["userId"],
        companyId: json["companyId"],
        jobRoleId: json["jobRoleId"],
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "privilege": privilege,
        "assignedBranchId": assignedBranchId,
        "userId": userId,
        "companyId": companyId,
        "jobRoleId": jobRoleId,
        "createdOn": createdOn?.toIso8601String(),
      };
}

class Company {
  String? name;
  String? id;
  int? privilege;

  Company({
    this.name,
    this.id,
    this.privilege,
  });

  factory Company.fromJson(Map<String, dynamic> json) => Company(
        name: json["name"],
        id: json["id"],
        privilege: json["privilege"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "id": id,
        "privilege": privilege,
      };
}

class User {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  bool? emailVerified;
  String? phone;
  String? gender;
  DateTime? createdOn;
  Picture? picture;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.emailVerified,
    this.phone,
    this.gender,
    this.createdOn,
    this.picture,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        emailVerified: json["emailVerified"],
        phone: json["phone"],
        gender: json["gender"],
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
        picture:
            json["picture"] == null ? null : Picture.fromJson(json["picture"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "emailVerified": emailVerified,
        "phone": phone,
        "gender": gender,
        "createdOn": createdOn?.toIso8601String(),
        "picture": picture?.toJson(),
      };
}

class Picture {
  String? url;

  Picture({
    this.url,
  });

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
        url: json["url"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "url": url,
      };
}
