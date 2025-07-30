import 'dart:convert';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';

class FriendProfileModel {
  UserModel? user;
  String? relation;
  bool? isFollowing;

  FriendProfileModel({
    this.user,
    this.relation,
    this.isFollowing,
  });

  FriendProfileModel copyWith({
    UserModel? user,
    String? relation,
    bool? isFollowing,
  }) {
    return FriendProfileModel(
      user: user ?? this.user,
      relation: relation ?? this.relation,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (user != null) 'user': user!.toMap(),
      if (relation != null) 'relation': relation,
      if (isFollowing != null) 'isFollowing': isFollowing,
    };
  }

  factory FriendProfileModel.fromMap(Map<String, dynamic> map) {
    return FriendProfileModel(
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      relation: map['relation'] as String?,
      isFollowing: map['isFollowing'] as bool?,
    );
  }

  String toJson() => json.encode(toMap());

  factory FriendProfileModel.fromJson(String source) =>
      FriendProfileModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'FriendProfileModel(user: $user, relation: $relation, isFollowing: $isFollowing)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FriendProfileModel &&
        other.user == user &&
        other.relation == relation &&
        other.isFollowing == isFollowing;
  }

  @override
  int get hashCode =>
      user.hashCode ^ relation.hashCode ^ isFollowing.hashCode;
}
