import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:handoff_vdb_2025/core/helper/validate.dart';
import 'post_link_meta.dart';

part 'post_input_model.g.dart';

@HiveType(typeId: 0)
class PostInputModel {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? title;

  @HiveField(2)
  String? content;

  @HiveField(3)
  String? privacy; // "public" | "friend" | "private"

  @HiveField(4)
  List<String>? hashtags;

  @HiveField(5)
  List<String>? friends_tagged;

  @HiveField(6)
  List<String>? images;

  @HiveField(7)
  List<String>? videos;

  @HiveField(8)
  PostLinkMeta? postLinkMeta;

  @HiveField(9)
  String? userId;

  @HiveField(10)
  DateTime? createdAt;

  PostInputModel({
    this.id,
    this.title,
    this.content,
    this.privacy,
    this.hashtags,
    this.friends_tagged,
    this.images,
    this.videos,
    this.postLinkMeta,
    this.userId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  PostInputModel copyWith({
    String? id,
    String? title,
    String? content,
    String? privacy,
    List<String>? hashtags,
    List<String>? friends_tagged,
    List<String>? images,
    List<String>? videos,
    PostLinkMeta? postLinkMeta,
    String? userId,
    DateTime? createdAt,
  }) {
    return PostInputModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      privacy: privacy ?? this.privacy,
      hashtags: hashtags ?? this.hashtags,
      friends_tagged: friends_tagged ?? this.friends_tagged,
      images: images ?? this.images,
      videos: videos ?? this.videos,
      postLinkMeta: postLinkMeta ?? this.postLinkMeta,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (!Validate.nullOrEmpty(id)) '_id': id,
      if (!Validate.nullOrEmpty(title)) 'title': title,
      if (!Validate.nullOrEmpty(content)) 'content': content,
      if (!Validate.nullOrEmpty(privacy)) 'privacy': privacy,
      if (hashtags != null && hashtags!.isNotEmpty) 'hashtags': hashtags,
      if (friends_tagged != null && friends_tagged!.isNotEmpty) 'friends_tagged': friends_tagged,
      if (images != null && images!.isNotEmpty) 'images': images,
      if (videos != null && videos!.isNotEmpty) 'videos': videos,
      if (postLinkMeta != null) 'post_link_meta': postLinkMeta!.toMap(),
      if (!Validate.nullOrEmpty(userId)) 'user_id': userId,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }

  factory PostInputModel.fromMap(Map<String, dynamic> map) {
    return PostInputModel(
      id: map['_id'] as String?,
      title: map['title'] as String?,
      content: map['content'] as String?,
      privacy: map['privacy'] as String?,
      hashtags: map['hashtags'] != null ? List<String>.from(map['hashtags']) : null,
      friends_tagged: map['friends_tagged'] != null ? List<String>.from(map['friends_tagged']) : null,
      images: map['images'] != null ? List<String>.from(map['images']) : null,
      videos: map['videos'] != null ? List<String>.from(map['videos']) : null,
      postLinkMeta: map['post_link_meta'] != null
          ? PostLinkMeta.fromMap(map['post_link_meta'])
          : null,
      userId: map['user_id'] as String?,
      createdAt: map['created_at'] != null ? DateTime.tryParse(map['created_at']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostInputModel.fromJson(String source) =>
      PostInputModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PostInputModel(id: $id, title: $title, userId: $userId, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PostInputModel && other.id == id && other.userId == userId;
  }

  @override
  int get hashCode => id.hashCode ^ (userId?.hashCode ?? 0);
}
