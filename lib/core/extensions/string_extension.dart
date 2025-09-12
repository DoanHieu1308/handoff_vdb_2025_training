extension StringExtension on String {
  /// Check video file
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

  /// Check image file
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

  /// Check only emoji
  bool get isOnlyEmoji {
    final trimmed = trim();
    if (trimmed.isEmpty) return false;

    final emojiRegex = RegExp(
      r'^(?:[\u{1F600}-\u{1F64F}' // Emoticons
      r'\u{1F300}-\u{1F5FF}'     // Symbols & Pictographs
      r'\u{1F680}-\u{1F6FF}'     // Transport & Map
      r'\u{2600}-\u{26FF}'       // Misc symbols
      r'\u{2700}-\u{27BF}'       // Dingbats
      r'\u{1F900}-\u{1F9FF}'     // Supplemental Symbols and Pictographs
      r'\u{1FA70}-\u{1FAFF}'     // Symbols and Pictographs Extended-A
      r'\u{200D}'                // Zero Width Joiner
      r'\u{2640}\u{2642}'        // Gender symbols
      r'\u{FE0F}'                // Variation Selector
      r']+$)',
      unicode: true,
    );

    return emojiRegex.hasMatch(trimmed);
  }
}




