import 'dart:convert';

import 'package:handoff_vdb_2025/core/helper/validate.dart';
import 'package:handoff_vdb_2025/data/model/post/post_link_meta.dart';

class PostInputModel {
  String? id;
  String? title;
  String? content;
  String? privacy; // "public" | "friend" | "private"
  List<String>? hashtags;
  List<String>? friendsTagged;
  List<String>? images;
  List<String>? videos;
  PostLinkMeta? postLinkMeta;

  PostInputModel({
    this.id,
    this.title,
    this.content,
    this.privacy,
    this.hashtags,
    this.friendsTagged,
    this.images,
    this.videos,
    this.postLinkMeta,
  });

  PostInputModel copyWith({
    String? id,
    String? title,
    String? content,
    String? privacy,
    List<String>? hashtags,
    List<String>? friendsTagged,
    List<String>? images,
    List<String>? videos,
    PostLinkMeta? postLinkMeta,
  }) {
    return PostInputModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      privacy: privacy ?? this.privacy,
      hashtags: hashtags ?? this.hashtags,
      friendsTagged: friendsTagged ?? this.friendsTagged,
      images: images ?? this.images,
      videos: videos ?? this.videos,
      postLinkMeta: postLinkMeta ?? this.postLinkMeta,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (!Validate.nullOrEmpty(id)) '_id': id,
      if (!Validate.nullOrEmpty(title)) 'title': title,
      if (!Validate.nullOrEmpty(content)) 'content': content,
      if (!Validate.nullOrEmpty(privacy)) 'privacy': privacy,
      if (hashtags != null && hashtags!.isNotEmpty) 'hashtags': hashtags,
      if (friendsTagged != null && friendsTagged!.isNotEmpty) 'friends_tagged': friendsTagged,
      if (images != null && images!.isNotEmpty) 'images': images,
      if (videos != null && videos!.isNotEmpty) 'videos': videos,
      if (postLinkMeta != null) 'post_link_meta': postLinkMeta!.toMap(),
    };
  }

  factory PostInputModel.fromMap(Map<String, dynamic> map) {
    return PostInputModel(
      id: map['_id'] as String?,
      title: map['title'] as String?,
      content: map['content'] as String?,
      privacy: map['privacy'] as String?,
      hashtags: map['hashtags'] != null
          ? List<String>.from(map['hashtags'] as List)
          : null,
      friendsTagged: map['friends_tagged'] != null
          ? List<String>.from(map['friends_tagged'] as List)
          : null,
      images: map['images'] != null
          ? List<String>.from(map['images'] as List)
          : null,
      videos: map['videos'] != null
          ? List<String>.from(map['videos'] as List)
          : null,
      postLinkMeta: map['post_link_meta'] != null
          ? PostLinkMeta.fromMap(map['post_link_meta'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostInputModel.fromJson(String source) =>
      PostInputModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostModel(id: $id, title: $title, content: $content, privacy: $privacy, hashtags: $hashtags, friendsTagged: $friendsTagged, images: $images, videos: $videos, postLinkMeta: $postLinkMeta)';
  }

  @override
  bool operator ==(covariant PostInputModel other) {
    if (identical(this, other)) return true;

    bool listEquals(List<String>? a, List<String>? b) {
      if (a == null && b == null) return true;
      if (a == null || b == null) return false;
      if (a.length != b.length) return false;
      for (int i = 0; i < a.length; i++) {
        if (a[i] != b[i]) return false;
      }
      return true;
    }

    return other.id == id &&
        other.title == title &&
        other.content == content &&
        other.privacy == privacy &&
        listEquals(other.hashtags, hashtags) &&
        listEquals(other.friendsTagged, friendsTagged) &&
        listEquals(other.images, images) &&
        listEquals(other.videos, videos) &&
        other.postLinkMeta == postLinkMeta;
  }

  @override
  int get hashCode {
    int listHash(List<String>? list) {
      if (list == null) return 0;
      return list.fold(0, (prev, e) => prev ^ e.hashCode);
    }

    return id.hashCode ^
    title.hashCode ^
    content.hashCode ^
    privacy.hashCode ^
    listHash(hashtags) ^
    listHash(friendsTagged) ^
    listHash(images) ^
    listHash(videos) ^
    (postLinkMeta?.hashCode ?? 0);
  }
}