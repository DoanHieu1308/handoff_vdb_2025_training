import 'dart:convert';

class PostFeel {
  String? userId;
  String? feelType;

  PostFeel({
    this.userId,
    this.feelType,
  });

  PostFeel copyWith({
    String? userId,
    String? feelType,
  }) {
    return PostFeel(
      userId: userId ?? this.userId,
      feelType: feelType ?? this.feelType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      if (userId != null) 'userId': userId,
      if (feelType != null) 'feel_type': feelType,
    };
  }

  factory PostFeel.fromMap(Map<String, dynamic> map) {
    return PostFeel(
      userId: map['userId'] as String?,
      feelType: map['feel_type'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory PostFeel.fromJson(String source) =>
      PostFeel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'PostFeel(userId: $userId, feelType: $feelType)';

  @override
  bool operator ==(covariant PostFeel other) {
    if (identical(this, other)) return true;
    return other.userId == userId && other.feelType == feelType;
  }

  @override
  int get hashCode => userId.hashCode ^ feelType.hashCode;
}
