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

  bool get isImageFile {
    final lower = toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.bmp') ||
        lower.endsWith('.webp') ||
        lower.endsWith('.heic') ||
        lower.endsWith('.tiff');
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

  /// Check link youtube
  bool get isYoutubeUrl {
    final ytRegex = RegExp(r'^(https?:\/\/)?(www\.)?(youtube\.com|youtu\.be)\/');
    return ytRegex.hasMatch(this);
  }

  String get youtubeEmbedUrl {
    if (contains("youtube.com/watch")) {
      final uri = Uri.parse(this);
      final videoId = uri.queryParameters["v"];
      return "https://www.youtube.com/embed/$videoId?autoplay=1&controls=1&playsinline=1";
    } else if (contains("youtu.be/")) {
      final videoId = split("/").last;
      return "https://www.youtube.com/embed/$videoId?autoplay=1&controls=1&playsinline=1";
    }
    return this;
  }
}




