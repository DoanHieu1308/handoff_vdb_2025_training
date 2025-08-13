import 'dart:io';

/// Extension để kiểm tra loại file và URL
extension DynamicExtension on dynamic {
  /// Kiểm tra xem có phải là URL không
  bool get isUrl {
    if (this is String) {
      return (this as String).startsWith('http://') ||
          (this as String).startsWith('https://');
    }
    return false;
  }

  /// Kiểm tra xem có phải là video file không
  bool get isVideo {
    final path = this is String
        ? (this as String)
        : (this is File ? (this as File).path : '');

    final ext = path.toLowerCase();
    return ext.endsWith('.mp4') ||
        ext.endsWith('.mov') ||
        ext.endsWith('.avi') ||
        ext.endsWith('.mkv');
  }

  /// Kiểm tra xem có phải là image file không
  bool get isImage {
    final path = this is String
        ? (this as String)
        : (this is File ? (this as File).path : '');

    final ext = path.toLowerCase();
    return ext.endsWith('.jpg') ||
        ext.endsWith('.jpeg') ||
        ext.endsWith('.png') ||
        ext.endsWith('.gif') ||
        ext.endsWith('.webp');
  }
}
