import 'dart:convert';

import '../../../core/helper/validate.dart';

class FriendModel {
  String? id;
  String? user1;
  String? user2;
  DateTime? createdAt;

  FriendModel({
    this.id,
    this.user1,
    this.user2,
    this.createdAt,
  });

  FriendModel copyWith({
    String? id,
    String? user1,
    String? user2,
    DateTime? createdAt,
  }) {
    return FriendModel(
      id: id ?? this.id,
      user1: user1 ?? this.user1,
      user2: user2 ?? this.user2,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (!Validate.nullOrEmpty(id)) '_id': id,
      if (!Validate.nullOrEmpty(user1)) 'user1': user1,
      if (!Validate.nullOrEmpty(user2)) 'user2': user2,
      if (!Validate.nullOrEmpty(createdAt)) 'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory FriendModel.fromMap(Map<String, dynamic> map) {
    return FriendModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      user1: map['user1'] != null ? map['user1'] as String : null,
      user2: map['user2'] != null ? map['user2'] as String : null,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FriendModel.fromJson(String source) =>
      FriendModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FriendModel(id: $id, user1: $user1, user2: $user2, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant FriendModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.user1 == user1 &&
        other.user2 == user2 &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ user1.hashCode ^ user2.hashCode ^ createdAt.hashCode;
  }
}
