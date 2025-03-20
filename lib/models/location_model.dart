// To parse this JSON data, do
//
//     final locationModel = locationModelFromJson(jsonString);

import 'dart:convert';

List<LocationModel> locationModelFromJson(String str) =>
    List<LocationModel>.from(
        json.decode(str).map((x) => LocationModel.fromJson(x)));

String locationModelToJson(List<LocationModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LocationModel {
  String? id;
  String? name;
  String? address;
  String? zipCode;
  String? countryId;
  String? stateId;
  String? cityId;
  String? latitude;
  String? longitude;
  String? companyId;
  String? hexcode;
  String? symbol;
  DateTime? createdOn;
  City? city;
  State? state;
  int? memberCount;

  LocationModel({
    this.id,
    this.name,
    this.address,
    this.zipCode,
    this.countryId,
    this.stateId,
    this.cityId,
    this.latitude,
    this.longitude,
    this.companyId,
    this.hexcode,
    this.symbol,
    this.createdOn,
    this.city,
    this.state,
    this.memberCount,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        zipCode: json["zipCode"],
        countryId: json["countryId"],
        stateId: json["stateId"],
        cityId: json["cityId"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        companyId: json["companyId"],
        hexcode: json["hexcode"],
        symbol: json["symbol"],
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
        city: json["city"] == null ? null : City.fromJson(json["city"]),
        state: json["state"] == null ? null : State.fromJson(json["state"]),
        memberCount: json["memberCount"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "zipCode": zipCode,
        "countryId": countryId,
        "stateId": stateId,
        "cityId": cityId,
        "latitude": latitude,
        "longitude": longitude,
        "companyId": companyId,
        "hexcode": hexcode,
        "symbol": symbol,
        "createdOn": createdOn?.toIso8601String(),
        "city": city?.toJson(),
        "state": state?.toJson(),
        "memberCount": memberCount,
      };
}

class City {
  String? id;
  String? name;
  String? stateId;
  String? countryId;
  DateTime? createdOn;

  City({
    this.id,
    this.name,
    this.stateId,
    this.countryId,
    this.createdOn,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        name: json["name"],
        stateId: json["stateId"],
        countryId: json["countryId"],
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "stateId": stateId,
        "countryId": countryId,
        "createdOn": createdOn?.toIso8601String(),
      };
}

class State {
  String? id;
  String? name;
  String? code;
  String? countryId;
  DateTime? createdOn;

  State({
    this.id,
    this.name,
    this.code,
    this.countryId,
    this.createdOn,
  });

  factory State.fromJson(Map<String, dynamic> json) => State(
        id: json["id"],
        name: json["name"],
        code: json["code"],
        countryId: json["countryId"],
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "code": code,
        "countryId": countryId,
        "createdOn": createdOn?.toIso8601String(),
      };
}
