// To parse this JSON data, do
//
//     final measurementUnitModel = measurementUnitModelFromJson(jsonString);

import 'dart:convert';

List<MeasurementUnitModel> measurementUnitModelFromJson(String str) =>
    List<MeasurementUnitModel>.from(
        json.decode(str).map((x) => MeasurementUnitModel.fromJson(x)));

String measurementUnitModelToJson(List<MeasurementUnitModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MeasurementUnitModel {
  String? id;
  String? name;
  String? description;
  String? symbol;
  DateTime? createdOn;

  MeasurementUnitModel({
    this.id,
    this.name,
    this.description,
    this.symbol,
    this.createdOn,
  });

  factory MeasurementUnitModel.fromJson(Map<String, dynamic> json) =>
      MeasurementUnitModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        symbol: json["symbol"],
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "symbol": symbol,
        "createdOn": createdOn?.toIso8601String(),
      };
}
