import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/data/model/friend/friend_sent_model.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/widget/item_card_friend_request.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/widget/item_card_friend_sent.dart';
import 'package:mobx/mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/images_path.dart';
import '../../../../data/model/friend/friend_request_model.dart';
import '../friends_store.dart';

class ListFriendRequest extends StatefulWidget {
  final FriendsStore store;
  const ListFriendRequest({super.key, required this.store});

  @override
  State<ListFriendRequest> createState() => _ListFriendRequestState();
}

class _ListFriendRequestState extends State<ListFriendRequest> {
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
        case FRIEND_REQUESTS:
          await widget.store.getAllFriendsRequests();
          break;
        case FRIEND_SEND:
          await widget.store.getAllFriendsSent();
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
        final ObservableList<dynamic> listModel;
        String label = '';

        switch (category) {
          case FRIEND_REQUESTS:
            listModel = widget.store.friendListPending;
            label = "${listModel.length} Requests";
            break;
          case FRIEND_SEND:
            listModel = widget.store.friendListSent;
            label = "${listModel.length} Send";
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
                    itemBuilder: (_, index) =>
                    category == FRIEND_REQUESTS
                        ? ItemCardFriendRequest(
                            friendRequest: listModel[index],
                            store: widget.store,
                          )
                        : ItemCardFriendSent(
                            friendRequest: listModel[index],
                            store: widget.store,
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
