import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:handoff_vdb_2025/core/enums/auth_enums.dart';
import 'package:handoff_vdb_2025/core/extensions/string_extension.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';
import 'package:handoff_vdb_2025/core/utils/navigation_helper.dart';
import 'package:handoff_vdb_2025/data/model/post/post_input_model.dart';
import 'package:handoff_vdb_2025/data/repositories/post_repository.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/stores/link_preview_store/link_preview_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/stores/media_store/media_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/stores/text_store/text_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/home/home_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/profile/pages/profile_page/profile_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:hive/hive.dart';
import 'package:mobx/mobx.dart';
import 'package:url_launcher/url_launcher.dart' as ul;
import '../../../core/shared_pref/shared_preference_helper.dart';
import '../../../core/utils/images_path.dart';
import '../../../data/model/post/post_link_meta.dart';
import '../../../data/model/post/post_output_model.dart';
import '../../widget/select_dialog_widget.dart';
import '../create_post_advanced_options_setting/create_post_advanced_options_setting_store.dart';

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

  /// Shared Preference
  final SharedPreferenceHelper sharedPreferenceHelper = AppInit.instance.sharedPreferenceHelper;

  /// Focus node
  FocusNode? _feelingFocusNode;
  FocusNode get feelingFocusNode => _feelingFocusNode ??= FocusNode();

  /// Network subscription
  StreamSubscription<List<ConnectivityResult>>? _networkSub;
  bool _networkListenerInitialized = false;

  /// Edit post
  @observable
  bool isLoadingEditPost = false;

  /// Received value
  @observable
  bool isReceivedValue = false;

  /// Receive link from youtube
  @observable
  String? _sharedText;

  /// Value
  @observable
  double initialChildSize = 0.5;
  @observable
  String postMessage = '';
  @observable
  bool isPostSuccess = false;

  /// Init
  Future<void> init() async {
    try {
      textStore.init();
      
      // Ensure we have a valid focus node
      _feelingFocusNode ??= FocusNode();
      
      // Remove any existing listener first
      try {
        _feelingFocusNode!.removeListener(_onFocusChanged);
      } catch (e) {
        // Focus node was disposed, create a new one
        _feelingFocusNode = FocusNode();
      }
      // Add focus listener safely
      _feelingFocusNode!.addListener(_onFocusChanged);
      // Network listener (only once)
      _initNetworkListenerOnce();
    } catch (e) {
      print('Error in init: $e');
      // Reset focus node if there's an error
      _feelingFocusNode = null;
    }
  }

  ///
  void _initNetworkListenerOnce() {
    if (_networkListenerInitialized) return;
    _networkListenerInitialized = true;

    final connectivity = Connectivity();
    _networkSub = connectivity.onConnectivityChanged.listen((result) async {
      if (result != ConnectivityResult.none) {
        await retryPendingPosts();
      }
    });
  }

  ///------------------------------------------------------------
  /// Dispose
  ///
  void disposeAll() {
  }

  /// Focus change handler
  void _onFocusChanged() {
    try {
      if (feelingFocusNode.hasFocus) {
        initialChildSize = 0.2;
      } else {
        initialChildSize = 0.5;
      }
    } catch (e) {
      print('Error in focus listener: $e');
    }
  }

  /// Dispose
  void dispose() {
    try {
      // Remove focus listener first
      if (_feelingFocusNode != null) {
        _feelingFocusNode!.removeListener(_onFocusChanged);
      }
      
      // Dispose sub stores
      linkPreviewStore.dispose();
      mediaStore.dispose();
      textStore.dispose();
      
      // Dispose draggable controller safely
      try {
        if (controllerDraggableScrollable.isAttached) {
          controllerDraggableScrollable.dispose();
        }
      } catch (e) {
        print('Error disposing draggable controller: $e');
      }
    } catch (e) {
      print('Error in dispose: $e');
    }
  }

  /// Dispose focus node when needed (call this when app is shutting down)
  void disposeFocusNode() {
    try {
      if (_feelingFocusNode != null) {
        _feelingFocusNode!.removeListener(_onFocusChanged);
        _feelingFocusNode!.dispose();
        _feelingFocusNode = null;
      }
    } catch (e) {
      print('Error disposing focus node: $e');
    }
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
        NavigationHelper.navigateTo(context, AuthRoutes.TAG_FRIEND);
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
    try {
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

      // Reset scroll position safely
      try {
        if (mediaStore.scrollController.hasClients) {
          mediaStore.scrollController.jumpTo(0);
        }
      } catch (e) {
        print('Error resetting scroll position: $e');
      }
      
      // Reset draggable controller safely
      try {
        if (controllerDraggableScrollable.isAttached) {
          controllerDraggableScrollable.animateTo(
            initialChildSize,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      } catch (e) {
        print('Error resetting draggable controller: $e');
      }

      // Reset focus safely - create new focus node if needed
      try {
        if (_feelingFocusNode != null) {
          try {
            if (_feelingFocusNode!.canRequestFocus) {
              _feelingFocusNode!.unfocus();
            }
          } catch (e) {
            print('Focus node disposed, creating new one: $e');
            _feelingFocusNode!.removeListener(_onFocusChanged);
            _feelingFocusNode = null;
          }
        }
      } catch (e) {
        print('Error handling focus in reset: $e');
        _feelingFocusNode = null;
      }
      
      createPostAdvancedOptionSettingStore.reset();

      if (textStore.textListener != null) {
        textStore.feelingEditingController.addListener(textStore.textListener!);
      }
    } catch (e) {
      print('Error in resetPostForm: $e');
    }
  }

  /// Save offline (fill userId + classify media by extension)
  Future<void> savePostOffline(PostInputModel post) async {
    try {
      if ((post.images == null || post.images!.isEmpty) &&
          mediaStore.listFile.isNotEmpty) {
        post.images = mediaStore.listFile
            .whereType<File>()
            .where((f) => f.path.isImageFile)
            .map((f) => f.path)
            .toList();
      }

      if ((post.videos == null || post.videos!.isEmpty) &&
          mediaStore.listFile.isNotEmpty) {
        post.videos = mediaStore.listFile
            .whereType<File>()
            .where((f) => f.path.isVideoFile)
            .map((f) => f.path)
            .toList();
      }

      final currentUserId = sharedPreferenceHelper.getIdUser;
      if (currentUserId != null && currentUserId.isNotEmpty) {
        post.userId = currentUserId;
      }

      final box = await Hive.openBox<PostInputModel>('pending_posts');
      await box.add(post);
      debugPrint("Đã lưu post offline vào Hive (đã gắn userId & phân loại media).");
    } catch (e) {
      debugPrint('savePostOffline error: $e');
    }
  }


  /// Retry pending posts (safe: iterate backwards, check network, aggregate message)
  Future<void> retryPendingPosts() async {
    try {
      final currentUserId = sharedPreferenceHelper.getIdUser;
      if (currentUserId == null || currentUserId.isEmpty) return;

      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) return;

      final box = await Hive.openBox<PostInputModel>('pending_posts');
      int successCount = 0;
      int failCount = 0;

      for (int i = box.length - 1; i >= 0; i--) {
        final post = box.getAt(i);
        if (post == null) continue;

        if (post.userId != currentUserId) continue;

        try {
          // Upload local images nếu còn đường dẫn local
          if (post.images != null && post.images!.isNotEmpty) {
            final uploaded = <String>[];
            for (final path in post.images!) {
              final file = File(path);
              if (await file.exists()) {
                await postRepository.uploadFileMultipart(
                  file: file,
                  onSuccess: (url) => uploaded.add(url),
                  onError: (err) => debugPrint("Upload image (offline) error: $err"),
                );
              } else {
                if (path.startsWith('http://') || path.startsWith('https://')) {
                  uploaded.add(path);
                }
              }
            }
            post.images = uploaded;
          }

          // Upload local videos nếu còn đường dẫn local
          if (post.videos != null && post.videos!.isNotEmpty) {
            final uploaded = <String>[];
            for (final path in post.videos!) {
              final file = File(path);
              if (await file.exists()) {
                await postRepository.uploadFileMultipart(
                  file: file,
                  onSuccess: (url) => uploaded.add(url),
                  onError: (err) => debugPrint("Upload video (offline) error: $err"),
                );
              } else {
                if (path.startsWith('http://') || path.startsWith('https://')) {
                  uploaded.add(path);
                }
              }
            }
            post.videos = uploaded;
          }

          // Check mạng lần nữa trước khi call API
          final netNow = await Connectivity().checkConnectivity();
          if (netNow == ConnectivityResult.none) {
            failCount++;
            continue;
          }

          // Gửi post
          await postRepository.createPost(
            data: post,
            onSuccess: () async {
              successCount++;
              await box.deleteAt(i);
            },
            onError: (error) {
              debugPrint("Post offline lỗi: $error");
              failCount++;
            },
          );
        } catch (e) {
          debugPrint("Exception khi retry post: $e");
          failCount++;
        }
      }

      if (successCount > 0 || failCount > 0) {
        postMessage =
        "Khôi phục offline: thành công $successCount, lỗi $failCount.";
        isPostSuccess = successCount > 0 && failCount == 0;
      }
    } catch (e) {
      debugPrint('retryPendingPosts tổng lỗi: $e');
    }
  }

  /// Listen network
  void listenNetwork() => _initNetworkListenerOnce();

  /// Post status
  Future<void> postCreate(BuildContext context) async {
    try {
      homeStore.isLoadingPost = true;
      profileStore.isLoadingPost = true;
      isPostSuccess = false;
      postMessage = '';

      // Add a small delay to show loading UI
      await Future.delayed(const Duration(milliseconds: 1000));

      await mediaStore.uploadAllFilesAndSplit();

      PostInputModel postInputModel = PostInputModel();
      postInputModel.title = textStore.feelingEditingController.text;
      postInputModel.content = "ahihi";
      postInputModel.privacy = createPostAdvancedOptionSettingStore.currentStatus;
      postInputModel.hashtags = textStore.hashtags;
      postInputModel.friends_tagged = (createPostAdvancedOptionSettingStore.tagFriendList ?? [])
          .map((u) => u.id?.trim())
          .whereType<String>()
          .where((n) => n.isNotEmpty)
          .toList();
      postInputModel.images = mediaStore.imageListUrl;
      postInputModel.videos = mediaStore.videoListUrl;
      postInputModel.postLinkMeta = linkPreviewStore.previewData;

      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) {
        // Không có mạng -> lưu offline
        await savePostOffline(postInputModel);
        postMessage = "Không có mạng. Bài viết đã lưu offline và sẽ đăng khi có mạng.";
        isPostSuccess = false;
        resetPostForm();
        return;
      }

      await postRepository.createPost(
        data: postInputModel,
        onSuccess: () async {
          postMessage = "Đăng bài viết thành công!";
          isPostSuccess = true;

          // Reload feed on Home
          await homeStore.getALlPosts(type: PUBLIC);
          await profileStore.loadInitialPostsByUserId();

          resetPostForm();
        },
        onError: (error) async {
          // API lỗi → lưu offline
          postMessage = "Đăng bài viết thất bại! Bài viết đã lưu offline.";
          isPostSuccess = false;
          await savePostOffline(postInputModel);
          resetPostForm();
          print("Lỗi khi post: $error");
        },
      );
    } catch (e, s) {
      postMessage = "Đã xảy ra lỗi không mong muốn! Không thể đăng. Bài viết đã lưu offline.";
      isPostSuccess = false;
      print("Exception khi tạo post: $e\n$s");
      await savePostOffline(PostInputModel(
        // id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: textStore.feelingEditingController.text.trim(),
        content: "Ahihi",
        privacy: createPostAdvancedOptionSettingStore.currentStatus,
        hashtags: textStore.hashtags,
        friends_tagged: (createPostAdvancedOptionSettingStore.tagFriendList ?? [])
            .map((u) => u.id?.trim())
            .whereType<String>()
            .where((n) => n.isNotEmpty)
            .toList(),
        images: mediaStore.imageListUrl,
        videos: mediaStore.videoListUrl,
        postLinkMeta: linkPreviewStore.previewData,
      ));
    } finally {
      homeStore.isLoadingPost = false;
      profileStore.isLoadingPost = false;
    }
  }

  /// Edit post
  Future<void> editPostStatus({
    required PostOutputModel itemEdit,
    required Function() onSuccess,
    required Function(dynamic error) onError
  }) async {
    // Unfocus safely
    try {
      if (_feelingFocusNode != null) {
        try {
          if (_feelingFocusNode!.canRequestFocus) {
            _feelingFocusNode!.unfocus();
          }
        } catch (e) {
          // Focus node is disposed, ignore
          print('Focus node disposed in editPostStatus: $e');
        }
      }
    } catch (e) {
      print('Error handling focus in editPostStatus: $e');
    }
    
    isLoadingEditPost = true;

    // Chỉ cập nhật nếu có thay đổi
    if (textStore.feelingEditingController.text.trim().isNotEmpty &&
        textStore.feelingEditingController.text.trim() != itemEdit.title) {
      itemEdit.title = textStore.feelingEditingController.text.trim();
    }
    itemEdit.content = "ahihi";

    if (createPostAdvancedOptionSettingStore.currentStatus != itemEdit.privacy) {
      itemEdit.privacy = createPostAdvancedOptionSettingStore.currentStatus;
    }

    final newHashtags = textStore.hashtags;
    if (newHashtags.isNotEmpty && newHashtags != itemEdit.hashtags) {
      itemEdit.hashtags = newHashtags;
    }

    final newTaggedFriends = createPostAdvancedOptionSettingStore.tagFriendList;
    if (newTaggedFriends.isNotEmpty && newTaggedFriends != itemEdit.friendsTagged) {
      itemEdit.friendsTagged = createPostAdvancedOptionSettingStore.tagFriendList;
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
        await homeStore.getALlPosts(type: PUBLIC);

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

  /// Show dialog action back
  void showDialogSelectActionBack({required BuildContext context, required VoidCallback onOption1Tap, required VoidCallback onOption2Tap}) {
    showDialog(
      context: context,
      builder: (context) {
        return SelectDialogWidget(
          titleText: "Bạn có chắc muốn thoát?",
          option1Text: "Huỷ bỏ bài viết",
          option2Text: "Tiếp tục chỉnh sửa",
          onOption1Tap: onOption1Tap,
          onOption2Tap: onOption2Tap,
          showIcon: false,
        );
      },
    );
  }

}
