import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helper/size_util.dart';
import '../../../../core/init/app_init.dart';
import '../../../widget/item_folder_profile.dart';

class CategoryProfile extends StatelessWidget {
  final store = AppInit.instance.profileStore;
  CategoryProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Container(
          height: 56.0,
          width: SizeUtil.getMaxWidth(),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300,
                width: 2.0,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
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
        );
      },
    );
  }
}
