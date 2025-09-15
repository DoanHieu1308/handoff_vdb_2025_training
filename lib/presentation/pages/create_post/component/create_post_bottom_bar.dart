import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/enums/auth_enums.dart';
import '../../../../core/helper/size_util.dart';
import '../../../../core/init/app_init.dart';
import '../../../../core/utils/color_resources.dart';
import '../../../../core/utils/images_path.dart';
import '../../../../core/utils/navigation_helper.dart';
import '../create_post_store.dart';

class CreatePostBottomBar extends StatelessWidget {
  CreatePostStore store = AppInit.instance.createPostStore;
  CreatePostBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      height: 50.h,
      width: SizeUtil.getMaxWidth(),
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorResources.LIGHT_GREY.withValues(alpha: 0.5),
          width: 1,
        ),
        color: ColorResources.WHITE.withValues(alpha: 0.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _createPostBottomBarItem(
            onTap: () {
              store.mediaStore.checkFileLimit(context);
            },
            imagePath: ImagesPath.icPhotos,
          ),
          _createPostBottomBarItem(
            onTap: () {
              NavigationHelper.navigateTo(context, AuthRoutes.TAG_FRIEND);
            },
            imagePath: ImagesPath.icTag,
          ),
          _createPostBottomBarItem(
            onTap: () {},
            imagePath: ImagesPath.icFeeling,
          ),
          _createPostBottomBarItem(
            onTap: () {},
            imagePath: ImagesPath.icCheckIn,
          ),
          _createPostBottomBarItem(
              onTap: () {},
              imagePath: ImagesPath.icMore
          ),
        ],
      ),
    );
  }

  Widget _createPostBottomBarItem({
    required String imagePath,
    required VoidCallback? onTap
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: SizeUtil.getMaxWidth() / 5 - 10.w,
        height: 60.h,
        color: Colors.transparent,
        child: Column(
          children: [
            SizedBox(height: 2.h),
            SetUpAssetImage(
              imagePath,
              width: 24.w,
              height: 24.h,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}
