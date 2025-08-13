import 'dart:async';
import 'package:handoff_vdb_2025/core/extensions/string_extension.dart';
import 'package:handoff_vdb_2025/data/repositories/post_repository.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/create_post_store.dart';
import 'package:mobx/mobx.dart';

import '../../../../../data/model/post/post_link_meta.dart';

part 'link_preview_store.g.dart';

class LinkPreviewStore = _LinkPreviewStore with _$LinkPreviewStore;

abstract class _LinkPreviewStore with Store {
  /// Repository
  final PostRepository postRepository = AppInit.instance.postRepository;

  /// Link
  @observable
  String? detectedLink;
  @observable
  bool isLoadingPreview = false;
  @observable
  Timer? debounce;
  @observable
  PostLinkMeta previewData = PostLinkMeta();

  /// Store
  final CreatePostStore createPostStore;
  _LinkPreviewStore(this.createPostStore);

  /// Link
  @observable
  bool hasLink = false;

  /// Dispose
  void dispose() {
    debounce?.cancel();
  }

  /// Create post link
  @action
  void detectAndPreviewFirstLink(String text) {
    final link = text.firstLink;

    if (link != null && link != detectedLink) {
      detectedLink = link;
      isLoadingPreview = true;
      debounce?.cancel();
      debounce = Timer(const Duration(milliseconds: 400), () async {
        await previewLinkData(url: link);
        isLoadingPreview = false;
      });
    } else if (link == null && detectedLink != null) {
      detectedLink = null;
      isLoadingPreview = false;
    } else if (link == null) {
      isLoadingPreview = false;
    }

  }


  /// Preview link data
  Future<void> previewLinkData({
    required String url,
  }) async {

    await postRepository.previewLink(
        url: url,
        onSuccess: (data) {
          previewData = data;
        },
        onError: (error){
          print("loi o preview link  $error");
        }
    );
  }
}