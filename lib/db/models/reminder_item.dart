import 'package:json_annotation/json_annotation.dart';

import '../db_model.dart';

part 'reminder_item.g.dart';

@JsonSerializable()
class ReminderItem implements DbModel {
  @override
  final int id;
  final String title;
  final String name;
  final String email;
  final String picture_large;
  final String picture_thumbnail;
  final String date;
  final String time;
  final int is_selected;
  final int is_notified;

  const ReminderItem({
    required this.id,
    required this.title,
    required this.name,
    required this.email,
    required this.picture_large,
    required this.picture_thumbnail,
    required this.date,
    required this.time,
    required this.is_selected,
    required this.is_notified,
  });

  factory ReminderItem.fromJson(Map<String, dynamic> json) =>
      _$ReminderItemFromJson(json);

  Map<String, dynamic> toJson() => _$ReminderItemToJson(this);

  factory ReminderItem.fromMap(Map<String, dynamic> map) =>
      _$ReminderItemFromMap(map);

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'name': name,
      'email': email,
      'picture_large': picture_large,
      'picture_thumbnail': picture_thumbnail,
      'date': date,
      'time': time,
      'is_selected': is_selected,
      'is_notified': is_notified,
    };
  }

  @override
  Map<String, dynamic> toMapValue() {
    return <String, dynamic>{
      'title': title,
      'name': name,
      'email': email,
      'picture_large': picture_large,
      'picture_thumbnail': picture_thumbnail,
      'date': date,
      'time': time,
      'is_selected': is_selected,
      'is_notified': is_notified,
    };
  }

  static ReminderItem _$ReminderItemFromMap(Map<String, dynamic> map) =>
      ReminderItem(
        id: map['id'],
        title: map['title'],
        name: map['name'],
        email: map['email'],
        picture_large: map['picture_large'],
        picture_thumbnail: map['picture_thumbnail'],
        date: map['date'],
        time: map['time'],
        is_selected: map['is_selected'],
        is_notified: map['is_notified'],
      );

  ReminderItem copyWith({
    int? id,
    String? title,
    String? name,
    String? email,
    String? picture_large,
    String? picture_thumbnail,
    String? date,
    String? time,
    int? is_selected,
    int? is_notified,
  }) {
    return ReminderItem(
      id: id ?? this.id,
      title: title ?? this.title,
      name: name ?? this.name,
      email: email ?? this.email,
      picture_large: picture_large ?? this.picture_large,
      picture_thumbnail: picture_thumbnail ?? this.picture_thumbnail,
      date: date ?? this.date,
      time: time ?? this.time,
      is_selected: is_selected ?? this.is_selected,
      is_notified: is_notified ?? this.is_notified,
    );
  }
}
