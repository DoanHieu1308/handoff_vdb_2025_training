import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/enums/auth_enums.dart';
import '../../../../core/helper/app_text.dart';
import '../../../../core/helper/size_util.dart';
import '../../../../core/init/app_init.dart';
import '../../../../core/utils/color_resources.dart';
import '../../../../core/utils/images_path.dart';
import '../../../../core/utils/navigation_helper.dart';
import 'build_drawer.dart';

class LeadProfile extends StatelessWidget {
  final store = AppInit.instance.profileStore;
  LeadProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [buildBackgroundImage(context), _buildAvatar(context)],
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.only(left: 15.w),
              child: Text(
                store.userProfile.name ?? "",
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
                    style: AppText.text14.copyWith(color: Colors.grey),
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
                  Icon(Icons.add_circle_outline, color: Colors.white),
                  SizedBox(width: 5.w),
                  Text(
                    "Thêm vào tin",
                    style: AppText.text14_Inter.copyWith(color: Colors.white),
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
                          Icon(Icons.edit, color: Colors.black, size: 17),
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
                          child: Text("...", style: AppText.text16_bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
          ],
        );
      },
    );
  }

  Stack buildBackgroundImage(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200.h,
          width: SizeUtil.getMaxWidth(),
          color: Colors.transparent,
          child: SetUpAssetImage(
              "https://picsum.photos/300/200?random=2",
              fit: BoxFit.cover),
        ),
        Positioned(
          right: 15.w,
          bottom: 70.h,
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
              buildShowDrawerSettingProfile(context);
            },
          ),
        ),
        Container(height: 250.h),
      ],
    );
  }

  Future<Object?> buildShowDrawerSettingProfile(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Drawer",
      pageBuilder: (context, animation1, animation2) {
        return buildDrawer(context, store, store.userProfile);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(-1, 0),
            end: Offset(0, 0),
          ).animate(animation),
          child: child,
        );
      },
      transitionDuration: Duration(milliseconds: 250),
    );
  }

  Positioned _buildAvatar(BuildContext context) {
    return Positioned(
      left: 10.w,
      bottom: 0.h,
      child: Observer(
        builder: (context) {
          return Stack(
            children: [
              CircleAvatar(
                radius: 90,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: SizedBox(
                    width: 180,
                    height: 180,
                    child: SetUpAssetImage(
                      store.userProfile.avatar ?? ImagesPath.icPerson,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 1.w,
                bottom: 12.h,
                child: GestureDetector(
                  onTap: () {
                    NavigationHelper.navigateTo(context, AuthRoutes.CAMERA);
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: ColorResources.LIGHT_GREY.withOpacity(0.7),
                    child: Icon(Icons.camera_alt),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
