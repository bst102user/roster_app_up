// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    this.success,
  });

  List<SuccessNotif> success;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    success: List<SuccessNotif>.from(json["success"].map((x) => SuccessNotif.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": List<dynamic>.from(success.map((x) => x.toJson())),
  };
}

class SuccessNotif {
  SuccessNotif({
    this.title,
    this.massege,
    this.createdAt,
  });

  Title title;
  dynamic massege;
  DateTime createdAt;

  factory SuccessNotif.fromJson(Map<String, dynamic> json) => SuccessNotif(
    title: titleValues.map[json["title"]],
    massege: json["massege"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "title": titleValues.reverse[title],
    "massege": massege,
    "created_at": createdAt.toIso8601String(),
  };
}

enum MassegeEnum { YOUR_ROSTER_HAS_BEEN_SCHEDULE, YOUR_ROSTER_HAS_BEEN_SCHEDULE_20201214, MASSEGE_YOUR_ROSTER_HAS_BEEN_SCHEDULE }

final massegeEnumValues = EnumValues({
  "your roster has been schedule": MassegeEnum.MASSEGE_YOUR_ROSTER_HAS_BEEN_SCHEDULE,
  "your roster has been schedule ": MassegeEnum.YOUR_ROSTER_HAS_BEEN_SCHEDULE,
  "your roster has been schedule \"2020-12-14\" ": MassegeEnum.YOUR_ROSTER_HAS_BEEN_SCHEDULE_20201214
});

enum Title { ROSTER }

final titleValues = EnumValues({
  "Roster": Title.ROSTER
});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
