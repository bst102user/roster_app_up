// To parse this JSON data, do
//
//     final restrntLocationModel = restrntLocationModelFromJson(jsonString);

import 'dart:convert';

RestrntLocationModel restrntLocationModelFromJson(String str) => RestrntLocationModel.fromJson(json.decode(str));

String restrntLocationModelToJson(RestrntLocationModel data) => json.encode(data.toJson());

class RestrntLocationModel {
  RestrntLocationModel({
    this.status,
    this.location,
  });

  String status;
  List<Location> location;

  factory RestrntLocationModel.fromJson(Map<String, dynamic> json) => RestrntLocationModel(
    status: json["status"],
    location: List<Location>.from(json["location"].map((x) => Location.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "location": List<dynamic>.from(location.map((x) => x.toJson())),
  };
}

class Location {
  Location({
    this.userMappingId,
    this.userId,
    this.entityId,
    this.locationId,
    this.userTypeId,
    this.groupId,
    this.createdOn,
    this.updatedOn,
    this.createdBy,
    this.updatedBy,
    this.getLocation,
  });

  int userMappingId;
  int userId;
  int entityId;
  int locationId;
  int userTypeId;
  int groupId;
  DateTime createdOn;
  dynamic updatedOn;
  int createdBy;
  int updatedBy;
  List<GetLocation> getLocation;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    userMappingId: json["UserMappingID"],
    userId: json["UserID"],
    entityId: json["EntityID"],
    locationId: json["LocationID"],
    userTypeId: json["UserTypeID"],
    groupId: json["GroupID"],
    createdOn: DateTime.parse(json["CreatedOn"]),
    updatedOn: json["UpdatedOn"],
    createdBy: json["CreatedBy"],
    updatedBy: json["UpdatedBy"],
    getLocation: List<GetLocation>.from(json["get_location"].map((x) => GetLocation.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "UserMappingID": userMappingId,
    "UserID": userId,
    "EntityID": entityId,
    "LocationID": locationId,
    "UserTypeID": userTypeId,
    "GroupID": groupId,
    "CreatedOn": createdOn.toIso8601String(),
    "UpdatedOn": updatedOn,
    "CreatedBy": createdBy,
    "UpdatedBy": updatedBy,
    "get_location": List<dynamic>.from(getLocation.map((x) => x.toJson())),
  };
}

class GetLocation {
  GetLocation({
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

  factory GetLocation.fromJson(Map<String, dynamic> json) => GetLocation(
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
