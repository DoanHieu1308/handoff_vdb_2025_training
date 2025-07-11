import 'dart:convert';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import '../../../core/helper/validate.dart';

class FriendRequestModel {
  String? id;
  UserModel? fromUser;
  String? toUser;
  String? status;
  DateTime? acceptedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  FriendRequestModel({
    this.id,
    this.fromUser,
    this.toUser,
    this.status,
    this.acceptedAt,
    this.createdAt,
    this.updatedAt,
  });

  FriendRequestModel copyWith({
    String? id,
    UserModel? fromUser,
    String? toUser,
    String? status,
    DateTime? acceptedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FriendRequestModel(
      id: id ?? this.id,
      fromUser: fromUser ?? this.fromUser,
      toUser: toUser ?? this.toUser,
      status: status ?? this.status,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (!Validate.nullOrEmpty(id)) '_id': id,
      if (fromUser != null) 'fromUser': fromUser!.toMap(),
      if (!Validate.nullOrEmpty(toUser)) 'toUser': toUser,
      if (!Validate.nullOrEmpty(status)) 'status': status,
      if (acceptedAt != null) 'acceptedAt': acceptedAt!.toIso8601String(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  factory FriendRequestModel.fromMap(Map<String, dynamic> map) {
    return FriendRequestModel(
      id: map['_id'] as String?,
      fromUser: map['fromUser'] != null
          ? UserModel.fromMap(map['fromUser'] as Map<String, dynamic>)
          : null,
      toUser: map['toUser'] as String?,
      status: map['status'] as String?,
      acceptedAt: map['acceptedAt'] != null
          ? DateTime.tryParse(map['acceptedAt'] as String)
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'] as String)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FriendRequestModel.fromJson(String source) =>
      FriendRequestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FriendRequestModel(id: $id, fromUser: $fromUser, toUser: $toUser, status: $status, acceptedAt: $acceptedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant FriendRequestModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.fromUser == fromUser &&
        other.toUser == toUser &&
        other.status == status &&
        other.acceptedAt == acceptedAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    fromUser.hashCode ^
    toUser.hashCode ^
    status.hashCode ^
    acceptedAt.hashCode ^
    createdAt.hashCode ^
    updatedAt.hashCode;
  }
}
