import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/config/routes/route_path/auth_routers.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/helper/size_util.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/component/button_post.dart';
import 'package:handoff_vdb_2025/presentation/pages/search/search_page.dart';

import '../../../../../../data/model/response/user_model.dart';
import '../create_post_advanced_options_setting_store.dart';


class TagFriendsPage extends StatefulWidget {
  const TagFriendsPage({super.key});

  @override
  State<TagFriendsPage> createState() => _TagFriendsPageState();
}

class _TagFriendsPageState extends State<TagFriendsPage> {
  CreatePostAdvancedOptionSettingStore store = AppInit.instance.createPostAdvancedOptionSettingStore;
  late VoidCallback searchListener;

  @override
  void initState() {
    super.initState();
    // Thêm listener cho search text thay đổi
    searchListener = () {
      if (mounted) {
        store.getItemSearch();
        // Tắt bàn phím khi search text rỗng
        if (store.searchStore.searchText.isEmpty) {
          FocusScope.of(context).unfocus();
        }
      }
    };
    store.searchStore.textEditingController.addListener(searchListener);
  }

  @override
  void dispose() {
    store.searchStore.textEditingController.removeListener(searchListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new_outlined, size: 22),
        ),
        title: Text("Gắn thẻ người khác", style: AppText.text18),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10.w),
            child: GestureDetector(
                onTap: (){
                  router.pop();
                },
                child: ButtonPost(name: "XONG", hasdata: true)
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            width: SizeUtil.getMaxWidth() - 10.w,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(15),
            ),
            child: SearchPage(),
          ),
          buildTagFriendBody(),
        ],
      ),
    );
  }

  Widget buildTagFriendBody() {
    return Observer(
      builder: (context) {
        return Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (store.tagFriendList.isNotEmpty)
                buildDataListFriendSelected(),
              if (store.searchStore.searchText.isNotEmpty)
                Expanded(child: _buildDataSearch())
              else
                Expanded(child: buildDataListFriendRecommend()),
            ],
          ),
        );
      },
    );
  }

  Widget buildDataListFriendRecommend() {
    return Observer(
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.w, top: 20.h, bottom: 5.h),
              child: SizedBox(
                  height: 25.h,
                  child: Text("Gợi ý", style: AppText.text18_bold)
              ),
            ),
            Expanded(
              child: store.friendsStore.friendList.isEmpty
                  ? Center(
                      child: Text(
                        "Không có bạn bè nào",
                        style: AppText.text14.copyWith(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: store.friendsStore.friendList.length,
                      itemBuilder: (context, index) {
                        return buildItemCardFriend(
                          friend: store.friendsStore.friendList[index],
                        );
                      },
                    ),
            ),
          ],
        );
      }
    );
  }

  Widget buildDataListFriendSelected() {
    return Observer(
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10.w, top: 10.h, bottom: 5.h),
              child: SizedBox(
                  height: 25.h,
                  child: Text("Đã chọn", style: AppText.text18_bold)
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: SizedBox(
                height: 97.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: store.tagFriendList.length,
                  itemBuilder: (context, index) {
                    final friend = store.tagFriendList[index];
                    return FriendSlideInItem(
                      friend: store.tagFriendList[index],
                      onRemove: () {
                        store.tagFriendList.removeWhere(
                          (user) => user.id == friend.id,
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }
    );
  }

  Widget _buildDataSearch() {
    return Padding(
      padding: EdgeInsets.only(top: 20.h),
      child: Observer(
        builder: (context) {
          return store.friendListSearch.isEmpty
              ? Center(
                  child: Text(
                    "Không tìm thấy kết quả",
                    style: AppText.text14.copyWith(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: store.friendListSearch.length,
                  itemBuilder: (context, index) {
                    return buildItemCardFriend(
                      friend: store.friendListSearch[index],
                    );
                  },
                );
        },
      ),
    );
  }

  Widget buildItemCardFriend({required UserModel friend}) {
    final isSelected = store.tagFriendList.any((user) => user.id == friend.id);

    return Observer(
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: 20, left: 10.w),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              if (isSelected) {
                store.tagFriendList.removeWhere((user) => user.id == friend.id);
              } else {
                store.tagFriendList.add(friend);
              }
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 25,
                    child: ClipOval(
                      child: SetUpAssetImage(
                        height: 55.h,
                        width: 55.w,
                        friend.avatar ?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  SizedBox(
                    height: 45.h,
                    width: 275.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(friend.name ?? '', style: AppText.text14_bold),
                        Text(
                          "Trang cá nhân - ${friend.countFollowers} người theo dõi",
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 19.h,
                    width: 19.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        width: 2.h,
                        color: isSelected ? Colors.transparent : Colors.grey,
                      ),
                      color: isSelected ? Colors.blue : Colors.white,
                    ),
                    child: Center(
                      child:
                          isSelected
                              ? Icon(Icons.check, size: 16, color: Colors.white)
                              : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Item in list friend selected
class FriendSlideInItem extends StatefulWidget {
  final UserModel friend;
  final VoidCallback onRemove;

  const FriendSlideInItem({
    super.key,
    required this.friend,
    required this.onRemove,
  });

  @override
  State<FriendSlideInItem> createState() => _FriendSlideInItemState();
}

class _FriendSlideInItemState extends State<FriendSlideInItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(-1.5, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Padding(
        padding: EdgeInsets.only(right: 10.w),
        child: Column(
          children: [
            SizedBox(
              width: 75.w,
              height: 75.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipOval(
                    child: SetUpAssetImage(
                      widget.friend.avatar ?? '',
                      fit: BoxFit.cover,
                      width: 70.w,
                      height: 70.w,
                    ),
                  ),
                  Positioned(
                    top: 5.h,
                    right: 0,
                    child: GestureDetector(
                      onTap: widget.onRemove,
                      child: Container(
                        width: 17.w,
                        height: 17.w,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SetUpAssetImage(
                            ImagesPath.icCancel,
                            width: 8.w,
                            height: 8.w,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.h),
            Text(widget.friend.name ?? '', style: AppText.text12_bold),
          ],
        ),
      ),
    );
  }
}
