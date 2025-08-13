import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobx/mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../core/utils/app_constants.dart';
import '../../../../data/model/response/user_model.dart';
import '../friends_store.dart';
import 'item_card_friend.dart';

class ListUserFriend extends StatefulWidget {
  final FriendsStore store;

  const ListUserFriend({super.key, required this.store});

  @override
  State<ListUserFriend> createState() => _ListUserFriendState();
}

class _ListUserFriendState extends State<ListUserFriend> {
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      switch (widget.store.selectedCategoryName) {
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

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final category = widget.store.selectedCategoryName;
        final ObservableList<UserModel> listModel;
        String label = '';

        switch (category) {
          case ALL_FRIENDS:
            listModel = widget.store.friendList;
            label = "${listModel.length} Friends";
            break;
          case SUGGESTIONS_FRIENDS:
            listModel = widget.store.friendListSuggestion;
            label = "${listModel.length} Suggestions";
            break;
          default:
            return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),
              Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: SmartRefresher(
                  controller: _refreshController,
                  enablePullDown: true,
                  enablePullUp: false,
                  onRefresh: _onRefresh,
                  header: const WaterDropHeader(),
                  child: listModel.isEmpty
                      ? const Center(child: Text("No data found"))
                      : ListView.builder(
                    itemCount: listModel.length,
                    itemBuilder: (_, index) => FriendItemCard(
                      store: widget.store,
                      categoryName: category,
                      friend: listModel[index],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
