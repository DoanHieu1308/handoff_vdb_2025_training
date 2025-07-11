import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/utils/color_resources.dart';
import 'package:handoff_vdb_2025/presentation/pages/item_detail/item_detail_store.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../data/model/friend/friend_request_model.dart';
import '../../widget/build_snackbar.dart';

class ItemDetailPage extends StatefulWidget {
  final String categoryName;
  final String? friendName;
  final FriendRequestModel? friendRequest;

  const ItemDetailPage({
    super.key,
    required this.categoryName,
    required this.friendName,
    required this.friendRequest
  });

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  final ItemDetailStore store = ItemDetailStore();
  late List<Map<String, dynamic>> filteredItems;

  @override
  void initState() {
    super.initState();
    filteredItems = store.getFilteredItems(widget.categoryName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return SafeArea(
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
                  itemCount: filteredItems.length,
                  separatorBuilder: (_, __) => SizedBox(height: 10.h),
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];
                    return _itemDetailCard(
                      index: index,
                      context: context,
                      name: item['name'],
                      icon: item['image'],
                      friendName: widget.friendName ?? "",
                        friendRequest: widget.friendRequest
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemDetailCard({
    required int index,
    required String name,
    required String icon,
    required String friendName,
    required FriendRequestModel? friendRequest,
    required BuildContext context,
  }) {
    return AutoScrollTag(
      key: ValueKey(index),
      controller: store.scrollController,
      index: index,
      child: GestureDetector(
        onTap: () {
          showDialog(context: context,
              builder: (_) => DiaLogNotification(
                nameItemDetail: name,
                friendName: friendName,
                friendRequest: friendRequest,
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
    );
  }
}

class DiaLogNotification extends StatelessWidget {
  final ItemDetailStore store;
  final String nameItemDetail;
  final String? friendName;
  final FriendRequestModel? friendRequest;
  const DiaLogNotification({
    super.key,
    required this.nameItemDetail,
    required this.friendName,
    required this.store,
    required this.friendRequest
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
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
              'You are about to $nameItemDetail $friendName. Are you sure you want to proceed?',
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
                          store.actionItemDetail(
                              nameItemDetail: nameItemDetail,
                              requestId: friendRequest?.id ?? "",
                              onSuccess: (){
                                ScaffoldMessenger.of(context,).showSnackBar(
                                    buildSnackBarNotify(
                                        textNotify: "Successfully $nameItemDetail"
                                    )
                                );
                                store.friendsStore.getAllFriendsRequests();
                              },
                              onError: (error) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
                              }
                          );
                          Navigator.pop(context);
                          Navigator.pop(context);
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
    );
  }
}
