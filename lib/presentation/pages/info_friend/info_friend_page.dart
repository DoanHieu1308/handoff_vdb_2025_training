import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../core/utils/color_resources.dart';
import '../posts/post_item.dart';
import 'component/category_friend_profile.dart';
import 'component/feeling_friend_profile.dart';
import 'component/info_friend_profile.dart';
import 'component/lead_friend_profile.dart';
import 'component/sent_and_accept_friend.dart';
import 'info_friend_store.dart';

class InfoFriendPage extends StatefulWidget {
  const InfoFriendPage({super.key});

  @override
  State<InfoFriendPage> createState() => _InfoFriendPageState();
}

class _InfoFriendPageState extends State<InfoFriendPage> {
  final InfoFriendStore store = AppInit.instance.infoFriendStore;
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
    store.init();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  void onRefresh() async {
    await store.getPostsOfFriendByUserId(userId: store.profileFriend.user?.id ?? "");
    if (mounted) {
      _refreshController.refreshCompleted();
    }
  }

  void onLoading() async {
    await store.loadMorePostsOfFriendByUserId(userId: store.profileFriend.user?.id ?? "");
    if (mounted) {
      _refreshController.loadComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        FocusScope.of(context).unfocus();
        store.isLSeeMore = false;
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: onRefresh,
          onLoading: onLoading,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: LeadFriendProfile(),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: SentAndAcceptFriend(),
                ),
              ),
              _sliverDivider(3.h),
              SliverToBoxAdapter(child: CategoryFriendProfile()),
              _sliverDivider(1.h),
              SliverToBoxAdapter(child: InfoFriendProfile()),
              SliverToBoxAdapter(child: SizedBox(height: 10.h)),
              SliverToBoxAdapter(child: FeelingFriendProfile()),
              SliverToBoxAdapter(child: SizedBox(height: 10.h)),
              _sliverDivider(1.h),
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
      ),
    );
  }

  SliverToBoxAdapter _sliverDivider(double height) {
    return SliverToBoxAdapter(
      child: Container(
        height: height,
        color: ColorResources.LIGHT_GREY,
      ),
    );
  }
}
