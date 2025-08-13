import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:handoff_vdb_2025/core/enums/auth_enums.dart';
import 'package:handoff_vdb_2025/core/extensions/dynamic_extension.dart';
import 'package:handoff_vdb_2025/core/extensions/string_extension.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';
import 'package:handoff_vdb_2025/data/model/post/post_input_model.dart';
import 'package:handoff_vdb_2025/data/repositories/post_repository.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/stores/link_preview_store/link_preview_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/stores/media_store/media_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/stores/text_store/text_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/home/home_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/profile/pages/profile_page/profile_store.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/cupertino.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart' as ul;
import 'package:video_player/video_player.dart';
import '../../../core/utils/images_path.dart';
import '../../../data/model/post/post_link_meta.dart';
import '../../../data/model/post/post_output_model.dart';
import '../../widget/custom_dialog.dart';
import '../create_post_advanced_options_setting/create_post_advanced_options_setting_store.dart';
import '../profile/pages/profile_picture_camera/profile_picture_camera_store.dart';

part 'create_post_store.g.dart';

class CreatePostStore = _CreatePostStore with _$CreatePostStore;

abstract class _CreatePostStore with Store {
  /// Store
  final HomeStore homeStore = AppInit.instance.homeStore;
  final ProfileStore profileStore = AppInit.instance.profileStore;
  CreatePostAdvancedOptionSettingStore get createPostAdvancedOptionSettingStore => AppInit.instance.createPostAdvancedOptionSettingStore;

  /// Sub store
   LinkPreviewStore get linkPreviewStore => AppInit.instance.linkPreviewStore;
   MediaStore get mediaStore => AppInit.instance.mediaStore;
   TextStore get textStore => AppInit.instance.textStore;

  /// Controller
  final DraggableScrollableController controllerDraggableScrollable = DraggableScrollableController();

  /// Repository
  final PostRepository postRepository = AppInit.instance.postRepository;

  /// Focus node
  final FocusNode feelingFocusNode = FocusNode();

  /// Edit post
  @observable
  bool isLoadingEditPost = false;

  /// Receive link from youtube
  @observable
  String? _sharedText;

  /// Value
  @observable
  double initialChildSize = 0.5;

  /// Init
  Future<void> init() async {
    textStore.init();
    feelingFocusNode.addListener(() {
      if (feelingFocusNode.hasFocus) {
        initialChildSize = 0.2;
      } else {
        initialChildSize = 0.5;
      }
    });
  }

  /// Dispose
  void dispose() {
    linkPreviewStore.dispose();
    mediaStore.dispose();
    textStore.dispose();
  }


  /// List item detail all
  @observable
  ObservableList<Map<String, dynamic>> listNameItemDraggable =
      ObservableList.of([
        {'name': "Ảnh/Video", 'image': ImagesPath.icPhotos, 'valueNumber': 1},
        {
          'name': "Gắn thẻ người khác",
          'image': ImagesPath.icTag,
          'valueNumber': 2,
        },
        {
          'name': "Cảm xúc/hoạt động",
          'image': ImagesPath.icFeeling,
          'valueNumber': 3,
        },
        {'name': "Check in ", 'image': ImagesPath.icCheckIn, 'valueNumber': 4},
        {
          'name': "Video trực tiếp",
          'image': ImagesPath.icVideoCamera,
          'valueNumber': 5,
        },
        {
          'name': "Màu nền",
          'image': ImagesPath.icBackGroundColor,
          'valueNumber': 6,
        },
        {'name': "Camera", 'image': ImagesPath.icCameraColor, 'valueNumber': 7},
        {'name': "Nhạc", 'image': ImagesPath.icMusic, 'valueNumber': 8},
      ]);


  /// OnTap option draggable
  @action
  void onTapOptionDraggable(BuildContext context, int index) {
    final value = listNameItemDraggable[index]['valueNumber'];
    print(value);

    switch (value) {
      case 1:
        mediaStore.showDialogSelectImageOrVideo(context);
        break;
      case 2:
        context.push(AuthRoutes.TAG_FRIEND);
        break;
      case 3:
        break;
      case 4:
        break;
      case 5:
        break;
      case 6:
        break;
      case 7:
        break;
      case 8:
        break;
      default:
        break;
    }
  }


  /// reset value
  @action
  void resetPostForm() {
    // Temporarily remove listener to avoid triggering during reset
    if (textStore.textListener != null) {
      textStore.feelingEditingController.removeListener(textStore.textListener!);
    }
    
    // Clear text input
    textStore.feelingEditingController.text = '';
    textStore.fellingText = '';
    textStore.hasText = false;

    // Clear hashtags
    textStore.hashtags.clear();

    // Clear images/videos
    mediaStore.listFile.clear();
    mediaStore.imageListUrl.clear();
    mediaStore.videoListUrl.clear();
    mediaStore.hasImage = false;
    mediaStore.hasVideo = false;

    // Clear video controller if used
    try {
      mediaStore.videoController?.dispose();
    } catch (e) {
      print('Error disposing video controller in reset: $e');
    }
    mediaStore.videoController = null;

    // Clear link preview
    linkPreviewStore.detectedLink = null;
    linkPreviewStore.previewData = PostLinkMeta();
    linkPreviewStore.hasLink = false;
    linkPreviewStore.debounce?.cancel();
    linkPreviewStore.debounce = null;
    linkPreviewStore.isLoadingPreview = false;

    // Reset scroll position
    if (mediaStore.scrollController.hasClients) {
      mediaStore.scrollController.jumpTo(0);
    }
    
    if (controllerDraggableScrollable.isAttached) {
      controllerDraggableScrollable.animateTo(
        initialChildSize,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }

    // Reset focus
    feelingFocusNode.unfocus();
    createPostAdvancedOptionSettingStore.reset();
    
    // Re-add listener after reset to ensure it works properly
    if (textStore.textListener != null) {
      textStore.feelingEditingController.addListener(textStore.textListener!);
    }
  }


  /// Post status
  Future<void> postCreate(BuildContext context) async {
    // Set loading state immediately for better UX
    homeStore.isLoadingPost = true;
    homeStore.postMessage = '';

    // Add a small delay to show loading UI
    await Future.delayed(Duration(milliseconds: 1000));

    await mediaStore.uploadAllFilesAndSplit();

    PostInputModel postInputModel = PostInputModel();
    postInputModel.title = textStore.feelingEditingController.text;
    postInputModel.content = "ahihi";
    postInputModel.privacy = createPostAdvancedOptionSettingStore.currentStatus;
    postInputModel.hashtags = textStore.hashtags;
    postInputModel.friendsTagged = createPostAdvancedOptionSettingStore.tagFriendList
        .map((u) => u.name?.trim())
        .where((n) => n != null && n.isNotEmpty)
        .map((n) => n!)
        .toList();
    postInputModel.images = mediaStore.imageListUrl;
    postInputModel.videos = mediaStore.videoListUrl;
    postInputModel.postLinkMeta = linkPreviewStore.previewData;

    await postRepository.postStatus(
        data: postInputModel,
        onSuccess: (data) async {
          homeStore.isLoadingPost = false;
          homeStore.postMessage = "Đăng bài viết thành công!";
          homeStore.isPostSuccess = true;
          // Reload feed on Home
          await homeStore.getALlPosts(type: PUBLIC);

          resetPostForm();
        },
        onError: (error) async {
          homeStore.isLoadingPost = false;
          homeStore.postMessage = "Đăng bài viết thất bại!";
          homeStore.isPostSuccess = false;

          resetPostForm();
          print("loi o preview link  $error");
        }
    );
  }

  /// Post status
  Future<void> editPostStatus({
    required PostOutputModel itemEdit,
    required Function() onSuccess,
    required Function(dynamic error) onError
  }) async {
    feelingFocusNode.unfocus();
    isLoadingEditPost = true;

    // Chỉ cập nhật nếu có thay đổi
    if (textStore.feelingEditingController.text.trim().isNotEmpty &&
        textStore.feelingEditingController.text.trim() != itemEdit.title) {
      itemEdit.title = textStore.feelingEditingController.text.trim();
    }

    if (createPostAdvancedOptionSettingStore.currentStatus != itemEdit.privacy) {
      itemEdit.privacy = createPostAdvancedOptionSettingStore.currentStatus;
    }

    final newHashtags = textStore.hashtags;
    if (newHashtags.isNotEmpty && newHashtags != itemEdit.hashtags) {
      itemEdit.hashtags = newHashtags;
    }

    final newTaggedFriends = createPostAdvancedOptionSettingStore.tagFriendList
        .map((u) => u.name?.trim())
        .where((n) => n != null && n.isNotEmpty)
        .map((n) => n!)
        .toList();
    if (newTaggedFriends.isNotEmpty && newTaggedFriends != itemEdit.friendsTagged) {
      itemEdit.friendsTagged = newTaggedFriends;
    }

    await mediaStore.uploadAllFilesAndSplit();

    if (mediaStore.imageListUrl.isNotEmpty && mediaStore.imageListUrl != itemEdit.images) {
      itemEdit.images = mediaStore.imageListUrl;
    }

    if (mediaStore.videoListUrl.isNotEmpty && mediaStore.videoListUrl != itemEdit.videos) {
      itemEdit.videos = mediaStore.videoListUrl;
    }

    if (linkPreviewStore.previewData != null && linkPreviewStore.previewData != itemEdit.postLinkMeta) {
      itemEdit.postLinkMeta = linkPreviewStore.previewData;
    }

    await postRepository.editPostStatus(
      data: itemEdit,
      onSuccess: (data) async {
        await profileStore.loadInitialPostsByUserId();

        isLoadingEditPost = false;
        onSuccess();
      },
      onError: (error) async {
        print("Lỗi khi cập nhật bài viết: $error");

        isLoadingEditPost = false;
        onError(error);
      },
    );
  }

  /// Open Url
  Future<void> openUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;

    if (await ul.canLaunchUrl(uri)) {
      await ul.launchUrl(uri, mode: ul.LaunchMode.externalApplication);
    }
  }

}
