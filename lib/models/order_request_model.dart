// To parse this JSON data, do
//
//     final orderRequestModel = orderRequestModelFromJson(jsonString);

import 'dart:convert';

List<OrderRequestModel> orderRequestModelFromJson(String str) =>
    List<OrderRequestModel>.from(
        json.decode(str).map((x) => OrderRequestModel.fromJson(x)));

String orderRequestModelToJson(List<OrderRequestModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderRequestModel {
  String? orderIdentifier;
  List<Order>? orders;
  List<Attachment>? attachments;

  OrderRequestModel({
    this.orderIdentifier,
    this.orders,
    this.attachments,
  });

  factory OrderRequestModel.fromJson(Map<String, dynamic> json) =>
      OrderRequestModel(
        orderIdentifier: json["orderIdentifier"],
        orders: json["orders"] == null
            ? []
            : List<Order>.from(json["orders"]!.map((x) => Order.fromJson(x))),
        attachments: json["attachments"] == null
            ? []
            : List<Attachment>.from(
                json["attachments"]!.map((x) => Attachment.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orderIdentifier": orderIdentifier,
        "orders": orders == null
            ? []
            : List<dynamic>.from(orders!.map((x) => x.toJson())),
        "attachments": attachments == null
            ? []
            : List<dynamic>.from(attachments!.map((x) => x.toJson())),
      };
}

class Attachment {
  String? id;
  String? orderIdentifier;
  String? attachmentName;
  String? url;
  String? type;

  Attachment({
    this.id,
    this.orderIdentifier,
    this.attachmentName,
    this.url,
    this.type,
  });

  factory Attachment.fromJson(Map<String, dynamic> json) => Attachment(
        id: json["id"],
        orderIdentifier: json["orderIdentifier"],
        attachmentName: json["attachmentName"],
        url: json["url"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "orderIdentifier": orderIdentifier,
        "attachmentName": attachmentName,
        "url": url,
        "type": type,
      };
}

class Order {
  String? id;
  String? referenceNumber;
  String? teamMembershipId;
  String? branchId;
  String? companyId;
  int? packagesToOrder;
  String? orderIdentifier;
  String? status;
  String? backOrderNote;
  int? backOrderAmount;
  String? lotNumber;
  DateTime? expirationDate;
  String? measurementUnitId;
  int? quantityReceived;
  DateTime? receivedOn;
  DateTime? createdOn;
  Reference? reference;
  TeamMembership? teamMembership;
  Branch? branch;

  Order({
    this.id,
    this.referenceNumber,
    this.teamMembershipId,
    this.branchId,
    this.companyId,
    this.packagesToOrder,
    this.orderIdentifier,
    this.status,
    this.backOrderNote,
    this.backOrderAmount,
    this.lotNumber,
    this.expirationDate,
    this.measurementUnitId,
    this.quantityReceived,
    this.receivedOn,
    this.createdOn,
    this.reference,
    this.teamMembership,
    this.branch,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        referenceNumber: json["referenceNumber"],
        teamMembershipId: json["teamMembershipId"],
        branchId: json["branchId"],
        companyId: json["companyId"],
        packagesToOrder: json["packagesToOrder"],
        orderIdentifier: json["orderIdentifier"],
        status: json["status"],
        backOrderNote: json["backOrderNote"],
        backOrderAmount: json["backOrderAmount"],
        lotNumber: json["lotNumber"],
        expirationDate: json["expirationDate"] == null
            ? null
            : DateTime.parse(json["expirationDate"]),
        measurementUnitId: json["measurementUnitId"],
        quantityReceived: json["quantityReceived"],
        receivedOn: json["receivedOn"] == null
            ? null
            : DateTime.parse(json["receivedOn"]),
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
        reference: json["reference"] == null
            ? null
            : Reference.fromJson(json["reference"]),
        teamMembership: json["teamMembership"] == null
            ? null
            : TeamMembership.fromJson(json["teamMembership"]),
        branch: json["branch"] == null ? null : Branch.fromJson(json["branch"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "referenceNumber": referenceNumber,
        "teamMembershipId": teamMembershipId,
        "branchId": branchId,
        "companyId": companyId,
        "packagesToOrder": packagesToOrder,
        "orderIdentifier": orderIdentifier,
        "status": status,
        "backOrderNote": backOrderNote,
        "backOrderAmount": backOrderAmount,
        "lotNumber": lotNumber,
        "expirationDate": expirationDate?.toIso8601String(),
        "measurementUnitId": measurementUnitId,
        "quantityReceived": quantityReceived,
        "receivedOn": receivedOn?.toIso8601String(),
        "createdOn": createdOn?.toIso8601String(),
        "reference": reference?.toJson(),
        "teamMembership": teamMembership?.toJson(),
        "branch": branch?.toJson(),
      };
}

class Branch {
  String? id;
  String? name;
  String? address;
  String? hexcode;
  String? symbol;

  Branch({
    this.id,
    this.name,
    this.address,
    this.hexcode,
    this.symbol,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        hexcode: json["hexcode"],
        symbol: json["symbol"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "hexcode": hexcode,
        "symbol": symbol,
      };
}

class Reference {
  String? id;
  int? packageCost;
  String? referenceNumber;
  String? status;
  DateTime? createdOn;

  Reference({
    this.id,
    this.packageCost,
    this.referenceNumber,
    this.status,
    this.createdOn,
  });

  factory Reference.fromJson(Map<String, dynamic> json) => Reference(
        id: json["id"],
        packageCost: json["packageCost"],
        referenceNumber: json["referenceNumber"],
        status: json["status"],
        createdOn: json["createdOn"] == null
            ? null
            : DateTime.parse(json["createdOn"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "packageCost": packageCost,
        "referenceNumber": referenceNumber,
        "status": status,
        "createdOn": createdOn?.toIso8601String(),
      };
}

class TeamMembership {
  String? id;
  User? user;

  TeamMembership({
    this.id,
    this.user,
  });

  factory TeamMembership.fromJson(Map<String, dynamic> json) => TeamMembership(
        id: json["id"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user?.toJson(),
      };
}

class User {
  String? id;
  String? firstName;
  String? lastName;
  dynamic picture;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.picture,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        picture: json["picture"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "picture": picture,
      };
}
