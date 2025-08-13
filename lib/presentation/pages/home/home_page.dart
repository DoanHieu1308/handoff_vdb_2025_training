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

class _HomePageState extends State<HomePage> {
  final HomeStore store = AppInit.instance.homeStore;

  @override
  void initState() {
    // Listen to post message changes
    reaction((_) => store.postMessage, (String message) {
      if (message.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              buildSnackBarNotify(
                textNotify: message,
                backgroundColor: store.isPostSuccess ? null : Colors.red,
              ),
            );
            store.clearPostMessage();
          }
        });
      }
    });

    store.init();
    super.initState();
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

  Widget _buildLineSpacing(){
    /// [TODO] 3, color
    return Divider();
  }

  Widget _buildPostList() {
    return Observer(
      builder: (context) {
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return PostItem(itemPost: store.allPostsPublic[index]);
          }, childCount: store.allPostsPublic.length),
        );
      },
    );
  }

  Widget buildLoadMoreFooter(LoadStatus? mode) {
    switch (mode) {
      case LoadStatus.idle:
        return const SizedBox();
      case LoadStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case LoadStatus.failed:
        return const Center(child: Text("Load Failed! Click retry!"));
      case LoadStatus.canLoading:
        return const Center(child: Text("Release to load more"));
      case LoadStatus.noMore:
        return const SizedBox();
      default:
        return const SizedBox();
    }
  }
}
