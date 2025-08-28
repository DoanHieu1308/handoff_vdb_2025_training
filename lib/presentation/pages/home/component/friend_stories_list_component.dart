import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/presentation/pages/home/home_store.dart';

import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/helper/app_text.dart';
import '../../../../core/init/app_init.dart';
import '../../../../core/utils/images_path.dart';

class FriendStoriesListComponent extends StatelessWidget {
  final HomeStore store = AppInit.instance.homeStore;
  FriendStoriesListComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170.h,
      width: double.infinity,
      decoration: BoxDecoration(
        // color: Colors.blue,
      ),
      child: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: Colors.grey,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Observer(
                      builder: (context) {
                        return SizedBox(
                          width: 105.w,
                          height: 170.h,
                          child: SetUpAssetImage(
                            store.profileStore.userProfile.avatar ?? ImagesPath.imgAnhNen,
                            fit: BoxFit.cover,
                          ),
                        );
                      }
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.w, top: 3.h),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.indigo,
                    child: SetUpAssetImage(
                      height: 35.h,
                      width: 35.h,
                      ImagesPath.icPerson,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.w, top: 145.h),
                  child: Text(
                    "Hanh Dieu",
                    style: AppText.text13_bold.copyWith(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
