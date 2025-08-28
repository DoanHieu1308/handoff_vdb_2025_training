import 'dart:io';
import 'package:handoff_vdb_2025/core/enums/auth_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:handoff_vdb_2025/core/extensions/dynamic_extension.dart';
import 'package:handoff_vdb_2025/core/helper/app_divider.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/helper/size_util.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/data/model/post/post_output_model.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/component/create_post_bottom_bar.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/component/create_post_link.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/component/create_post_draggable_options.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/create_post_store.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import '../../widget/build_snackbar.dart';
import '../create_post_advanced_options_setting/create_post_advanced_option_setting.dart';
import 'component/button_post.dart';
import 'component/create_post_image_or_video.dart';
import 'component/create_post_text.dart';

class CreatePostPage extends StatefulWidget {
  final PostOutputModel? initialPost;
  const CreatePostPage({super.key, this.initialPost});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  CreatePostStore store = AppInit.instance.createPostStore;

  bool get isEditPost => widget.initialPost != null;

  bool _isSharedFilesChecked = false;

  // In Store
  bool get hasAnyContent =>
      store.textStore.hasText ||
      store.linkPreviewStore.hasLink ||
      store.mediaStore.hasImage ||
      store.mediaStore.hasVideo;

  void _mapPostData() {
    store.textStore.feelingEditingController.text =
        widget.initialPost?.title ?? '';
    store.mediaStore.listFile.clear();
    store.createPostAdvancedOptionSettingStore.currentStatus =
        widget.initialPost?.privacy ?? '';

    if (widget.initialPost!.images!.isNotEmpty) {
      store.mediaStore.hasImage = true;
      store.mediaStore.listFile.addAll(widget.initialPost!.images!);
    }
    if (widget.initialPost!.videos!.isNotEmpty) {
      store.mediaStore.hasVideo = true;
      store.mediaStore.listFile.addAll(widget.initialPost!.videos!);
    }
    if (widget.initialPost!.postLinkMeta != null) {
      store.linkPreviewStore.hasLink = true;
      store.linkPreviewStore.previewData = widget.initialPost!.postLinkMeta!;
    }
  }

  /// Check shared files from SharedPreferences
  Future<void> _checkSharedFilesFromPreferences() async {
    try {
      final sharedValues =
          store.homeStore.sharedPreferenceHelper.getReceivedValues;
      if (sharedValues == null || sharedValues.isEmpty) return;

      store.isReceivedValue = true;

      final List<SharedMediaFile> sharedFiles = [];

      for (final path in sharedValues) {
        final isVideo = path.isVideo;
        final isUrl = path.isUrl;

        if (!isVideo && !isUrl) {
          // Local gallery image
          final File originalFile = File(path);
          final imageResized = await store.mediaStore.resizeImageSync(originalFile);
          if (await imageResized.exists()) {
            final copiedFile = await store.mediaStore.copyToTempWithUniqueName(
              imageResized,
            );
            sharedFiles.add(
              SharedMediaFile(
                path: copiedFile.path,
                type: SharedMediaType.image,
              ),
            );
          }
        } else {
          // Video or URL
          sharedFiles.add(
            SharedMediaFile(
              path: path,
              type: isVideo
                      ? SharedMediaType.video
                      : (isUrl ? SharedMediaType.url : SharedMediaType.image),
            ),
          );
        }
      }

      if (sharedFiles.isNotEmpty) {
        store.mediaStore.handleSharedFiles(sharedFiles);
        // Show notification
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Đã nhận file được chia sẻ'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      // Clear after processing
      store.homeStore.sharedPreferenceHelper.clearReceivedValue();
    } catch (e) {
      print('Error checking shared files from preferences: $e');
    }
  }

  @override
  void initState() {
    super.initState();

    store.init();

    if (isEditPost) {
      _mapPostData();
    } else {
      store.resetPostForm();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        try {
          FocusScope.of(context).requestFocus(store.feelingFocusNode);
        } catch (e) {
          print('Error requesting focus: $e');
        }
      }
    });
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_isSharedFilesChecked) {
      _isSharedFilesChecked = true;
      await _checkSharedFilesFromPreferences();
    }
  }

  @override
  void dispose() {
    super.dispose();
    store.dispose();
  }

  /// Handle back navigation properly
  Future<bool> _onWillPop() async {
    if (hasAnyContent) {
      store.showDialogSelectActionBack(
        context: context,
        onOption1Tap: () {
          store.resetPostForm();
          context.pop();
        },
        onOption2Tap: () {
        },
      );
      return false;
    }

    // logic cũ
    store.resetPostForm();
    if (store.sharedPreferenceHelper.getReceivedValues != null) {
      store.isReceivedValue = false;
      store.sharedPreferenceHelper.clearReceivedValue();

      if (mounted) {
        context.go(AuthRoutes.DASH_BOARD);
        return true;
      }
    } else {
      context.pop();
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Observer(
        builder: (context) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.white,
                resizeToAvoidBottomInset: true,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  leading: GestureDetector(
                    onTap: () async {
                       _onWillPop();
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new_outlined,
                      size: 22,
                    ),
                  ),
                  title: Text(
                    isEditPost ? "Chỉnh sửa bài viết" : "Tạo bài viết",
                    style: AppText.text18,
                  ),
                  actions: [
                    Padding(
                      padding: EdgeInsets.only(right: 20.w),
                      child: Observer(
                        builder: (context) {
                          return GestureDetector(
                            onTap: () async {
                              if (isEditPost) {
                                if (hasAnyContent) {
                                  store.editPostStatus(
                                    itemEdit: widget.initialPost!,
                                    onSuccess: () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        buildSnackBarNotify(
                                          textNotify: "Thành công",
                                          backgroundColor: null,
                                        ),
                                      );
                                      if (mounted) {
                                        if (!store.isLoadingEditPost)
                                          context.pop();
                                      }
                                    },
                                    onError: (error) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        buildSnackBarNotify(
                                          textNotify: error,
                                          backgroundColor: null,
                                        ),
                                      );
                                    },
                                  );
                                }
                              } else {
                                if (hasAnyContent) {
                                  store.postCreate(context);
                                  if (mounted) {
                                    context.go(AuthRoutes.DASH_BOARD);
                                  }
                                }
                              }
                            },
                            child:
                                store.isLoadingEditPost
                                    ? const CircularProgressIndicator()
                                    : ButtonPost(
                                      name: isEditPost ? "LƯU" : "ĐĂNG",
                                      hasdata: hasAnyContent,
                                    ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                body: buildBody(),
              ),
              if (store.isLoadingEditPost)
                Container(
                  height: SizeUtil.getMaxHeight(),
                  width: SizeUtil.getMaxWidth(),
                  color: Colors.black26,
                ),
            ],
          );
        },
      ),
    );
  }

  Widget buildBody() {
    return Observer(
      builder: (context) {
        return Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  buildBodyPost(),
                  Visibility(
                    visible:
                        !store.textStore.hasText &&
                        !store.mediaStore.hasVideo &&
                        !store.mediaStore.hasImage,
                    child: CreatePostDraggableOptions(),
                  ),
                ],
              ),
            ),
            if (store.textStore.hasText ||
                store.mediaStore.hasImage ||
                store.mediaStore.hasVideo)
              CreatePostBottomBar(),
          ],
        );
      },
    );
  }

  Widget buildBodyPost() {
    return Observer(
      builder: (context) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              AppDivider.v5,
              CreatePostAdvancedOptionSetting(),
              Visibility(
                visible: store.mediaStore.hasImage || store.mediaStore.hasVideo,
                child: CreatePostImageOrVideo(
                  listFile: store.mediaStore.listFile,
                ),
              ),
              Visibility(
                visible:
                    !store.mediaStore.hasImage &&
                    !store.mediaStore.hasVideo &&
                    !store.linkPreviewStore.hasLink,
                child: CreatePostText(
                  feelingEditingController:
                      store.textStore.feelingEditingController,
                  hasText: store.textStore.hasText,
                  feelingFocusNode: store.feelingFocusNode,
                ),
              ),
              Visibility(
                visible: store.linkPreviewStore.hasLink,
                child: CreatePostLink(),
              ),
            ],
          ),
        );
      },
    );
  }
}
