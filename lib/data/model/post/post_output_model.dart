import 'dart:convert';
import 'package:handoff_vdb_2025/data/model/post/post_link_meta.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';

import '../../../core/helper/validate.dart';

class PostOutputModel {
  String? id;
  UserModel? userId;
  String? title;
  String? privacy;
  List<String>? images;
  List<String>? videos;
  PostLinkMeta? postLinkMeta;
  List<String>? hashtags;
  String? content;
  List<String>? friendsTagged;
  Map<String, dynamic>? feel;
  Map<String, dynamic>? feelCount;
  int? comments;
  int? views;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  PostOutputModel({
    this.id,
    this.userId,
    this.title,
    this.privacy,
    this.images,
    this.videos,
    this.postLinkMeta,
    this.hashtags,
    this.content,
    this.friendsTagged,
    this.feel,
    this.feelCount,
    this.comments,
    this.views,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  PostOutputModel copyWith({
    String? id,
    UserModel? userId,
    String? title,
    String? privacy,
    List<String>? images,
    List<String>? videos,
    PostLinkMeta? postLinkMeta,
    List<String>? hashtags,
    String? content,
    List<String>? friendsTagged,
    Map<String, dynamic>? feel,
    Map<String, dynamic>? feelCount,
    int? comments,
    int? views,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? v,
  }) {
    return PostOutputModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      privacy: privacy ?? this.privacy,
      images: images ?? this.images,
      videos: videos ?? this.videos,
      postLinkMeta: postLinkMeta ?? this.postLinkMeta,
      hashtags: hashtags ?? this.hashtags,
      content: content ?? this.content,
      friendsTagged: friendsTagged ?? this.friendsTagged,
      feel: feel ?? this.feel,
      feelCount: feelCount ?? this.feelCount,
      comments: comments ?? this.comments,
      views: views ?? this.views,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      v: v ?? this.v,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (!Validate.nullOrEmpty(id)) '_id': id,
      if (userId != null) 'userId': userId!.toMap(),
      if (!Validate.nullOrEmpty(title)) 'title': title,
      if (!Validate.nullOrEmpty(privacy)) 'privacy': privacy,
      if (images != null && images!.isNotEmpty) 'images': images,
      if (videos != null && videos!.isNotEmpty) 'videos': videos,
      if (postLinkMeta != null) 'post_link_meta': postLinkMeta!.toMap(),
      if (hashtags != null && hashtags!.isNotEmpty) 'hashtags': hashtags,
      if (!Validate.nullOrEmpty(content)) 'content': content,
      if (friendsTagged != null && friendsTagged!.isNotEmpty) 'friends_tagged': friendsTagged,
      if (feel != null) 'feel': feel,
      if (feelCount != null) 'feelCount': feelCount,
      if (comments != null) 'comments': comments,
      if (views != null) 'views': views,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (v != null) '__v': v,
    };
  }

  factory PostOutputModel.fromMap(Map<String, dynamic> map) {
    // Handle userId which can be either a String or Map<String, dynamic>
    UserModel? userIdModel;
    if (map['userId'] != null) {
      if (map['userId'] is Map<String, dynamic>) {
        userIdModel = UserModel.fromMap(map['userId'] as Map<String, dynamic>);
      } else if (map['userId'] is String) {
        // If userId is a string, create a minimal UserModel with just the id
        userIdModel = UserModel(id: map['userId'] as String);
      }
    }

    return PostOutputModel(
      id: map['_id'] as String?,
      userId: userIdModel,
      title: map['title'] as String?,
      privacy: map['privacy'] as String?,
      images: map['images'] != null ? List<String>.from(map['images'] as List) : null,
      videos: map['videos'] != null ? List<String>.from(map['videos'] as List) : null,
      postLinkMeta: map['post_link_meta'] != null
          ? PostLinkMeta.fromMap(map['post_link_meta'] as Map<String, dynamic>)
          : null,
      hashtags: map['hashtags'] != null ? List<String>.from(map['hashtags'] as List) : null,
      content: map['content'] as String?,
      friendsTagged: map['friends_tagged'] != null
          ? List<String>.from(map['friends_tagged'] as List)
          : null,
      feel: map['feel'] != null ? Map<String, dynamic>.from(map['feel'] as Map) : null,
      feelCount: map['feelCount'] != null
          ? Map<String, dynamic>.from(map['feelCount'] as Map)
          : null,
      comments: map['comments'] is int ? map['comments'] as int : null,
      views: map['views'] is int ? map['views'] as int : null,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String)
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt'] as String)
          : null,
      v: map['__v'] is int ? map['__v'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostOutputModel.fromJson(String source) =>
      PostOutputModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostOutputModel(id: $id, userId: $userId, title: $title, privacy: $privacy, images: $images, videos: $videos, postLinkMeta: $postLinkMeta, hashtags: $hashtags, content: $content, friendsTagged: $friendsTagged, feel: $feel, feelCount: $feelCount, comments: $comments, views: $views, createdAt: $createdAt, updatedAt: $updatedAt, v: $v)';
  }

  @override
  bool operator ==(covariant PostOutputModel other) {
    bool listEquals(List<dynamic>? a, List<dynamic>? b) {
      if (a == null && b == null) return true;
      if (a == null || b == null) return false;
      if (a.length != b.length) return false;
      for (int i = 0; i < a.length; i++) {
        if (a[i] != b[i]) return false;
      }
      return true;
    }

    bool mapEquals(Map? a, Map? b) {
      if (a == null && b == null) return true;
      if (a == null || b == null) return false;
      if (a.length != b.length) return false;
      for (final key in a.keys) {
        if (!b.containsKey(key) || a[key] != b[key]) return false;
      }
      return true;
    }

    return other.id == id &&
        other.userId == userId &&
        other.title == title &&
        other.privacy == privacy &&
        listEquals(other.images, images) &&
        listEquals(other.videos, videos) &&
        other.postLinkMeta == postLinkMeta &&
        listEquals(other.hashtags, hashtags) &&
        other.content == content &&
        listEquals(other.friendsTagged, friendsTagged) &&
        mapEquals(other.feel, feel) &&
        mapEquals(other.feelCount, feelCount) &&
        other.comments == comments &&
        other.views == views &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.v == v;
  }

  @override
  int get hashCode {
    int listHash(List? list) {
      if (list == null) return 0;
      return list.fold(0, (prev, e) => prev ^ e.hashCode);
    }

    int mapHash(Map? map) {
      if (map == null) return 0;
      return map.entries.fold(0, (prev, e) => prev ^ e.key.hashCode ^ e.value.hashCode);
    }

    return id.hashCode ^
    userId.hashCode ^
    title.hashCode ^
    privacy.hashCode ^
    listHash(images) ^
    listHash(videos) ^
    (postLinkMeta?.hashCode ?? 0) ^
    listHash(hashtags) ^
    content.hashCode ^
    listHash(friendsTagged) ^
    mapHash(feel) ^
    mapHash(feelCount) ^
    (comments ?? 0).hashCode ^
    (views ?? 0).hashCode ^
    (createdAt?.hashCode ?? 0) ^
    (updatedAt?.hashCode ?? 0) ^
    (v ?? 0).hashCode;
  }
}
