import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/config/routes/route_path/auth_routers.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/helper/size_util.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import 'package:handoff_vdb_2025/presentation/pages/profile/profile_store.dart';
import 'package:handoff_vdb_2025/presentation/widget/post_status.dart';

import '../../../core/utils/color_resources.dart';
import '../../widget/item_folder_profile.dart';
import 'component/build_drawer.dart';

class ProfilePage extends StatelessWidget {
  final UserModel userProfile;
  late ProfileStore store = ProfileStore();

  ProfilePage({super.key, required this.userProfile});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder:
          (_) => Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                                height: 200.h,
                                width: SizeUtil.getMaxWidth(),
                                color: Colors.transparent,
                              child: SetUpAssetImage(
                                ImagesPath.imgAnhNen,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 15.w,
                              bottom: 10.h,
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: ColorResources.LIGHT_GREY,
                                child: Icon(Icons.camera_alt),
                              ),
                            ),
                            Positioned(
                              top: 10.h,
                              left: 10.w,
                              child: IconButton(
                                icon: Icon(Icons.menu, color: Colors.white),
                                onPressed: () {
                                  showGeneralDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    barrierLabel: "Drawer",
                                    pageBuilder: (
                                      context,
                                      animation1,
                                      animation2,
                                    ) {
                                      return buildDrawer(context, store);
                                    },
                                    transitionBuilder: (
                                      context,
                                      animation,
                                      secondaryAnimation,
                                      child,
                                    ) {
                                      return SlideTransition(
                                        position: Tween<Offset>(
                                          begin: Offset(-1, 0),
                                          end: Offset(0, 0),
                                        ).animate(animation),
                                        child: child,
                                      );
                                    },
                                    transitionDuration: Duration(
                                      milliseconds: 250,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 50.h),
                        Padding(
                          padding: EdgeInsets.only(left: 15.w),
                          child: Text(
                            userProfile.name ?? "",
                            style: AppText.text25_bold,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.w),
                          child: Row(
                            children: [
                              Text("188", style: AppText.text16_bold),
                              SizedBox(width: 5.w),
                              Text(
                                "người bạn",
                                style: AppText.text14.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15.w),
                          height: 40.h,
                          width: 330.w,
                          decoration: BoxDecoration(
                            color: ColorResources.COLOR_0956D6,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_circle_outline,
                                color: Colors.white,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                "Thêm vào tin",
                                style: AppText.text14_Inter.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 10,
                                child: Container(
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: ColorResources.LIGHT_GREY,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                        size: 17,
                                      ),
                                      SizedBox(width: 3.w),
                                      Text(
                                        "Chỉnh sửa trang cá nhân",
                                        style: AppText.text14_Inter.copyWith(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.h),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: ColorResources.LIGHT_GREY,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 10.h),
                                    child: Center(
                                      child: Text(
                                        "...",
                                        style: AppText.text16_bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Container(
                          height: 3.h,
                          decoration: BoxDecoration(
                            color: ColorResources.LIGHT_GREY,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 15.w,
                            top: 10.h,
                            bottom: 10.h,
                          ),
                          child: Row(
                            children: [
                              ItemFolderProfile(
                                name: "Bài viết",
                                onTap: () {
                                  store.onChangedFolderIndexProfile(index: 0);
                                },
                                isSelected: store.selectedFolderIndex == 0,
                              ),
                              ItemFolderProfile(
                                name: "Ảnh",
                                onTap: () {
                                  store.onChangedFolderIndexProfile(index: 1);
                                },
                                isSelected: store.selectedFolderIndex == 1,
                              ),
                              ItemFolderProfile(
                                name: "Video",
                                onTap: () {
                                  store.onChangedFolderIndexProfile(index: 2);
                                },
                                isSelected: store.selectedFolderIndex == 2,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 1.h,
                          decoration: BoxDecoration(
                            color: ColorResources.LIGHT_GREY,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.w, top: 10.h),
                          child: Text("Chi tiết", style: AppText.text16_bold),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.w, top: 10.h),
                          child: Row(
                            children: [
                              Icon(Icons.home, color: Colors.grey),
                              SizedBox(width: 10.w),
                              Text("Sống tại ", style: AppText.text16),
                              Text("Da Nang", style: AppText.text16_bold),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.w),
                          child: GestureDetector(
                            onTap: () {
                              store.isLSeeMore = true;
                            },
                            child: Column(
                              children: [
                                Visibility(
                                  visible: !store.isLSeeMore,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 40.h,
                                        width: 30.w,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            bottom: 10.h,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "...",
                                              style: AppText.text16_bold
                                                  .copyWith(color: Colors.grey),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Xem thong tin gioi thieu cua ban",
                                        style: AppText.text16,
                                      ),
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: store.isLSeeMore,
                                  child: Text(userProfile.bio.toString()),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 15.h),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 15.w),
                          height: 40.h,
                          width: 330.w,
                          decoration: BoxDecoration(
                            color: ColorResources.COLOR_0956D6.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              "Chỉnh sửa chi tiết công khai",
                              style: AppText.text14_Inter.copyWith(
                                color: ColorResources.COLOR_0956D6,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 15.w, top: 10.h),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 10,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Bạn bè", style: AppText.text16_bold),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "188",
                                          style: AppText.text14.copyWith(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          " người bạn",
                                          style: AppText.text14.copyWith(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Text(
                                    "Tìm bạn bè",
                                    style: AppText.text14.copyWith(
                                      color: ColorResources.COLOR_0956D6,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.only(left: 15.w),
                          child: GridView.count(
                            crossAxisCount: 3,
                            childAspectRatio: 0.75,
                            mainAxisSpacing: 2,
                            crossAxisSpacing: 4,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: List.generate(store.friendsStore.friendList.length, (index) {
                              return GestureDetector(
                                onTap: (){
                                  store.friendsStore.goToInfoFriend(
                                      context: context
                                  );
                                },
                                child: SizedBox(
                                  height: 250.h,
                                  width: 90.w,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SetUpAssetImage(
                                        height: 90.h,
                                        width: 90.w,
                                        store.friendsStore.friendList[index].avatar ?? ImagesPath.icPerson,
                                        fit: BoxFit.cover,
                                      ),
                                      Text(
                                        store.friendsStore.friendList[index].name ?? '',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Visibility(
                                        visible: true,
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                right: 5.w,
                                              ),
                                              height: 7.h,
                                              width: 7.w,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.green,
                                              ),
                                            ),
                                            Text(
                                              'Đang hoat động',
                                              style: AppText.text10,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Visibility(
                                        visible: false,
                                        child: Text(
                                          'Hoạt động $index \ngiờ trước',
                                          style: AppText.text10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        GestureDetector(
                          onTap: () {
                              store.goToFriendPage(context);
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 15.w),
                            height: 40.h,
                            width: 330.w,
                            decoration: BoxDecoration(
                              color: ColorResources.GREY.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Xem tất cả bạn bè",
                                style: AppText.text14_Inter.copyWith(
                                  color: ColorResources.BLACK,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: SizedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Bài viết", style: AppText.text16_bold),
                                Text(
                                  "Bộ lọc",
                                  style: AppText.text14.copyWith(
                                    color: Colors.indigoAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.only(left: 15.w),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: CircleAvatar(
                                  radius: 30,
                                  child: SetUpAssetImage(
                                    height: 35.h,
                                    width: 35.w,
                                    ImagesPath.icPerson,
                                  ),
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Expanded(
                                flex: 16,
                                child: Text(
                                  "Bạn đang nghĩ gì?",
                                  style: AppText.text15,
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: Icon(
                                  Icons.image_search,
                                  color: Colors.green,
                                  size: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        PostStatus(),
                        SizedBox(height: 40.h),
                      ],
                    ),
                    Positioned(
                      left: 10.w,
                      top: 80.h,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 90,
                            backgroundColor: Colors.indigoAccent,
                            child: SetUpAssetImage(
                              userProfile.avatar ?? ImagesPath.icPerson,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 12.w,
                            bottom: 12.h,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: ColorResources.LIGHT_GREY,
                              child: Icon(Icons.camera_alt),
                            ),
                          ),
                        ],
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
