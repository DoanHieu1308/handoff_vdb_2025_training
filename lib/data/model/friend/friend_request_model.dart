import 'dart:convert';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import '../../../core/helper/validate.dart';

class FriendRequestModel {
  String? id;
  UserModel? fromUser;
  String? toUser;
  String? type;
  DateTime? acceptedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? isFollowing;

  FriendRequestModel({
    this.id,
    this.fromUser,
    this.toUser,
    this.type,
    this.acceptedAt,
    this.createdAt,
    this.updatedAt,
    this.isFollowing,
  });

  FriendRequestModel copyWith({
    String? id,
    UserModel? fromUser,
    String? toUser,
    String? status,
    DateTime? acceptedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? isFollowing,
  }) {
    return FriendRequestModel(
      id: id ?? this.id,
      fromUser: fromUser ?? this.fromUser,
      toUser: toUser ?? this.toUser,
      type: status ?? this.type,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (!Validate.nullOrEmpty(id)) '_id': id,
      if (fromUser != null) 'fromUser': fromUser!.toMap(),
      if (!Validate.nullOrEmpty(toUser)) 'toUser': toUser,
      if (!Validate.nullOrEmpty(type)) 'type': type,
      if (acceptedAt != null) 'acceptedAt': acceptedAt!.toIso8601String(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (!Validate.nullOrEmpty(isFollowing)) 'isFollowing': isFollowing,
    };
  }

  factory FriendRequestModel.fromMap(Map<String, dynamic> map) {
    return FriendRequestModel(
      id: map['_id'] as String?,
      fromUser: map['fromUser'] != null
          ? UserModel.fromMap(map['fromUser'] as Map<String, dynamic>)
          : null,
      toUser: map['toUser'] as String?,
      type: map['type'] as String?,
      acceptedAt: map['acceptedAt'] != null
          ? DateTime.tryParse(map['acceptedAt'] as String)
          : null,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'] as String)
          : null,
      isFollowing: map['isFollowing'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory FriendRequestModel.fromJson(String source) =>
      FriendRequestModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FriendRequestModel(id: $id, fromUser: $fromUser, toUser: $toUser, type: $type, acceptedAt: $acceptedAt, createdAt: $createdAt, updatedAt: $updatedAt, isFollowing: $isFollowing)';
  }

  @override
  bool operator ==(covariant FriendRequestModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.fromUser == fromUser &&
        other.toUser == toUser &&
        other.type == type &&
        other.acceptedAt == acceptedAt &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isFollowing == isFollowing;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    fromUser.hashCode ^
    toUser.hashCode ^
    type.hashCode ^
    acceptedAt.hashCode ^
    createdAt.hashCode ^
    updatedAt.hashCode ^
    isFollowing.hashCode;
  }
}
