import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/shared_pref/shared_preference_helper.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/create_post_store.dart';
import 'package:mobx/mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../core/utils/app_constants.dart';
import '../../../data/model/post/post_output_model.dart';
import '../profile/pages/profile_page/profile_store.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore with Store {
  /// Repository
  final _postRepository = AppInit.instance.postRepository;

  /// Store
  final ProfileStore profileStore = AppInit.instance.profileStore;
  CreatePostStore get createPostStore => AppInit.instance.createPostStore;

  /// Controller
  final RefreshController refreshController = RefreshController(initialRefresh: false);

  /// Shared Preference
  final SharedPreferenceHelper sharedPreferenceHelper = AppInit.instance.sharedPreferenceHelper;

  /// Post
  @observable
  bool isLoadingPost = false;

  @observable
  ObservableList<PostOutputModel> allPostsPublic = ObservableList();
  @observable
  ObservableList<PostOutputModel> allPostsFriend = ObservableList();
  @observable
  int currentPage = 1;
  @observable
  bool hasMore = true;

  /// Clear post message
  @action
  void clearPostMessage() {
    createPostStore.postMessage = '';
    createPostStore.isPostSuccess = false;
  }

  ///
  /// Init
  ///
  Future<void> init() async {
    await getALlPosts(type: PUBLIC);
  }

  ///------------------------------------------------------------
  /// Dispose
  ///
  void disposeAll() {
    // Dispose controller
    refreshController.dispose();

    // Reset observable values
    isLoadingPost = false;
    createPostStore.isPostSuccess = false;
    currentPage = 1;
    hasMore = true;

    // Clear lists
    allPostsPublic.clear();
    allPostsFriend.clear();
  }


  ///
  /// Get all list post
  ///
  Future<void> getALlPosts({
    required String type
  }) async {
    currentPage = 1;
    hasMore = true;

    await _postRepository.getAllPosts(
      page: currentPage,
      limit: 10,
      type: type,
      onSuccess: (result) {
        if(type == PUBLIC){
          allPostsPublic = ObservableList.of(result.data);
        }else{
          allPostsFriend = ObservableList.of(result.data);
        }
        hasMore = currentPage < result.pagination.totalPages;
        refreshController.refreshCompleted();
        refreshController.loadComplete();
      },
      onError: (error) {
        refreshController.refreshFailed();
      },
    );
  }

  Future<void> getMorePosts({
    required String type
  }) async {
    if (!hasMore) {
      refreshController.loadNoData();
      return;
    }

    final nextPage = currentPage + 1;

    await _postRepository.getAllPosts(
      type: type,
      limit: 10,
      page: nextPage,
      onSuccess: (result) {
        if(type == PUBLIC){
          allPostsPublic.addAll(result.data);
        }else{
          allPostsFriend.addAll(result.data);
        }
        currentPage = result.pagination.page;
        hasMore = currentPage < result.pagination.totalPages;

        if (hasMore) {
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

  /// Lấy top 2 biểu tượng cảm xúc được thả nhiều nhất
  @action
  List<String> getTop2Reactions(PostOutputModel postData) {
    final feelCount = postData.feelCount;
    if (feelCount != null && feelCount.isNotEmpty) {
      final filtered = feelCount.entries
          .where((e) => e.value > 0 && e.key != "unLike")
          .toList();

      if (filtered.isEmpty) return [];

      filtered.sort((a, b) => b.value.compareTo(a.value));

      if (filtered.length == 1) {
        return [filtered.first.key, ""];
      }

      return filtered.take(2).map((e) => e.key).toList();
    }
    return [];
  }

  /// Tổng số lượng cảm xúc
  @action
  int getTotalFeelCount(Map<String, dynamic>? feelCount) {
    if (feelCount == null || feelCount.isEmpty) return 0;

    return feelCount.values.fold<int>(
      0, (prev, element) => prev + (element is int ? element : 0),
    );
  }
}