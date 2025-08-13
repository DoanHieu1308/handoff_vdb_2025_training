extension StringExtension on String {
  bool get isVideoFile {
    final lower = toLowerCase();
    return lower.endsWith('.mp4') ||
        lower.endsWith('.mov') ||
        lower.endsWith('.avi') ||
        lower.endsWith('.mkv') ||
        lower.endsWith('.flv') ||
        lower.endsWith('.wmv') ||
        lower.endsWith('.webm');
  }


  /// Hashtag
  static final RegExp hashtagRegExp = RegExp(r'\B#([\w\-]+)');
  List<String> get hashtags {
    final seen = <String>{};
    final ordered = <String>[];
    for (final m in hashtagRegExp.allMatches(this)) {
      final tag = m.group(1);
      if (tag != null && tag.isNotEmpty && !seen.contains(tag)) {
        seen.add(tag);
        ordered.add(tag);
      }
    }
    return ordered;
  }

  /// Link
  static final RegExp linkRegex = RegExp(
    r'(?:(?<=^)|(?<=\s))(https?:\/\/\S+)',
    caseSensitive: false,
  );

  /// Tất cả link không trùng theo thứ tự xuất hiện
  List<String> get links {
    final seen = <String>{};
    final ordered = <String>[];
    for (final m in linkRegex.allMatches(this)) {
      final link = m.group(0);
      if (link != null && !seen.contains(link)) {
        seen.add(link);
        ordered.add(link);
      }
    }
    return ordered;
  }

  /// Link đầu tiên nếu có
  String? get firstLink {
    final m = linkRegex.firstMatch(this);
    return m?.groupCount == 1 ? m?.group(1) : m?.group(0);
  }

  /// Có chứa ít nhất một link không
  bool get hasLink => firstLink != null;
}




