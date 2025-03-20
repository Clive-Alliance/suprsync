// To parse this JSON data, do
//
//     final transferRequestModel = transferRequestModelFromJson(jsonString);

import 'dart:convert';

List<TransferRequestModel> transferRequestModelFromJson(String str) =>
    List<TransferRequestModel>.from(
        json.decode(str).map((x) => TransferRequestModel.fromJson(x)));

String transferRequestModelToJson(List<TransferRequestModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransferRequestModel {
  String? batchIdentifier;
  Location? fromLocation;
  Location? toLocation;
  List<Item>? items;

  TransferRequestModel({
    this.batchIdentifier,
    this.fromLocation,
    this.toLocation,
    this.items,
  });

  factory TransferRequestModel.fromJson(Map<String, dynamic> json) =>
      TransferRequestModel(
        batchIdentifier: json["batchIdentifier"],
        fromLocation: json["fromLocation"] == null
            ? null
            : Location.fromJson(json["fromLocation"]),
        toLocation: json["toLocation"] == null
            ? null
            : Location.fromJson(json["toLocation"]),
        items: json["items"] == null
            ? []
            : List<Item>.from(json["items"]!.map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "batchIdentifier": batchIdentifier,
        "fromLocation": fromLocation?.toJson(),
        "toLocation": toLocation?.toJson(),
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Location {
  String? locationId;
  String? locationName;
  String? hexcode;
  String? address;

  Location({
    this.locationId,
    this.locationName,
    this.hexcode,
    this.address,
  });

  factory Location.fromJson(Map<String, dynamic> json) => Location(
        locationId: json["locationId"],
        locationName: json["locationName"],
        hexcode: json["hexcode"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "locationId": locationId,
        "locationName": locationName,
        "hexcode": hexcode,
        "address": address,
      };
}

class Item {
  String? id;
  String? referenceNumber;
  String? name;
  String? status;
  DateTime? createdOn;
  int? quantityWithdrawn;
  String? itemId;
  String? batchIdentifier;

  Item({
    this.id,
    this.referenceNumber,
    this.name,
    this.status,
    this.createdOn,
    this.quantityWithdrawn,
    this.itemId,
    this.batchIdentifier,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["id"],
        referenceNumber: json["referenceNumber"],
        name: json["name"],
        status: json["status"],
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
        quantityWithdrawn: json["quantityWithdrawn"],
        itemId: json["itemId"],
        batchIdentifier: json["batchIdentifier"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "referenceNumber": referenceNumber,
        "name": name,
        "status": status,
        "createdOn": createdOn?.toIso8601String(),
        "quantityWithdrawn": quantityWithdrawn,
        "itemId": itemId,
        "batchIdentifier": batchIdentifier,
      };
}
