import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/helper/size_util.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/component/post_advanced_options_setting/post_options_setting_store.dart';
import '../../../../../../core/helper/app_text.dart';
import '../../../../../../core/utils/color_resources.dart';

class StatusPostPage extends StatefulWidget {

  const StatusPostPage({super.key});

  @override
  State<StatusPostPage> createState() => _StatusPostPageState();
}

class _StatusPostPageState extends State<StatusPostPage> {
  PostOptionsSettingStore store = AppInit.instance.postOptionsSettingStore;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios_new_outlined, size: 22)
        ),
        title: Text("Đối tượng của bài viết", style: AppText.text18),
      ),
      body: Column(
          children: [
            buildIntro(),
            buildObject(),
            Spacer(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.w),
              height: 50,
              width: SizeUtil.getMaxWidth(),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.indigoAccent.shade400
              ),
              child: Center(child: Text("Xong", style: AppText.text18.copyWith(color: Colors.white),)),
            ),
            SizedBox(height: 20.h,),
          ]
      ),
    );
  }

  Padding buildIntro() {
    return Padding(
      padding: EdgeInsets.only(left: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: 5.h),
            height: 1.h,
            decoration: BoxDecoration(color: ColorResources.LIGHT_GREY),
          ),
          Text("Ai có thể xem bài viết của bạn?", style: AppText.text14_bold),
          SizedBox(height: 5.h),
          Text(
            "Bài viết của bạn có thể hiển thị trên Bảng tin, trang cá \nnhân, "
            "Messager và trong kết quả tìm kiếm",
            style: AppText.text12.copyWith(color: Colors.black54),
          ),
          SizedBox(height: 5.h),
          Text(
            "Tuy đối tượng mặc định là Chỉ mình tôi, nhưng bạn có \nthể "
            "thay đổi đối tượng của riêng bài viết này",
            style: AppText.text12.copyWith(color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget buildObject() {
    return Observer(
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(left: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.h),
                height: 1.h,
                decoration: BoxDecoration(color: ColorResources.LIGHT_GREY),
              ),
              Text("Chọn đối tượng", style: AppText.text16_Inter),
              SizedBox(height: 5.h),
              buildItemStatus(
                onTap: (){
                   store.onChangedStatus(index: 0);
                },
                image: ImagesPath.icGlobe,
                title: "Công khai",
                subTitle: "Bất kì ai",
                isSelected: store.currentStatus == 0
              ),
              buildItemStatus(
                onTap: (){
                  store.onChangedStatus(index: 1);
                },
                image: ImagesPath.icFriendOutsize,
                title: "Bạn bè",
                subTitle: "Bạn bè của bạn",
                isSelected: store.currentStatus == 1
              ),
              buildItemStatus(
                onTap: (){
                  store.onChangedStatus(index: 2);
                },
                image: ImagesPath.icLockOutsize,
                title: "Chỉ mình tôi",
                subTitle: "Chỉ mình tôi",
                isSelected: store.currentStatus == 2
              ),
            ],
          ),
        );
      }
    );
  }

  Widget buildItemStatus({
    required VoidCallback onTap,
    required String image,
    required String title,
    required String subTitle,
    required bool isSelected,
  }) {
    return Observer(
      builder: (context) {
        return Column(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Container(
                height: 65.h,
                width: SizeUtil.getMaxWidth(),
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 0.2, color: Colors.grey),
                      ),
                      child: Center(
                        child: Icon(Icons.check_circle, color: isSelected ? Colors.blue : Colors.white),
                      ),
                    ),
                    SizedBox(width: 20.w),
                    SetUpAssetImage(height: 25.h, width: 25.w, image),
                    SizedBox(width: 10.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: AppText.text14),
                        Text(
                          subTitle,
                          style: AppText.text12.copyWith(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 18.h),
              height: 1.h,
              decoration: BoxDecoration(color: ColorResources.LIGHT_GREY),
            ),
          ],
        );
      }
    );
  }
}
