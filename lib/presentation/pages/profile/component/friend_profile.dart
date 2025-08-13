import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/helper/app_text.dart';
import '../../../../core/init/app_init.dart';
import '../../../../core/utils/color_resources.dart';
import '../../../../core/utils/images_path.dart';

class FriendProfile extends StatelessWidget {
  final store = AppInit.instance.profileStore;
  FriendProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Column(
          children: [
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
                          mainAxisAlignment: MainAxisAlignment.start,
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
                children: List.generate(store.friendsStore.friendList.length, (
                    index,
                    ) {
                  return GestureDetector(
                    onTap: () {
                      store.friendsStore.goToInfoFriend(
                        context: context,
                        friendId: store.friendsStore.friendList[index].id ?? '',
                      );
                    },
                    child: SizedBox(
                      height: 250.h,
                      width: 90.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SetUpAssetImage(
                            height: 90.h,
                            width: 90.w,
                            store.friendsStore.friendList[index].avatar ??
                                ImagesPath.icPerson,
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
                                  margin: EdgeInsets.only(right: 5.w),
                                  height: 7.h,
                                  width: 7.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                  ),
                                ),
                                Text('Đang hoat động', style: AppText.text10),
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
          ],
        );
      },
    );
  }
}
