import 'dart:convert';
import '../../../core/helper/validate.dart';

import '../response/user_model.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class AuthModel {
  String? accessToken;
  String? refreshToken;
  UserModel? user;

  AuthModel({
    this.accessToken,
    this.refreshToken,
    this.user,
  });

  AuthModel copyWith({
    String? accessToken,
    String? refreshToken,
    UserModel? user,
  }) {
    return AuthModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthModel.fromJson(String source) =>
      AuthModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant AuthModel other) {
    if (identical(this, other)) return true;

    return other.accessToken == accessToken &&
        other.refreshToken == refreshToken &&
        other.user == user;
  }

  @override
  int get hashCode {
    return accessToken.hashCode ^ refreshToken.hashCode ^ user.hashCode;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (!Validate.nullOrEmpty(accessToken)) 'accessToken': accessToken,
      if (!Validate.nullOrEmpty(refreshToken)) 'refreshToken': refreshToken,
      if (user != null) 'user': user!.toMap(),
    };
  }

  factory AuthModel.fromMap(Map<String, dynamic> map) {
    return AuthModel(
      accessToken:
      map['accessToken'] != null ? map['accessToken'] as String : null,
      refreshToken:
      map['refreshToken'] != null ? map['refreshToken'] as String : null,
      user: map['user'] != null ? UserModel.fromMap(map['user']) : null,
    );
  }
}
