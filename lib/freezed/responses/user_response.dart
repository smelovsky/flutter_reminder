import 'dart:developer';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_response.freezed.dart';
part 'user_response.g.dart';

@freezed
class Name with _$Name {
  const factory Name({
    required String title,
    required String first,
    required String last,
  }) = _Name;

  factory Name.fromJson(Map<String, Object?> json) => _$NameFromJson(json);
}

@freezed
class Picture with _$Picture {
  const factory Picture({
    required String large,
    required String medium,
    required String thumbnail,
  }) = _Picture;

  factory Picture.fromJson(Map<String, Object?> json) =>
      _$PictureFromJson(json);
}

@freezed
class Results with _$Results {
  const factory Results({
    required Name name,
    required String email,
    required Picture picture,
  }) = _Results;

  factory Results.fromJson(Map<String, Object?> json) =>
      _$ResultsFromJson(json);
}

@freezed
class UserResponse with _$UserResponse {
  const factory UserResponse({
    required Results results,
  }) = _UserResponse;

  factory UserResponse.fromJson(Map<String, Object?> json) =>
      _$UserResponseFromJson(json);
}

class UserRandomResponse {
  List<UserResponse> list = [];

  UserRandomResponse({required this.list});

  UserRandomResponse.fromJson(dynamic json) {
    var results = json["results"];

    for (var element in results) {
      var name = Name.fromJson(element["name"]);
      var picture = Picture.fromJson(element["picture"]);
      var email = element["email"];

      var userResponse = UserResponse(
          results: Results(name: name, email: email, picture: picture));

      list.add(userResponse);
    }
  }
}
