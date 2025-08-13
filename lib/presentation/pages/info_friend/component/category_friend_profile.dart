import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/init/app_init.dart';
import '../../../widget/item_folder_profile.dart';
import '../info_friend_store.dart';

class CategoryFriendProfile extends StatelessWidget {
  final InfoFriendStore store = AppInit.instance.infoFriendStore;
  CategoryFriendProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15.w, top: 10.h, bottom: 10.h),
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
            name: "Giới thiệu",
            onTap: () {
              store.onChangedFolderIndexProfile(index: 1);
            },
            isSelected: store.selectedFolderIndex == 1,
          ),
          ItemFolderProfile(
            name: "Ảnh",
            onTap: () {
              store.onChangedFolderIndexProfile(index: 2);
            },
            isSelected: store.selectedFolderIndex == 2,
          ),
          ItemFolderProfile(
            name: "Video",
            onTap: () {
              store.onChangedFolderIndexProfile(index: 3);
            },
            isSelected: store.selectedFolderIndex == 3,
          ),
        ],
      ),
    );
  }
}
