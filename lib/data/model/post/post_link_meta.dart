import 'dart:convert';
import '../../../core/helper/validate.dart';

class PostLinkMeta {
  final String? id;
  final String? postLinkUrl;
  final String? postLinkTitle;
  final String? postLinkDescription;
  final String? postLinkImage;

  PostLinkMeta({
    this.id,
    this.postLinkUrl,
    this.postLinkTitle,
    this.postLinkDescription,
    this.postLinkImage,
  });

  PostLinkMeta copyWith({
    String? id,
    String? postLinkUrl,
    String? postLinkTitle,
    String? postLinkDescription,
    String? postLinkImage,
  }) {
    return PostLinkMeta(
      id: id ?? this.id,
      postLinkUrl: postLinkUrl ?? this.postLinkUrl,
      postLinkTitle: postLinkTitle ?? this.postLinkTitle,
      postLinkDescription: postLinkDescription ?? this.postLinkDescription,
      postLinkImage: postLinkImage ?? this.postLinkImage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (!Validate.nullOrEmpty(id)) '_id': id,
      if (!Validate.nullOrEmpty(postLinkUrl)) 'post_link_url': postLinkUrl,
      if (!Validate.nullOrEmpty(postLinkTitle)) 'post_link_title': postLinkTitle,
      if (!Validate.nullOrEmpty(postLinkDescription)) 'post_link_description': postLinkDescription,
      if (!Validate.nullOrEmpty(postLinkImage)) 'post_link_image': postLinkImage,
    };
  }

  factory PostLinkMeta.fromMap(Map<String, dynamic> map) {
    return PostLinkMeta(
      id: map['_id'] as String?,
      postLinkUrl: map['post_link_url'] as String?,
      postLinkTitle: map['post_link_title'] as String?,
      postLinkDescription: map['post_link_description'] as String?,
      postLinkImage: map['post_link_image'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostLinkMeta.fromJson(String source) =>
      PostLinkMeta.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PostLinkMeta(id: $id, postLinkUrl: $postLinkUrl, postLinkTitle: $postLinkTitle, postLinkDescription: $postLinkDescription, postLinkImage: $postLinkImage)';
  }

  @override
  bool operator ==(covariant PostLinkMeta other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.postLinkUrl == postLinkUrl &&
        other.postLinkTitle == postLinkTitle &&
        other.postLinkDescription == postLinkDescription &&
        other.postLinkImage == postLinkImage;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    postLinkUrl.hashCode ^
    postLinkTitle.hashCode ^
    postLinkDescription.hashCode ^
    postLinkImage.hashCode;
  }
}
