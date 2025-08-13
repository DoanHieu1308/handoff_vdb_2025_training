import 'package:handoff_vdb_2025/core/init/app_init.dart';
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

  /// Controller
  final RefreshController refreshController = RefreshController(initialRefresh: false);

  /// Post
  @observable
  bool isLoadingPost = false;
  @observable
  String postMessage = '';
  @observable
  bool isPostSuccess = false;

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
    postMessage = '';
    isPostSuccess = false;
  }

  ///
  /// Init
  ///
  Future<void> init() async {
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
}