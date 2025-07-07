import 'dart:convert';

import '../../../core/helper/validate.dart';

class FriendRequestModel {
  String? id;
  String? fromUser;
  String? toUser;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  FriendRequestModel({
    this.id,
    this.fromUser,
    this.toUser,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  FriendRequestModel copyWith({
    String? id,
    String? fromUser,
    String? toUser,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FriendRequestModel(
      id: id ?? this.id,
      fromUser: fromUser ?? this.fromUser,
      toUser: toUser ?? this.toUser,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (!Validate.nullOrEmpty(id)) '_id': id,
      if (!Validate.nullOrEmpty(fromUser)) 'fromUser': fromUser,
      if (!Validate.nullOrEmpty(toUser)) 'toUser': toUser,
      if (!Validate.nullOrEmpty(status)) 'status': status,
      if (!Validate.nullOrEmpty(createdAt)) 'createdAt': createdAt?.millisecondsSinceEpoch,
      if (!Validate.nullOrEmpty(updatedAt)) 'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory FriendRequestModel.fromMap(Map<String, dynamic> map) {
    return FriendRequestModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      fromUser: map['fromUser'] != null ? map['fromUser'] as String : null,
      toUser: map['toUser'] != null ? map['toUser'] as String : null,
      status: map['status'] != null ? map['status'] as String : null,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FriendRequestModel.fromJson(String source) =>
      FriendRequestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FriendRequestModel(id: $id, fromUser: $fromUser, toUser: $toUser, status: $status, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant FriendRequestModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.fromUser == fromUser &&
        other.toUser == toUser &&
        other.status == status &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    fromUser.hashCode ^
    toUser.hashCode ^
    status.hashCode ^
    createdAt.hashCode ^
    updatedAt.hashCode;
  }
}
