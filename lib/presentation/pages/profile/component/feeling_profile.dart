import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/helper/app_text.dart';
import '../../../../core/init/app_init.dart';
import '../../../../core/utils/images_path.dart';

class FeelingProfile extends StatelessWidget {
  final store = AppInit.instance.profileStore;
  FeelingProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Column(
          children: [
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
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: SizedBox(
                        height: 40.h,
                        width: 41.w,
                        child: SetUpAssetImage(
                          store.userProfile.avatar ?? ImagesPath.icPerson,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                Expanded(
                  flex: 16,
                  child: Text("Bạn đang nghĩ gì?", style: AppText.text15),
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
          ],
        );
      },
    );
  }
}
