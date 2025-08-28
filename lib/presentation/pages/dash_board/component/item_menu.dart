import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/helper/app_tap_animation.dart';
import '../../../../core/utils/color_resources.dart';
import '../../../../core/utils/images_path.dart';

class ItemMenu extends StatelessWidget {
  final Function? onTap;
  final String? image;
  final int? number;
  const ItemMenu({
    super.key,
    this.onTap,
    this.image,
    this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: AppTapAnimation(
        enabled: true,
        onTap: (){
          onTap?.call();
        },
        child: Stack(
          children: [
            SizedBox(
              height: 35.h,
              width: 35.w,
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.transparent,
                child: SetUpAssetImage(
                  height: 22.h,
                  width: 22.w,
                  image ?? ImagesPath.icFriends,
                  color: Colors.grey,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25.w, bottom: 26.h),
              child: CircleAvatar(
                backgroundColor: Colors.red,
                radius: 7,
                child: Text(number?.toString() ?? '', style: TextStyle(color: Colors.white, fontSize: 10),),
              ),
            )
          ],
        ),
      ),
    );
  }
}