import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';
import 'package:handoff_vdb_2025/core/utils/color_resources.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import 'package:handoff_vdb_2025/presentation/pages/item_detail/item_detail_store.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../data/model/friend/friend_request_model.dart';

class ItemDetailPage extends StatefulWidget {
  final String categoryName;
  final String? friendName;
  final FriendRequestModel? friendRequest;
  final UserModel? friendInList;

  const ItemDetailPage({
    super.key,
    required this.categoryName,
    required this.friendName,
    this.friendRequest,
    required this.friendInList
  });

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  late ItemDetailStore store;

  @override
  void initState() {
    super.initState();
    // Tạo FriendsStore và ItemDetailStore riêng cho màn hình này
    // TODO
    store = AppInit.instance.itemDetailStore;
    store.filteredItems = store.getFilteredItems(widget.categoryName);
    print("ccccc ${store.filteredItems.length}");
  }

  @override
  void dispose() {
    store.friendsStore.disposeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Observer(builder: (_) => SafeArea(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          color: ColorResources.COLOR_F6F6F7,
        ),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Container(
              width: 65.w,
              height: 5.h,
              decoration: BoxDecoration(color: ColorResources.COLOR_AFB0AB),
            ),
            SizedBox(height: 15.h),
            Expanded(
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: ListView.separated(
                  controller: store.scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: store.filteredItems.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (context, index) {
                    final item = store.filteredItems[index];
                    return _itemDetailCard(
                        index: index,
                        context: context,
                        name: item['name'],
                        icon: item['image'],
                        friendName: widget.friendName ?? "",
                        friendRequest: widget.friendRequest,
                        friendInList: widget.friendInList
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _itemDetailCard({
    required int index,
    required String name,
    required String icon,
    required String friendName,
    FriendRequestModel? friendRequest,
    UserModel? friendInList,
    required BuildContext context,
  }) {
    return Observer(builder: (_) => AutoScrollTag(
      key: ValueKey(index),
      controller: store.scrollController,
      index: index,
      child: GestureDetector(
        onTap: () {
          showDialog(context: context,
              builder: (_) => DiaLogNotification(
                nameItemDetail: name,
                friendRequest: friendRequest,
                friendInList: friendInList,
                store: store,
              ));
        },
        child: Container(
          height: 50.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: ColorResources.WHITE,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Text(name, style: AppText.text14_Inter),
                ),
                Expanded(
                  flex: 2,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: ColorResources.COLOR_F6F6F7,
                    child: SetUpAssetImage(icon, width: 20.w, height: 20.h),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}

class DiaLogNotification extends StatelessWidget {
  final ItemDetailStore store;
  final String nameItemDetail;
  final FriendRequestModel? friendRequest;
  final UserModel? friendInList;
  const DiaLogNotification({
    super.key,
    required this.nameItemDetail,
    required this.store,
    this.friendRequest,
    this.friendInList
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(20),
        height: 200.h,
        width: 370.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            Text('Confirm $nameItemDetail', style: AppText.text14_Inter),
            SizedBox(height: 20.h),
            Text(
              'You are about to $nameItemDetail ${friendInList?.name ?? "this user"}. Are you sure you want to proceed?',
              style: AppText.text12,
            ),
            SizedBox(height: 20.h),
            Container(height: 0.5.h, width: 370.w, color: Colors.grey),
            SizedBox(height: 20.h),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SizedBox(
                      width: 70.w,
                      height: 50.h,
                      child: Center(
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Builder(
                    builder: (scaffoldContext) {
                      return GestureDetector(
                        onTap: () {
                          if(nameItemDetail == DENIED){
                            store.actionItemDenied(
                                nameItemDetail: nameItemDetail,
                                requestId: friendRequest?.id ?? "",
                                friendPending: friendInList,
                                context: context
                            );
                            Navigator.pop(context);
                            Navigator.pop(context);
                          }else if(nameItemDetail == UNFRIEND) {
                            if (friendInList != null) {
                              store.actionItemUnfriend(
                                  nameItemDetail: nameItemDetail,
                                  friendId: friendInList!.id,
                                  friendInList: friendInList,
                                  context: context
                              );
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: SizedBox(
                          width: 70.w,
                          height: 50.h,
                          child: Center(
                            child: Text(
                              "Confirm",
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
