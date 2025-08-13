import 'dart:convert';

class PaginationModel {
  final int page;
  final int limit;
  final int totalItems;
  final int totalPages;

  PaginationModel({
    required this.page,
    required this.limit,
    required this.totalItems,
    required this.totalPages,
  });

  PaginationModel copyWith({
    int? page,
    int? limit,
    int? totalItems,
    int? totalPages,
  }) {
    return PaginationModel(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'page': page,
      'limit': limit,
      'totalItems': totalItems,
      'totalPages': totalPages,
    };
  }

  factory PaginationModel.fromMap(Map<String, dynamic> map) {
    return PaginationModel(
      page: map['page'] ?? 1,
      limit: map['limit'] ?? 10,
      totalItems: map['totalItems'] ?? 0,
      totalPages: map['totalPages'] ?? 1,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaginationModel.fromJson(String source) =>
      PaginationModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PaginationModel(page: $page, limit: $limit, totalItems: $totalItems, totalPages: $totalPages)';
  }

  @override
  bool operator ==(covariant PaginationModel other) {
    if (identical(this, other)) return true;

    return other.page == page &&
        other.limit == limit &&
        other.totalItems == totalItems &&
        other.totalPages == totalPages;
  }

  @override
  int get hashCode {
    return page.hashCode ^
    limit.hashCode ^
    totalItems.hashCode ^
    totalPages.hashCode;
  }
}
