import 'dart:convert';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import '../../../core/helper/validate.dart';

class FriendSentModel {
  String? id;
  UserModel? fromUser;
  UserModel? toUser;
  String? type;
  DateTime? acceptedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? isFollowing;

  FriendSentModel({
    this.id,
    this.fromUser,
    this.toUser,
    this.type,
    this.acceptedAt,
    this.createdAt,
    this.updatedAt,
    this.isFollowing,
  });

  FriendSentModel copyWith({
    String? id,
    UserModel? fromUser,
    UserModel? toUser,
    String? type,
    DateTime? acceptedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? isFollowing,
  }) {
    return FriendSentModel(
      id: id ?? this.id,
      fromUser: fromUser ?? this.fromUser,
      toUser: toUser ?? this.toUser,
      type: type ?? this.type,
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
      if (toUser != null) 'toUser': toUser!.toMap(),
      if (!Validate.nullOrEmpty(type)) 'type': type,
      if (acceptedAt != null) 'acceptedAt': acceptedAt!.toIso8601String(),
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (!Validate.nullOrEmpty(isFollowing)) 'isFollowing': isFollowing,
    };
  }

  factory FriendSentModel.fromMap(Map<String, dynamic> map) {
    return FriendSentModel(
      id: map['_id'] as String?,
      fromUser: map['fromUser'] != null
          ? UserModel.fromMap(map['fromUser'] as Map<String, dynamic>)
          : null,
      toUser: map['toUser'] != null
          ? UserModel.fromMap(map['toUser'] as Map<String, dynamic>)
          : null,
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

  factory FriendSentModel.fromJson(String source) =>
      FriendSentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FriendSentModel(id: $id, fromUser: $fromUser, toUser: $toUser, type: $type, acceptedAt: $acceptedAt, createdAt: $createdAt, updatedAt: $updatedAt, isFollowing: $isFollowing)';
  }

  @override
  bool operator ==(covariant FriendSentModel other) {
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
