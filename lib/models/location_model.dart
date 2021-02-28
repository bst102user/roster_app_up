// To parse this JSON data, do
//
//     final locationModel = locationModelFromJson(jsonString);

import 'dart:convert';

LocationModel locationModelFromJson(String str) => LocationModel.fromJson(json.decode(str));

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
  LocationModel({
    this.success,
  });

  List<Success> success;

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    success: List<Success>.from(json["success"].map((x) => Success.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": List<dynamic>.from(success.map((x) => x.toJson())),
  };
}

class Success {
  Success({
    this.locationId,
    this.entityId,
    this.locationDesc,
    this.locationAddress,
    this.locationContact,
    this.locationContactEmail,
    this.locationContactPhone,
    this.locationLatitude,
    this.locationLongitude,
    this.createdOn,
    this.updatedOn,
    this.createdBy,
    this.updatedBy,
  });

  int locationId;
  int entityId;
  String locationDesc;
  String locationAddress;
  String locationContact;
  String locationContactEmail;
  String locationContactPhone;
  String locationLatitude;
  String locationLongitude;
  DateTime createdOn;
  dynamic updatedOn;
  int createdBy;
  int updatedBy;

  factory Success.fromJson(Map<String, dynamic> json) => Success(
    locationId: json["LocationID"],
    entityId: json["EntityID"],
    locationDesc: json["LocationDesc"],
    locationAddress: json["LocationAddress"],
    locationContact: json["LocationContact"],
    locationContactEmail: json["LocationContactEmail"],
    locationContactPhone: json["LocationContactPhone"],
    locationLatitude: json["LocationLatitude"],
    locationLongitude: json["LocationLongitude"],
    createdOn: DateTime.parse(json["CreatedOn"]),
    updatedOn: json["UpdatedOn"],
    createdBy: json["CreatedBy"],
    updatedBy: json["UpdatedBy"],
  );

  Map<String, dynamic> toJson() => {
    "LocationID": locationId,
    "EntityID": entityId,
    "LocationDesc": locationDesc,
    "LocationAddress": locationAddress,
    "LocationContact": locationContact,
    "LocationContactEmail": locationContactEmail,
    "LocationContactPhone": locationContactPhone,
    "LocationLatitude": locationLatitude,
    "LocationLongitude": locationLongitude,
    "CreatedOn": createdOn.toIso8601String(),
    "UpdatedOn": updatedOn,
    "CreatedBy": createdBy,
    "UpdatedBy": updatedBy,
  };
}
