import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/presentation/pages/profile/component/feeling_profile.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../../../core/utils/color_resources.dart';
import '../../../posts/post_item.dart';
import '../../component/category_profile.dart';
import '../../component/friend_profile.dart';
import '../../component/info_profile.dart';
import '../../component/lead_profile.dart';

class ProfilePage extends StatefulWidget {

  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final store = AppInit.instance.profileStore;

  @override
  void initState() {
    store.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SmartRefresher(
        controller: store.refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: store.loadInitialPostsByUserId,
        onLoading: store.loadMorePostsByUserId,
        child: CustomScrollView(
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
            Observer(
              builder: (context) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return PostItem(itemPost: store.posts[index]);
                  }, childCount: store.posts.length),
                );
              }
            ),
          ],
        ),
      ),
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
