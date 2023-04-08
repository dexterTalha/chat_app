// To parse this JSON data, do
//
//     final friendModel = friendModelFromMap(jsonString);

import 'dart:convert';

FriendModel friendModelFromMap(String str) => FriendModel.fromMap(json.decode(str));

String friendModelToMap(FriendModel data) => json.encode(data.toMap());

class FriendModel {
  FriendModel({
    this.friend,
    this.email,
    this.isBlocked,
    this.timestamp,
  });

  final String? friend;
  final String? email;
  final bool? isBlocked;
  final int? timestamp;

  FriendModel copyWith({
    String? friend,
    String? email,
    bool? isBlocked,
    int? timestamp,
  }) =>
      FriendModel(
        friend: friend ?? this.friend,
        email: email ?? this.email,
        isBlocked: isBlocked ?? this.isBlocked,
        timestamp: timestamp ?? this.timestamp,
      );

  factory FriendModel.fromMap(Map<String, dynamic> json) => FriendModel(
        friend: json["friend"],
        email: json["email"],
        isBlocked: json["isBlocked"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toMap() => {
        "friend": friend,
        "email": email,
        "isBlocked": isBlocked,
        "timestamp": timestamp,
      };
}
