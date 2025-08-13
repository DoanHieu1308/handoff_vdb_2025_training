import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:handoff_vdb_2025/core/extensions/string_extension.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:mobx/mobx.dart';

import '../../create_post_store.dart';

part 'text_store.g.dart';

class TextStore = _TextStore with _$TextStore;

abstract class _TextStore with Store {
  /// Controller
  final feelingEditingController = TextEditingController();

  /// Store
  final linkPreviewStore = AppInit.instance.linkPreviewStore;

  /// Text
  @observable
  ObservableList<String> hashtags = ObservableList();
  VoidCallback? textListener;

  /// Text/Link
  @observable
  bool hasText = false;

  /// Text field
  @observable
  String fellingText = '';

  /// Store
  final CreatePostStore createPostStore;
  _TextStore(this.createPostStore);

  /// Init
  Future<void> init() async {
    // Nếu đã khởi tạo trước đó, gỡ listener cũ để tránh double add
    if (textListener != null) {
      feelingEditingController.removeListener(textListener!);
    }

    textListener = () {
      final text = feelingEditingController.text;
      fellingText = text;
      hasText = fellingText.isNotEmpty;
      linkPreviewStore.hasLink = text.hasLink;
      updateHashtagsFromText(text);
      linkPreviewStore.detectAndPreviewFirstLink(text);
    };
    feelingEditingController.addListener(textListener!);


  }

  /// Dispose
  void dispose() {
    if (textListener != null) {
      feelingEditingController.removeListener(textListener!);
    }
    textListener = null;
  }


  /// Listen text hashtag
  void updateHashtagsFromText(String text) {
    final extracted = text.hashtags;
    hashtags
      ..clear()
      ..addAll(extracted);
  }
}