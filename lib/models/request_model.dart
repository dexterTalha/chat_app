// To parse this JSON data, do
//
//     final requestModel = requestModelFromMap(jsonString);

import 'dart:convert';

RequestModel requestModelFromMap(String str) => RequestModel.fromMap(json.decode(str));

String requestModelToMap(RequestModel data) => json.encode(data.toMap());

class RequestModel {
  RequestModel({
    this.id,
    this.sender,
    this.receiver,
    this.accepted,
    this.timestamp,
  });

  final String? id;
  final String? sender;
  final String? receiver;
  final bool? accepted;
  final int? timestamp;

  RequestModel copyWith({
    String? id,
    String? sender,
    String? receiver,
    bool? accepted,
    int? timestamp,
  }) =>
      RequestModel(
        id: id ?? this.id,
        sender: sender ?? this.sender,
        receiver: receiver ?? this.receiver,
        accepted: accepted ?? this.accepted,
        timestamp: timestamp ?? this.timestamp,
      );

  factory RequestModel.fromMap(Map<String, dynamic> json, [String? id]) => RequestModel(
        id: id,
        sender: json["sender"],
        receiver: json["receiver"],
        accepted: json["accepted"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "sender": sender,
        "receiver": receiver,
        "accepted": accepted,
        "timestamp": timestamp,
      };
}
