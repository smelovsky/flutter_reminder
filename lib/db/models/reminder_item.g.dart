// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReminderItem _$ReminderItemFromJson(Map<String, dynamic> json) => ReminderItem(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      picture_large: json['picture_large'] as String,
      picture_thumbnail: json['picture_thumbnail'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      is_selected: (json['is_selected'] as num).toInt(),
      is_notified: (json['is_notified'] as num).toInt(),
    );

Map<String, dynamic> _$ReminderItemToJson(ReminderItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'name': instance.name,
      'email': instance.email,
      'picture_large': instance.picture_large,
      'picture_thumbnail': instance.picture_thumbnail,
      'date': instance.date,
      'time': instance.time,
      'is_selected': instance.is_selected,
      'is_notified': instance.is_notified,
    };
