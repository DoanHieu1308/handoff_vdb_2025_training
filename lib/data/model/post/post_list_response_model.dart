import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:handoff_vdb_2025/data/model/post/post_output_model.dart';
import '../pagination/pagination_model.dart';

class PostListResponseModel {
  final List<PostOutputModel> data;
  final PaginationModel pagination;

  PostListResponseModel({
    required this.data,
    required this.pagination,
  });

  PostListResponseModel copyWith({
    List<PostOutputModel>? data,
    PaginationModel? pagination,
  }) {
    return PostListResponseModel(
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data.map((e) => e.toMap()).toList(),
      'pagination': pagination.toMap(),
    };
  }

  factory PostListResponseModel.fromMap(Map<String, dynamic> map) {
    return PostListResponseModel(
      data: (map['data'] as List<dynamic>)
          .map((e) => PostOutputModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      pagination:
      PaginationModel.fromMap(map['pagination'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory PostListResponseModel.fromJson(String source) =>
      PostListResponseModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'PostListResponseModel(data: $data, pagination: $pagination)';

  @override
  bool operator ==(covariant PostListResponseModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.data, data) &&
        other.pagination == pagination;
  }

  @override
  int get hashCode => data.hashCode ^ pagination.hashCode;
}
