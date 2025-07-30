import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import 'package:handoff_vdb_2025/presentation/pages/profile/profile_store.dart';

import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/helper/app_text.dart';
import '../../../../core/helper/size_util.dart';
import '../../../../core/utils/images_path.dart';

Widget buildDrawer(BuildContext context, ProfileStore store, UserModel userProfile) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Material(
      color: Colors.transparent,
      child: Container(
        width: 320.w,
        height: SizeUtil.getMaxHeight(),
        decoration: BoxDecoration(color: Colors.white),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50.h),
              Container(
                height: 200.h,
                width: 300.w,
                margin: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 15.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 22,
                            child: SetUpAssetImage(ImagesPath.icPerson),
                          ),
                          SizedBox(width: 10.w),
                          Text(userProfile.name ?? "Ten", style: AppText.text16_bold),
                          Spacer(),
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.grey.shade200,
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                  left: 20.w,
                                  bottom: 30.h,
                                ),
                                height: 20.h,
                                width: 20.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: Center(
                                  child: Text(
                                    "9+",
                                    style: AppText.text10_Inter.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 1.h,
                      width: 300.w,
                      color: Colors.grey.shade200,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 8.h,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle,
                            size: 40,
                            color: Colors.grey.shade600,
                          ),
                          SizedBox(width: 5.w),
                          SizedBox(
                            height: 100.h,
                            width: 235.w,
                            child: Column(
                              children: [
                                Text(
                                  "Tao trang ca nhan hoac Trang mơi",
                                  style: AppText.text16_bold.copyWith(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  "Chuyen giua cac trang cá nhan mà không phải đăng nhập lại",
                                  style: AppText.text12_Inter.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.w, top: 15.h),
                child: Text("Lỗi tắt của bạn", style: AppText.text14_bold),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: SizedBox(
                  height: 450.h,
                  child: GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: List.generate(8, (index) {
                      return Container(
                        height: 50.h,
                        width: 70.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 0.5,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SetUpAssetImage(
                                height: 50.h,
                                width: 50.w,
                                ImagesPath.icEmail,
                                fit: BoxFit.cover,
                                color: Colors.indigo,
                              ),
                              Text("Nhóm", style: AppText.text14_bold),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15.w),
                height: 40.h,
                width: 320.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade200,
                ),
                child: Center(
                  child: Text("Xem thêm", style: AppText.text14_bold),
                ),
              ),
              buildItemDrawer(
                  icon: Icons.question_mark_sharp,
                  name: "Trợ giúp và hỗ trợ"
              ),
              buildItemDrawer(
                  icon: Icons.settings,
                  name: "Cài đặt và quyền riêng tư"
              ),
              SizedBox(height: 20.h),
              GestureDetector(
                onTap: (){
                  store.logOut(context: context);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 15.w),
                  height: 40.h,
                  width: 320.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey.shade200,
                  ),
                  child: Center(
                    child: Text("Đăng xuất", style: AppText.text14_bold),
                  ),
                ),
              ),
              SizedBox(height: 20.h), // Thêm padding bottom
            ],
          ),
        ),
      ),
    ),
  );
}

Container buildItemDrawer({required IconData icon, required String name}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
    height: 60.h,
    width: 320.w,
    child: Column(
      children: [
        Container(height: 1.h, width: 320.w, color: Colors.grey.shade300),
        SizedBox(height: 10.h),
        Row(
          children: [
            Icon(icon, size: 23),
            SizedBox(width: 10.h),
            Text(name, style: AppText.text16_bold),
            Spacer(),
            Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ],
    ),
  );
}