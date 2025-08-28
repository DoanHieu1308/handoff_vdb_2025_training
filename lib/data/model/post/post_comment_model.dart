import 'dart:convert';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import '../../../core/helper/validate.dart';

class PostCommentModel {
  final String? id;
  final String? commentPostId;
  final UserModel? user;
  final String? commentContent;
  final String? commentParentId;
  final String? createdAt;
  final String? updatedAt;
  final List<PostCommentModel>? replies;

  PostCommentModel({
    this.id,
    this.commentPostId,
    this.user,
    this.commentContent,
    this.commentParentId,
    this.createdAt,
    this.updatedAt,
    this.replies,
  });

  PostCommentModel copyWith({
    String? id,
    String? commentPostId,
    UserModel? user,
    String? commentContent,
    String? commentParentId,
    String? createdAt,
    String? updatedAt,
    List<PostCommentModel>? replies,
  }) {
    return PostCommentModel(
      id: id ?? this.id,
      commentPostId: commentPostId ?? this.commentPostId,
      user: user ?? this.user,
      commentContent: commentContent ?? this.commentContent,
      commentParentId: commentParentId ?? this.commentParentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      replies: replies ?? this.replies,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (!Validate.nullOrEmpty(id)) '_id': id,
      if (!Validate.nullOrEmpty(commentPostId)) 'comment_post_id': commentPostId,
      if (user != null) 'user': user!.toMap(),
      if (!Validate.nullOrEmpty(commentContent)) 'comment_content': commentContent,
      if (!Validate.nullOrEmpty(commentParentId)) 'comment_parent_id': commentParentId,
      if (!Validate.nullOrEmpty(createdAt)) 'createdAt': createdAt,
      if (!Validate.nullOrEmpty(updatedAt)) 'updatedAt': updatedAt,
      if (replies != null) 'replies': replies!.map((e) => e.toMap()).toList(),
    };
  }

  factory PostCommentModel.fromMap(Map<String, dynamic> map) {
    return PostCommentModel(
      id: map['_id'] as String?,
      commentPostId: map['comment_post_id'] as String?,
      user: map['user'] != null
          ? UserModel.fromMap(map['user'] as Map<String, dynamic>)
          : null,
      commentContent: map['comment_content'] as String?,
      commentParentId: map['comment_parent_id'] as String?,
      createdAt: map['createdAt'] as String?,
      updatedAt: map['updatedAt'] as String?,
      replies: map['replies'] != null
          ? (map['replies'] as List)
          .map((x) => PostCommentModel.fromMap(x as Map<String, dynamic>))
          .toList()
          : [],
    );
  }

  String toRawJson() => json.encode(toMap());

  factory PostCommentModel.fromRawJson(String source) =>
      PostCommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  factory PostCommentModel.fromJson(Map<String, dynamic> json) =>
      PostCommentModel.fromMap(json);
}
