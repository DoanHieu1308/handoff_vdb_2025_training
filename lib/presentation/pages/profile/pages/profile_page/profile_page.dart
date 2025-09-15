import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/helper/app_divider.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/presentation/pages/profile/component/feeling_profile.dart';
import 'package:mobx/mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../../core/utils/color_resources.dart';
import '../../../../widget/build_snackbar.dart';
import '../../../home/component/post_creation_progress.dart';
import '../../../posts/post_item.dart';
import '../../component/category_profile.dart';
import '../../component/friend_profile.dart';
import '../../component/info_profile.dart';
import '../../component/lead_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final store = AppInit.instance.profileStore;
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);

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
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: true,
            onRefresh: () async {
              await store.loadInitialPostsByUserId();
              if (mounted) {
                _refreshController.refreshCompleted();
              }
            },
            onLoading: () async {
              await store.loadMorePostsByUserId();
              if (mounted) {
                _refreshController.loadComplete();
              }
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: LeadProfile()),
                SliverToBoxAdapter(
                  child: Container(height: 3.h, color: ColorResources.LIGHT_GREY),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: CategoryHeaderDelegate(
                    child: CategoryProfile(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(height: 1.h, color: ColorResources.LIGHT_GREY),
                ),
                SliverToBoxAdapter(child: InfoProfile()),
                SliverToBoxAdapter(child: FriendProfile()),
                SliverToBoxAdapter(child: SizedBox(height: 10.h)),
                SliverToBoxAdapter(child: FeelingProfile()),
                SliverToBoxAdapter(child: SizedBox(height: 10.h)),
                SliverToBoxAdapter(
                  child: Container(height: 2.h, color: ColorResources.LIGHT_GREY),
                ),
                if (store.isLoadingPost)
                SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PostCreationProgress(),
                        AppDivider.v3
                      ],
                    ),
                  ),
                _buildPostList(),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildPostList() {
    return Observer(
      builder: (context) {
        if (store.posts.isEmpty) {
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
            itemCount: store.posts.length,
            itemBuilder: (context, index) {
              try {
                final post = store.posts[index];
                return Container(
                  key: ValueKey('profile_post_${post.id ?? index}'),
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
}

class CategoryHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  CategoryHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => kToolbarHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
