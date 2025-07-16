import 'dart:convert';
import '../../../core/helper/validate.dart';

class UserModel {
  String? id;
  String? name;
  String? email;
  String? password;
  String? avatar;
  String? bio;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.avatar,
    this.bio,
    this.createdAt,
    this.updatedAt,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? avatar,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (!Validate.nullOrEmpty(id)) 'id': id,
      if (!Validate.nullOrEmpty(name)) 'name': name,
      if (!Validate.nullOrEmpty(email)) 'email': email,
      if (!Validate.nullOrEmpty(password)) 'password': password,
      if (!Validate.nullOrEmpty(avatar)) 'avatar': avatar,
      if (!Validate.nullOrEmpty(bio)) 'bio': bio,
      if (!Validate.nullOrEmpty(createdAt)) 'createdAt': createdAt?.toIso8601String(),
      if (!Validate.nullOrEmpty(updatedAt)) 'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // factory UserModel.fromMap(Map<String, dynamic> map) {
  //   return UserModel(
  //     id: map['_id'] ?? map['id'],
  //     name: map['name'],
  //     email: map['email'],
  //     password: map['password'],
  //     avatar: map['avatar'],
  //     bio: map['bio'],
  //     createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null,
  //     updatedAt: map['updatedAt'] != null ? DateTime.tryParse(map['updatedAt']) : null,
  //   );
  // }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['userId'] ?? map['_id'] ?? map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      avatar: map['avatar'],
      bio: map['bio'],
      createdAt: map['createdAt'] != null ? DateTime.tryParse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.tryParse(map['updatedAt']) : null,
    );
  }


  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, password: $password, avatar: $avatar, bio: $bio, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    return other.id == id &&
        other.name == name &&
        other.email == email &&
        other.password == password &&
        other.avatar == avatar &&
        other.bio == bio &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    name.hashCode ^
    email.hashCode ^
    password.hashCode ^
    avatar.hashCode ^
    bio.hashCode ^
    createdAt.hashCode ^
    updatedAt.hashCode;
  }

  Map<String, dynamic> signUpEmail() => {
    if (!Validate.nullOrEmpty(name)) 'name': name,
    if (!Validate.nullOrEmpty(email)) 'email': email,
    if (!Validate.nullOrEmpty(password)) 'password': password,
    if (!Validate.nullOrEmpty(avatar)) 'avatar': avatar,
    if (!Validate.nullOrEmpty(bio)) 'bio': bio,
  };

  Map<String, dynamic> loginEmail() => {
    if (!Validate.nullOrEmpty(email)) 'email': email,
    if (!Validate.nullOrEmpty(password)) 'password': password,
  };
}

