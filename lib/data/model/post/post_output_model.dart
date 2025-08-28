import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:handoff_vdb_2025/data/model/post/post_feels.dart';
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
  List<UserModel>? friendsTagged;
  List<PostFeel>? feels;
  Map<String, dynamic>? feelCount; // ✅ sửa key ở toMap / fromMap
  String? myFeel;
  int? comments;
  int? views;

  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  int get totalFeel {
    if (feelCount == null) return 0;

    return feelCount!.values
        .whereType<int>()
        .fold(0, (sum, value) => sum + value);
  }

  List<String>? get top2 {
    if (feelCount == null || feelCount!.isEmpty) return [];

    // Lọc chỉ các entry có giá trị > 0
    final filtered = feelCount!.entries
        .where((entry) => entry.value > 0)
        .toList();

    // Nếu không có cảm xúc nào > 0, trả về []
    if (filtered.isEmpty) return [];

    // Sắp xếp giảm dần theo giá trị
    filtered.sort((a, b) => b.value.compareTo(a.value));

    // Trả về tối đa 2 key (tên cảm xúc)
    return filtered.take(2).map((entry) => entry.key).toList();
  }


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
    this.feels,
    this.feelCount,
    this.myFeel,
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
    List<UserModel>? friendsTagged,
    List<PostFeel>? feels,
    Map<String, dynamic>? feelCount,
    String? myFeel,
    int? comments,
    int? views,
    int? totalFeel,
    List<String>? top2,
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
      feels: feels ?? this.feels,
      feelCount: feelCount ?? this.feelCount,
      myFeel: myFeel ?? this.myFeel,
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
      if (friendsTagged != null && friendsTagged!.isNotEmpty)
        'friends_tagged': friendsTagged!.map((f) => f.toMap()).toList(),
      if (feels != null && feels!.isNotEmpty)
        'feels': feels!.map((f) => f.toMap()).toList(),
      if (feelCount != null) 'feel_count': feelCount, // ✅ sửa key
      if (!Validate.nullOrEmpty(myFeel)) 'my_feel': myFeel,
      if (comments != null) 'comments': comments,
      if (views != null) 'views': views,
      if (totalFeel != null) 'totalFeel': totalFeel,
      if (top2 != null && top2!.isNotEmpty) 'top2': top2,
      if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      if (v != null) '__v': v,
    };
  }

  factory PostOutputModel.fromMap(Map<String, dynamic> map) {
    UserModel? userIdModel;
    if (map['userId'] != null) {
      if (map['userId'] is Map<String, dynamic>) {
        userIdModel = UserModel.fromMap(map['userId'] as Map<String, dynamic>);
      } else if (map['userId'] is String) {
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
          ? (map['friends_tagged'] as List)
          .map((f) => UserModel.fromMap(f as Map<String, dynamic>))
          .toList()
          : null,
      feels: map['feels'] != null
          ? (map['feels'] as List)
          .map((f) => PostFeel.fromMap(f as Map<String, dynamic>))
          .toList()
          : null,
      feelCount: map['feel_count'] != null // ✅ sửa key
          ? Map<String, dynamic>.from(map['feel_count'] as Map)
          : null,
      myFeel: map['my_feel'] as String?,
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

  @override
  bool operator ==(covariant PostOutputModel other) {
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
        listEquals(other.feels, feels) &&
        mapEquals(other.feelCount, feelCount) &&
        other.myFeel == myFeel &&
        other.comments == comments &&
        other.views == views &&
        other.totalFeel == totalFeel &&
        listEquals(other.top2, top2) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.v == v;
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    userId,
    title,
    privacy,
    images,
    videos,
    postLinkMeta,
    hashtags,
    content,
    friendsTagged,
    feels,
    feelCount,
    myFeel,
    comments,
    views,
    totalFeel,
    top2,
    createdAt,
    updatedAt,
    v,
  ]);
}
