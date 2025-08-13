import 'package:flutter/cupertino.dart';
import 'package:handoff_vdb_2025/core/extensions/string_extension.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/create_post_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post_advanced_options_setting/create_post_advanced_options_setting_store.dart';
import 'package:mobx/mobx.dart';

import '../../../../data/repositories/post_repository.dart';
import '../profile/pages/profile_page/profile_store.dart';
part 'post_item_store.g.dart';

class PostItemStore = _PostItemStore with _$PostItemStore;

abstract class _PostItemStore with Store {
  /// Controller
  final ScrollController scrollController = ScrollController();
  final feelingEditingController = TextEditingController();

  /// Store
  final CreatePostStore createPostStore = AppInit.instance.createPostStore;
  final ProfileStore profileStore = AppInit.instance.profileStore;
  CreatePostAdvancedOptionSettingStore get postOptionsSettingStore => AppInit.instance.createPostAdvancedOptionSettingStore;

  /// Repository
  final PostRepository _postRepository = AppInit.instance.postRepository;

  /// Text
  @observable
  ObservableList<String> hashtags = ObservableList();

  Future<void> init() async {
  }

  /// Add feel icon
  Future<void> dropEmoji({
    required String postId,
    required String iconName
  }) async {
    await _postRepository.addFeelIcon(
        postId: postId,
        iconName: iconName,
        onSuccess: () {
          print("them bieu tuong $iconName thanh cong");
        },
        onError: (error){
          print("them bieu tuong $iconName that bai");
        }
    );
  }

  ///
  /// Delete post
  ///
  Future<void> deletePost({
    required String postId,
    required Function() onSuccess,
    required Function(dynamic error) onError
  }) async {
    await _postRepository.deletePost(
        postId: postId,
        onSuccess: () {
          onSuccess();
        },
        onError: (error){
          onError(error);
          print("loi o delete post $error");
        }
    );
  }

  /// Listen text hashtag
  void updateHashtagsFromText(String text) {
    final extracted = text.hashtags;
    hashtags
      ..clear()
      ..addAll(extracted);
  }
}
