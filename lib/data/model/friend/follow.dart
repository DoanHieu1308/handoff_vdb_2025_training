import 'dart:convert';

import '../../../core/helper/validate.dart';

class FollowModel {
  String? id;
  String? follower;
  String? following;
  DateTime? createdAt;

  FollowModel({
    this.id,
    this.follower,
    this.following,
    this.createdAt,
  });

  FollowModel copyWith({
    String? id,
    String? follower,
    String? following,
    DateTime? createdAt,
  }) {
    return FollowModel(
      id: id ?? this.id,
      follower: follower ?? this.follower,
      following: following ?? this.following,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (!Validate.nullOrEmpty(id)) '_id': id,
      if (!Validate.nullOrEmpty(follower)) 'follower': follower,
      if (!Validate.nullOrEmpty(following)) 'following': following,
      if (!Validate.nullOrEmpty(createdAt)) 'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory FollowModel.fromMap(Map<String, dynamic> map) {
    return FollowModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      follower: map['follower'] != null ? map['follower'] as String : null,
      following: map['following'] != null ? map['following'] as String : null,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FollowModel.fromJson(String source) =>
      FollowModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'FollowModel(id: $id, follower: $follower, following: $following, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant FollowModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.follower == follower &&
        other.following == following &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ follower.hashCode ^ following.hashCode ^ createdAt.hashCode;
  }
}
