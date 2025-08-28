import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/config/routes/route_path/auth_routers.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/enums/enums.dart';
import 'package:handoff_vdb_2025/core/helper/app_divider.dart';
import 'package:handoff_vdb_2025/core/helper/size_util.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:handoff_vdb_2025/data/model/post_option/post_option_item.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post_advanced_options_setting/create_post_advanced_options_setting_store.dart';
import '../../../../../../core/helper/app_text.dart';
import '../../../../../../core/utils/color_resources.dart';

class StatusPostPage extends StatefulWidget {

  const StatusPostPage({super.key});

  @override
  State<StatusPostPage> createState() => _StatusPostPageState();
}

class _StatusPostPageState extends State<StatusPostPage> {
  CreatePostAdvancedOptionSettingStore store = AppInit.instance.createPostAdvancedOptionSettingStore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: (){
              router.pop();
            },
            child: Icon(Icons.arrow_back_ios_new_outlined, size: 22)
        ),
        title: Text("Đối tượng của bài viết", style: AppText.text18),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildIntro(),
                    buildObject(),
                  ],
                ),
              ),
            ),
            // Button "Xong" luôn ở dưới cùng
            GestureDetector(
              onTap: (){
                final index = store.listNameItemOption.indexWhere((e) => e.type == PostOptionType.onlyMe);
                if (index != -1) {
                  final pair = store.nameAndIconFromStatus(store.currentStatus);
                  store.listNameItemOption[index] = PostOptionItem(
                    name: pair.name,
                    icon: pair.icon,
                    type: PostOptionType.onlyMe,
                  );
                }
                router.pop();
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10.h),
                height: 50,
                width: SizeUtil.getMaxWidth(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.indigoAccent.shade400
                ),
                child: Center(
                  child: Text("Xong", style: AppText.text18.copyWith(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
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
          padding: EdgeInsets.only(left: 5.w, right: 5.w, bottom: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppDivider.v5,
              Text("Chọn đối tượng", style: AppText.text16_Inter),
              SizedBox(height: 10.h),
              buildItemStatus(
                onTap: (){
                   store.onChangedStatus(status: PUBLIC);
                },
                image: ImagesPath.icGlobe,
                title: "Công khai",
                subTitle: "Bất kì ai",
                isSelected: store.currentStatus == PUBLIC
              ),
              buildItemStatus(
                onTap: (){
                  store.onChangedStatus(status: FRIEND);
                },
                image: ImagesPath.icFriendOutsize,
                title: "Bạn bè",
                subTitle: "Bạn bè của bạn",
                isSelected: store.currentStatus == FRIEND
              ),
              buildItemStatus(
                onTap: (){
                  store.onChangedStatus(status: PRIVATE);
                },
                image: ImagesPath.icLockOutsize,
                title: "Chỉ mình tôi",
                subTitle: "Chỉ mình tôi",
                isSelected: store.currentStatus == PRIVATE
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            constraints: BoxConstraints(
              minHeight: 47.h,
              maxHeight: 60.h,
            ),
            width: SizeUtil.getMaxWidth(),
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            child: Row(
              children: [
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 0.2, color: Colors.grey),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check_circle, 
                      color: isSelected ? Colors.blue : Colors.white,
                      size: 18.w,
                    ),
                  ),
                ),
                SizedBox(width: 20.w),
                SetUpAssetImage(height: 25.h, width: 25.w, image),
                SizedBox(width: 10.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title, 
                        style: AppText.text14,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        subTitle,
                        style: AppText.text12.copyWith(color: Colors.grey),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
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
}

