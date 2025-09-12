enum MessageContentType {
  image,
  text,
  voice,
  audio,
  video,
  custom;

  bool get isImage => this == image;
  bool get isText => this == text;
  bool get isVoice => this == voice;
  bool get isAudio => this == audio;
  bool get isVideo => this == video;
  bool get isCustom => this == custom;

  static MessageContentType? tryParse(String? value) {
    final type = value?.trim().toLowerCase();
    if (type?.isEmpty ?? true) return null;
    if (type == image.name) {
      return image;
    } else if (type == text.name) {
      return text;
    } else if (type == voice.name) {
      return voice;
    } else if (type == audio.name) {
      return audio;
    } else if (type == video.name) {
      return video;
    } else if (type == custom.name) {
      return custom;
    }
    return null;
  }
}


enum CustomMessageSubType {
  location,
  linkPreview,
  file,
  system,
  sticker,
  gif,
  poll,
  reaction;

  static CustomMessageSubType? tryParse(String? value) {
    final type = value?.trim().toLowerCase();
    if (type == null) return null;
    return CustomMessageSubType.values.firstWhere(
          (e) => e.name.toLowerCase() == type,
      orElse: () => CustomMessageSubType.system,
    );
  }
}