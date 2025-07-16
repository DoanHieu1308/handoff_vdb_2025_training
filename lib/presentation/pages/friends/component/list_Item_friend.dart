import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/helper/size_util.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/friends_store.dart';
import 'package:handoff_vdb_2025/presentation/widget/build_snackbar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/helper/app_text.dart';
import '../../item_detail/item_detail_page.dart';

class ListItemFriend extends StatefulWidget {
  final FriendsStore store;
  const ListItemFriend({super.key, required this.store});

  @override
  State<ListItemFriend> createState() => _ListItemFriendState();
}

class _ListItemFriendState extends State<ListItemFriend> {
  late final RefreshController _refreshController;

  /// Init
  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
  }

  /// dispose
  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  /// Refresh
  Future<void> _onRefresh() async {
    try {
      await Future.delayed(Duration(milliseconds: 1000));
      switch (widget.store.selectedCategoryName) {
        case FRIEND_REQUESTS:
          await widget.store.getAllFriendsRequests();
          break;
        case ALL_FRIENDS:
          await widget.store.getAllFriends();
          break;
        case SUGGESTIONS_FRIENDS:
          await widget.store.getAllFriendSuggestions();
          break;
      }
      _refreshController.refreshCompleted();
    } catch (_) {
      _refreshController.refreshFailed();
    }
  }

  Future<void> _onLoading() async {
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      final store = widget.store;
      final category = store.selectedCategoryName;
      List<UserModel> friendList = [];
      String icon = '';
      String label = '';

      switch (category) {
        case ALL_FRIENDS:
          friendList = store.friendList;
          icon = ImagesPath.icMessenger;
          label = "${friendList.length} Friend";
          break;
        case SUGGESTIONS_FRIENDS:
          friendList = store.friendListSuggestion;
          icon = ImagesPath.icAddFriend;
          label = "${friendList.length} Suggestion";
          break;
        case FRIEND_REQUESTS:
          friendList = store.friendListPending;
          icon = ImagesPath.icAlreadyFriends;
          label = "${friendList.length} Requests";
          break;
        case FOLLOWING:
          friendList = store.friendListFollower;
          icon = ImagesPath.icMessenger;
          label = "0 Follower";
          break;
        default:
          return const SizedBox();
      }

      return _buildFriendList(
        friendList: friendList,
        icon: icon,
        numberLabel: label,
        category: category,
        onAcceptTap: (index) {
          if (category == FRIEND_REQUESTS) {
            store.handleAcceptFriendRequest(index).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                buildSnackBarNotify(textNotify: "Friend request accepted successfully!"),
              );
            }).catchError((error) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(error.toString())),
              );
            });
          }else if(category == SUGGESTIONS_FRIENDS){

          }
        },
      );
    });
  }

  Widget _buildFriendList({
    required List<UserModel> friendList,
    required String icon,
    required String numberLabel,
    required String category,
    required Function(int index) onAcceptTap,
  }) {
    return Observer(builder: (_) {
      final isLoading = widget.store.isLoading;

      if (isLoading) {
        return SizedBox(
          height: SizeUtil.getMaxHeight(),
          width: SizeUtil.getMaxWidth(),
          child: const Center(child: CircularProgressIndicator(strokeWidth: 4)),
        );
      }

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Text(numberLabel, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10.h),
            Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                enablePullDown: true,
                enablePullUp: true,
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                header: const WaterDropHeader(),
                child: friendList.isEmpty
                    ? const Center(child: Text("No friends found"))
                    : ListView.builder(
                  itemCount: friendList.length,
                  itemBuilder: (_, index) => ItemCardFriend(
                    user: friendList[index],
                    index: index,
                    category: category,
                    icon: icon,
                    store: widget.store,
                    onAcceptTap: onAcceptTap,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class ItemCardFriend extends StatelessWidget {
  final UserModel user;
  final int index;
  final String category;
  final String icon;
  final FriendsStore store;
  final Function(int) onAcceptTap;

  const ItemCardFriend({
    super.key,
    required this.user,
    required this.index,
    required this.category,
    required this.icon,
    required this.store,
    required this.onAcceptTap,
  });

  bool get isRequest => category == FRIEND_REQUESTS;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => store.goToInfoFriend(context: context),
      child: Padding(
        padding: EdgeInsets.only(top: 10.h),
        child: Container(
          height: 70.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30.h,
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  child: ClipOval(
                    child: SetUpAssetImage(
                      user.avatar ?? ImagesPath.icPerson,
                      height: 60.h,
                      width: 60.h,
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(user.name ?? '', style: AppText.text14_Inter),
                      SizedBox(height: 5.h),
                      Text("3 mutual friends", style: AppText.text12_Inter.copyWith(color: Colors.grey)),
                    ],
                  ),
                ),
                if (isRequest)
                  Observer(
                    builder: (_) => store.isFriendAccepted(user.id ?? '')
                        ? Text("Accepted", style: AppText.text12_Inter)
                        : Row(
                      children: [
                        _buildAcceptButton(),
                        SizedBox(width: 10.w,),
                        _buildMoreButton(context),
                      ],
                    ),
                  )
                else
                  Row(
                      children: [
                        _buildActionButton(),
                        SizedBox(width: 10.w,),
                        _buildMoreButton(context)
                      ]
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAcceptButton() => GestureDetector(
    onTap: () => onAcceptTap(index),
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text("Chấp nhận", style: AppText.text10_bold.copyWith(color: Colors.white)),
    ),
  );

  Widget _buildActionButton() => GestureDetector(
    onTap: () => onAcceptTap(index),
    child: Container(
        height: 23.h,
        width: 23.w,
        decoration: BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle
        ),
        child: SetUpAssetImage(icon, height: 20.h, width: 20.w, color: Colors.blue)),
  );

  Widget _buildMoreButton(BuildContext context) => GestureDetector(
    onTap: () => showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => FractionallySizedBox(
        heightFactor: 0.8,
        child: ItemDetailPage(
          categoryName: category,
          friendName: user.name,
          friendInList: user,
          friendRequest: isRequest && index < store.listRequests.length ? store.listRequests[index] : null,
        ),
      ),
    ),
    child: Container(
        width: 30.w,
        height: 30.h,
        color: Colors.transparent,
        child: Image.asset(ImagesPath.ic3Dot, height: 20.h, width: 20.h)
    ),

  );
}
