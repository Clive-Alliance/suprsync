// To parse this JSON data, do
//
//     final uploadPictureModel = uploadPictureModelFromJson(jsonString);

import 'dart:convert';

UploadPictureModel uploadPictureModelFromJson(String str) =>
    UploadPictureModel.fromJson(json.decode(str));

String uploadPictureModelToJson(UploadPictureModel data) =>
    json.encode(data.toJson());

class UploadPictureModel {
  String? url;

  UploadPictureModel({
    this.url,
  });

  factory UploadPictureModel.fromJson(Map<String, dynamic> json) =>
      UploadPictureModel(
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "url": url,
      };
}
