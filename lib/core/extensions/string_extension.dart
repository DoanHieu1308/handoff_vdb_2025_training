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

  //
}


