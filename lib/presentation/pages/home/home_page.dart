import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';
import 'package:handoff_vdb_2025/presentation/pages/home/component/post_creation_progress.dart';
import 'package:handoff_vdb_2025/presentation/pages/home/component/friend_stories_list_component.dart';
import 'package:handoff_vdb_2025/presentation/pages/home/component/create_post_button.dart';
import 'package:handoff_vdb_2025/presentation/pages/home/home_store.dart';
import 'package:mobx/mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../core/utils/color_resources.dart';
import '../posts/post_item.dart';
import '../../widget/build_snackbar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>{
  final HomeStore store = AppInit.instance.homeStore;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    // Listen to post message changes
    reaction((_) => store.createPostStore.postMessage, (String message) {
      if (message.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              buildSnackBarNotify(
                textNotify: message,
                backgroundColor: store.createPostStore.isPostSuccess ? Colors.green : Colors.red,
              ),
            );
            store.clearPostMessage();
          }
        });
      }
    });

    store.init();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void onRefresh() {
    store.getALlPosts(type: PUBLIC);
  }

  void onLoading() {
    store.getMorePosts(type: PUBLIC);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SmartRefresher(
            controller: store.refreshController,
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: onRefresh,
            onLoading: onLoading,
            footer: CustomFooter(
              builder: (context, mode) => buildLoadMoreFooter(mode),
            ),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: 20.h)),
                SliverToBoxAdapter(child: CreatePostButton()),
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    height: 3.h,
                    decoration: const BoxDecoration(
                      color: ColorResources.LIGHT_GREY,
                    ),
                  ),
                ),
                SliverToBoxAdapter(child: FriendStoriesListComponent()),
                if (store.isLoadingPost)
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 10.h),
                          height: 3.h,
                          decoration: const BoxDecoration(
                            color: ColorResources.LIGHT_GREY,
                          ),
                        ),
                        PostCreationProgress(),
                      ],
                    ),
                  ),
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10.h),
                    height: 3.h,
                    decoration: const BoxDecoration(
                      color: ColorResources.LIGHT_GREY,
                    ),
                  ),
                ),
                _buildPostList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPostList() {
    return Observer(
      builder: (context) {
        if (store.allPostsPublic.isEmpty) {
          return const SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Không có bài viết nào',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          );
        }

        return SliverToBoxAdapter(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: store.allPostsPublic.length,
            itemBuilder: (context, index) {
              try {
                final post = store.allPostsPublic[index];
                if (post == null) return const SizedBox(height: 100);
                return Container(
                  key: ValueKey('post_${post.id ?? index}'),
                  margin: const EdgeInsets.only(bottom: 8),
                  child: PostItem(itemPost: post),
                );
              } catch (e) {
                // Fallback widget if there's an error
                return Container(
                  height: 100,
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Lỗi hiển thị bài viết',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget buildLoadMoreFooter(LoadStatus? mode) {
    switch (mode) {
      case LoadStatus.idle:
        return const SizedBox();
      case LoadStatus.loading:
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      case LoadStatus.failed:
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text("Tải thêm thất bại!"),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => store.getMorePosts(type: PUBLIC),
                child: const Text("Thử lại"),
              ),
            ],
          ),
        );
      case LoadStatus.canLoading:
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: const Center(
            child: Text("Thả để tải thêm"),
          ),
        );
      case LoadStatus.noMore:
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: const Center(
            child: Text(
              "Đã hết bài viết",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        );
      default:
        return const SizedBox();
    }
  }
}
