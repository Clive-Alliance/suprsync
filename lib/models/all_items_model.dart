// To parse this JSON data, do
//
//     final allItemsModel = allItemsModelFromJson(jsonString);

import 'dart:convert';

List<AllItemsModel> allItemsModelFromJson(String str) =>
    List<AllItemsModel>.from(
        json.decode(str).map((x) => AllItemsModel.fromJson(x)));

String allItemsModelToJson(List<AllItemsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllItemsModel {
  String? id;
  String? name;
  String? description;
  String? vendorDescription;
  int? packageCost;
  String? referenceNumber;
  String? groupId;
  String? companyId;
  String? status;
  String? inventoryManufacturerId;
  DateTime? createdOn;
  Group? group;
  List<ManAndSupp>? manAndSupp;
  List<ReorderItem>? reorderItems;
  InventoryManufacturer? inventoryManufacturer;
  List<Metadatum>? metadata;

  AllItemsModel({
    this.id,
    this.name,
    this.description,
    this.vendorDescription,
    this.packageCost,
    this.referenceNumber,
    this.groupId,
    this.companyId,
    this.status,
    this.inventoryManufacturerId,
    this.createdOn,
    this.group,
    this.manAndSupp,
    this.reorderItems,
    this.inventoryManufacturer,
    this.metadata,
  });

  factory AllItemsModel.fromJson(Map<String, dynamic> json) => AllItemsModel(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        vendorDescription: json["vendorDescription"],
        packageCost: json["packageCost"],
        referenceNumber: json["referenceNumber"],
        groupId: json["groupId"],
        companyId: json["companyId"],
        status: json["status"],
        inventoryManufacturerId: json["inventoryManufacturerId"],
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
        group: json["group"] == null ? null : Group.fromJson(json["group"]),
        manAndSupp: json["manAndSupp"] == null
            ? []
            : List<ManAndSupp>.from(
                json["manAndSupp"]!.map((x) => ManAndSupp.fromJson(x))),
        reorderItems: json["reorderItems"] == null
            ? []
            : List<ReorderItem>.from(
                json["reorderItems"]!.map((x) => ReorderItem.fromJson(x))),
        inventoryManufacturer: json["inventoryManufacturer"] == null
            ? null
            : InventoryManufacturer.fromJson(json["inventoryManufacturer"]),
        metadata: json["metadata"] == null
            ? []
            : List<Metadatum>.from(
                json["metadata"]!.map((x) => Metadatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "vendorDescription": vendorDescription,
        "packageCost": packageCost,
        "referenceNumber": referenceNumber,
        "groupId": groupId,
        "companyId": companyId,
        "status": status,
        "inventoryManufacturerId": inventoryManufacturerId,
        "createdOn": createdOn?.toIso8601String(),
        "group": group?.toJson(),
        "manAndSupp": manAndSupp == null
            ? []
            : List<dynamic>.from(manAndSupp!.map((x) => x.toJson())),
        "reorderItems": reorderItems == null
            ? []
            : List<dynamic>.from(reorderItems!.map((x) => x.toJson())),
        "inventoryManufacturer": inventoryManufacturer?.toJson(),
        "metadata": metadata == null
            ? []
            : List<dynamic>.from(metadata!.map((x) => x.toJson())),
      };
}

class Group {
  String? id;
  String? name;
  String? slug;
  String? description;
  String? companyId;
  String? hexcode;
  DateTime? createdOn;

  Group({
    this.id,
    this.name,
    this.slug,
    this.description,
    this.companyId,
    this.hexcode,
    this.createdOn,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        description: json["description"],
        companyId: json["companyId"],
        hexcode: json["hexcode"],
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "description": description,
        "companyId": companyId,
        "hexcode": hexcode,
        "createdOn": createdOn?.toIso8601String(),
      };
}

class InventoryManufacturer {
  String? id;
  String? name;
  String? description;
  String? phone;
  String? website;
  String? companyId;
  String? cityId;
  String? stateId;
  String? countryId;
  String? contactInfo;
  String? extraContact;
  DateTime? createdOn;
  DateTime? updatedOn;

  InventoryManufacturer({
    this.id,
    this.name,
    this.description,
    this.phone,
    this.website,
    this.companyId,
    this.cityId,
    this.stateId,
    this.countryId,
    this.contactInfo,
    this.extraContact,
    this.createdOn,
    this.updatedOn,
  });

  factory InventoryManufacturer.fromJson(Map<String, dynamic> json) =>
      InventoryManufacturer(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        phone: json["phone"],
        website: json["website"],
        companyId: json["companyId"],
        cityId: json["cityId"],
        stateId: json["stateId"],
        countryId: json["countryId"],
        contactInfo: json["contactInfo"],
        extraContact: json["extraContact"],
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
        updatedOn: json["updatedOn"] == null
            ? null
            : DateTime.parse(json["updatedOn"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "phone": phone,
        "website": website,
        "companyId": companyId,
        "cityId": cityId,
        "stateId": stateId,
        "countryId": countryId,
        "contactInfo": contactInfo,
        "extraContact": extraContact,
        "createdOn": createdOn?.toIso8601String(),
        "updatedOn": updatedOn?.toIso8601String(),
      };
}

class ManAndSupp {
  String? id;
  String? supplierId;
  String? manufacturerId;
  String? manufacturingNumber;
  String? packageDescId;
  int? itemsPkg;
  int? manufacturerPkgCost;
  String? inventoryItemsId;
  DateTime? createdOn;
  PackageDesc? packageDesc;

  ManAndSupp({
    this.id,
    this.supplierId,
    this.manufacturerId,
    this.manufacturingNumber,
    this.packageDescId,
    this.itemsPkg,
    this.manufacturerPkgCost,
    this.inventoryItemsId,
    this.createdOn,
    this.packageDesc,
  });

  factory ManAndSupp.fromJson(Map<String, dynamic> json) => ManAndSupp(
        id: json["id"],
        supplierId: json["supplierId"],
        manufacturerId: json["manufacturerId"],
        manufacturingNumber: json["manufacturingNumber"],
        packageDescId: json["packageDescId"],
        itemsPkg: json["itemsPkg"],
        manufacturerPkgCost: json["manufacturerPkgCost"],
        inventoryItemsId: json["inventoryItemsId"],
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
        packageDesc: json["packageDesc"] == null
            ? null
            : PackageDesc.fromJson(json["packageDesc"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "supplierId": supplierId,
        "manufacturerId": manufacturerId,
        "manufacturingNumber": manufacturingNumber,
        "packageDescId": packageDescId,
        "itemsPkg": itemsPkg,
        "manufacturerPkgCost": manufacturerPkgCost,
        "inventoryItemsId": inventoryItemsId,
        "createdOn": createdOn?.toIso8601String(),
        "packageDesc": packageDesc?.toJson(),
      };
}

class PackageDesc {
  String? id;
  String? name;
  String? description;
  String? symbol;
  DateTime? createdOn;

  PackageDesc({
    this.id,
    this.name,
    this.description,
    this.symbol,
    this.createdOn,
  });

  factory PackageDesc.fromJson(Map<String, dynamic> json) => PackageDesc(
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

class Metadatum {
  String? id;
  String? key;
  String? value;
  String? companyId;
  String? inventoryItemId;
  String? teamMemberId;

  Metadatum({
    this.id,
    this.key,
    this.value,
    this.companyId,
    this.inventoryItemId,
    this.teamMemberId,
  });

  factory Metadatum.fromJson(Map<String, dynamic> json) => Metadatum(
        id: json["id"],
        key: json["key"],
        value: json["value"],
        companyId: json["companyId"],
        inventoryItemId: json["inventoryItemId"],
        teamMemberId: json["teamMemberId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
        "value": value,
        "companyId": companyId,
        "inventoryItemId": inventoryItemId,
        "teamMemberId": teamMemberId,
      };
}

class ReorderItem {
  String? id;
  String? locationId;
  int? reOrderLimit;
  int? criticalLimit;
  int? reOrderTo;
  dynamic expirationDate;
  int? currentAmount;
  String? measurementUnitId;
  String? inventoryItemsId;
  DateTime? createdOn;
  PackageDesc? measurementUnit;

  ReorderItem({
    this.id,
    this.locationId,
    this.reOrderLimit,
    this.criticalLimit,
    this.reOrderTo,
    this.expirationDate,
    this.currentAmount,
    this.measurementUnitId,
    this.inventoryItemsId,
    this.createdOn,
    this.measurementUnit,
  });

  factory ReorderItem.fromJson(Map<String, dynamic> json) => ReorderItem(
        id: json["id"],
        locationId: json["locationId"],
        reOrderLimit: json["reOrderLimit"],
        criticalLimit: json["criticalLimit"],
        reOrderTo: json["reOrderTo"],
        expirationDate: json["expirationDate"],
        currentAmount: json["currentAmount"],
        measurementUnitId: json["measurementUnitId"],
        inventoryItemsId: json["inventoryItemsId"],
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
        measurementUnit: json["measurementUnit"] == null
            ? null
            : PackageDesc.fromJson(json["measurementUnit"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "locationId": locationId,
        "reOrderLimit": reOrderLimit,
        "criticalLimit": criticalLimit,
        "reOrderTo": reOrderTo,
        "expirationDate": expirationDate,
        "currentAmount": currentAmount,
        "measurementUnitId": measurementUnitId,
        "inventoryItemsId": inventoryItemsId,
        "createdOn": createdOn?.toIso8601String(),
        "measurementUnit": measurementUnit?.toJson(),
      };
}
