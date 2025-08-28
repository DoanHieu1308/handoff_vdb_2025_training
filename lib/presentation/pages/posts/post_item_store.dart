import 'package:flutter/cupertino.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:handoff_vdb_2025/core/extensions/string_extension.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';
import 'package:handoff_vdb_2025/data/model/post/post_comment_model.dart';
import 'package:handoff_vdb_2025/data/model/post/post_feels.dart';
import 'package:handoff_vdb_2025/data/model/post/post_output_model.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/create_post_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post_advanced_options_setting/create_post_advanced_options_setting_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/friends_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/home/home_store.dart';
import 'package:mobx/mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../data/repositories/post_repository.dart';
import '../../../core/utils/images_path.dart';
import '../profile/pages/profile_page/profile_store.dart';
part 'post_item_store.g.dart';

class PostItemStore = _PostItemStore with _$PostItemStore;

abstract class _PostItemStore with Store {
  /// Controller
  final ScrollController scrollImageController = ScrollController();
  final ScrollController scrollCommentController = ScrollController();
  final feelingEditingController = TextEditingController();
  final RefreshController refreshController = RefreshController(initialRefresh: false);

  /// key để quản lý FlutterMentions
  final GlobalKey<FlutterMentionsState> mentionKey = GlobalKey<FlutterMentionsState>();

  /// FocusNode
  final FocusNode commentFocusNode = FocusNode();

  /// Store
  final CreatePostStore createPostStore = AppInit.instance.createPostStore;
  final ProfileStore profileStore = AppInit.instance.profileStore;
  final HomeStore homeStore = AppInit.instance.homeStore;
  final FriendsStore friendsStore = AppInit.instance.friendsStore;
  CreatePostAdvancedOptionSettingStore get postOptionsSettingStore => AppInit.instance.createPostAdvancedOptionSettingStore;

  /// Repository
  final PostRepository _postRepository = AppInit.instance.postRepository;

  /// Text
  @observable
  ObservableList<String> hashtags = ObservableList();

  /// Comment
  @observable
  String commentParentId = "";
  @observable
  String commentUserName = "";
  @observable
  bool hasTextComment = false;
  VoidCallback? commentTextListener;
  @observable
  ObservableList<PostCommentModel> commentList = ObservableList<PostCommentModel>();
  @observable
  int currentCommentPage = 1;
  @observable
  bool hasMoreComments = true;
  final Map<String, GlobalKey> commentKeys = {};

  /// Bottom sheet
  @observable
  bool isShowBottomSheet = false;

  final Map<String, String> reactionNames = {
    "unLike": ImagesPath.icLike,
    "like": ImagesPath.emojiLike,
    "love": ImagesPath.emojiLove,
    "haha": ImagesPath.emojiHaha,
    "wow": ImagesPath.emojiWow,
    "sad": ImagesPath.emojiSad,
    "angry": ImagesPath.emojiAngry,
  };

  final Map<String, String> feelNames = {
    "like": ImagesPath.icLikePost,
    "love": ImagesPath.icLovePost,
    "haha": ImagesPath.icHahaPost,
    "wow": ImagesPath.icWowPost,
    "sad": ImagesPath.icSadPost,
    "angry": ImagesPath.icAngryPost,
  };

  /// Init
  Future<void> init() async {}

  ///------------------------------------------------------------
  /// Dispose
  ///
  void disposeAll() {
    // Dispose controllers
    scrollImageController.dispose();
    feelingEditingController.dispose();

    // Clear observable data
    hashtags.clear();
    commentList.clear();

    // Reset bottom sheet state
    isShowBottomSheet = false;
    hasTextComment = false;
  }

  ///
  /// Comment
  ///
  /// lấy text hiện tại
  String get commentText {
    return mentionKey.currentState?.controller?.text ?? "";
  }

  /// set text thủ công (ví dụ khi reply @User)
  void setMentionText(String text) {
    mentionKey.currentState?.controller?.text = text;
    commentFocusNode.requestFocus();
  }

  /// Comment view
  @action
  void initMentionListener({bool force = false}) {
    final controller = mentionKey.currentState?.controller;
    if (controller == null) return;

    if (force && commentTextListener != null) {
      controller.removeListener(commentTextListener!);
      commentTextListener = null;
    }

    if (commentTextListener == null) {
      commentTextListener = () {
        final text = controller.text;
        hasTextComment = text.trim().isNotEmpty;
      };
      controller.addListener(commentTextListener!);
    }
  }

  /// Add feel icon
  Future<void> dropEmoji({
    required String postId,
    required String iconName,
    required Function() onSuccess,
    required Function(dynamic error) onError
  }) async {
    await _postRepository.addFeelIcon(
        postId: postId,
        iconName: iconName,
        onSuccess: () {
          onSuccess();
          print("them bieu tuong $iconName thanh cong");
        },
        onError: (error){
          onError(error);
          print("them bieu tuong $iconName that bai");
        }
    );
  }

  /// Cập nhật reaction cho bất kỳ danh sách posts nào
  @action
  void updateReactionInPostsList({
    required String postId,
    required String selectedReaction,
    required ObservableList<PostOutputModel> postsList,
  }) {
    final postIndex = postsList.indexWhere((p) => p.id == postId);
    if (postIndex == -1) return;

    final post = postsList[postIndex];
    final oldReaction = post.myFeel;

    if (selectedReaction.isEmpty) {
      // Case 3: Unlike -> chỉ giảm reaction cũ
      if (oldReaction != null) {
        final oldCount = post.feelCount?[oldReaction] ?? 0;
        final updatedOldCount = oldCount - 1;
        if (updatedOldCount <= 0) {
          post.feelCount?.remove(oldReaction);
        } else {
          post.feelCount?[oldReaction] = updatedOldCount;
        }
      }
      post.myFeel = null;
    } else if (oldReaction == null) {
      // Case 1: Chưa từng react -> thêm mới
      final currentCount = post.feelCount?[selectedReaction] ?? 0;
      post.feelCount?[selectedReaction] = currentCount + 1;
      post.myFeel = selectedReaction;
    } else if (oldReaction != selectedReaction) {
      // Case 2: Đổi reaction -> tăng mới, giảm cũ
      final currentCount = post.feelCount?[selectedReaction] ?? 0;
      post.feelCount?[selectedReaction] = currentCount + 1;

      final oldCount = post.feelCount?[oldReaction] ?? 0;
      final updatedOldCount = oldCount - 1;
      if (updatedOldCount <= 0) {
        post.feelCount?.remove(oldReaction);
      } else {
        post.feelCount?[oldReaction] = updatedOldCount;
      }

      post.myFeel = selectedReaction;
    }

    // Cập nhật danh sách
    postsList.replaceRange(postIndex, postIndex + 1, [post]);
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
        onSuccess: () async {
          onSuccess();
          await profileStore.loadInitialPostsByUserId();
          await homeStore.getALlPosts(type: PUBLIC);
        },
        onError: (error){
          onError(error);
          print("loi o delete post $error");
        }
    );
  }

  /// Create comment post
  Future<void> createCommentPost({
    required String commentPostId,
    String? commentParentId,
    required Function() onSuccess,
    required Function(dynamic error) onError
  }) async {

    final commentContent = mentionKey.currentState?.controller?.text ?? "";
    final commentUserId = profileStore.userProfile.id ?? "";

    await _postRepository.createCommentPost(
        commentPostId: commentPostId,
        commentUserId: commentUserId,
        commentContent: commentContent,
        commentParentId: commentParentId ?? "",
        onSuccess: () {
          mentionKey.currentState?.controller?.text = "";
          onSuccess();
          print("comment thanh cong");
        },
        onError: (error){
          onError(error);
          print("loi o delete post $error");
        }
    );
  }

  /// Get page 1 comment
  Future<void> getCommentByPostId({
    required String commentPostId,
  }) async {
    currentCommentPage = 1;
    hasMoreComments = true;

    await _postRepository.getCommentByPostId(
      commentPostId: commentPostId,
      page: currentCommentPage,
      onSuccess: (data) {
        commentList = ObservableList.of(data);
        hasMoreComments = data.isNotEmpty;
        refreshController.refreshCompleted();
        refreshController.loadComplete();
      },
      onError: (error) {
        refreshController.refreshFailed();
      },
    );
  }


  /// Get more comment
  Future<void> getMoreComments({
    required String commentPostId,
  }) async {
    if (!hasMoreComments) {
      refreshController.loadNoData();
      return;
    }

    final nextPage = currentCommentPage + 1;

    await _postRepository.getCommentByPostId(
      commentPostId: commentPostId,
      page: nextPage,
      onSuccess: (data) {
        if (data.isNotEmpty) {
          commentList.addAll(data);
        }
        currentCommentPage = nextPage;
        hasMoreComments = data.isNotEmpty;

        if (hasMoreComments) {
          refreshController.loadComplete();
        } else {
          refreshController.loadNoData();
        }
      },
      onError: (error) {
        refreshController.loadFailed();
      },
    );
  }

  /// Delete comment
  Future<void> deleteComment({
    required String commentId,
    required Function() onSuccess,
    required Function(dynamic error) onError
  }) async {
    await _postRepository.deleteComment(
        commentId: commentId,
        onSuccess: () {
          _removeCommentFromList(commentList, commentId);
          onSuccess();
        },
        onError: (error){
          onError(error);
          print("loi o delete post $error");
        }
    );
  }

  /// Hàm đệ quy để tìm và xoá comment trong danh sách
  void _removeCommentFromList(List<PostCommentModel> list, String commentId) {
    for (int i = 0; i < list.length; i++) {
      final comment = list[i];

      if (comment.id == commentId) {
        list.removeAt(i);
        return;
      } else if (comment.replies != null && comment.replies!.isNotEmpty) {
        _removeCommentFromList(comment.replies!, commentId);

        if (comment.replies!.any((c) => c.id == commentId)) {
          return;
        }
      }
    }
  }

  /// Listen text hashtag
  void updateHashtagsFromText(String text) {
    final extracted = text.hashtags;
    hashtags
      ..clear()
      ..addAll(extracted);
  }

  /// Đếm số lượng comment còn lại
  int countAllChildren(PostCommentModel comment) {
    if (comment.replies == null || comment.replies!.isEmpty) return 0;

    int count = comment.replies!.length;
    for (var child in comment.replies!) {
      count += countAllChildren(child);
    }
    return count;
  }

  /// scroll to comment
  void scrollToComment(String commentId) {
    final key = commentKeys[commentId];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        alignment: 0.2,
      );
    }
  }
}
