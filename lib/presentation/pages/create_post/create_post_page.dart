import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/base_widget/video/set_up_video_player.dart';
import 'package:handoff_vdb_2025/core/extensions/string_extension.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/helper/size_util.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/color_resources.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/component/draggable_option.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/create_post_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/component/widget_option.dart';
import '../../../config/routes/route_path/auth_routers.dart';
import 'component/bottom_bar_create_post.dart';
import 'component/create_post_image_or_video.dart';
import 'component/create_post_text.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  CreatePostStore store = AppInit.instance.createPostStore;

  @override
  void initState() {
    store.init();
    super.initState();
  }

  @override
  void dispose() {
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
              FocusScope.of(context).unfocus();
            },
            child: const Icon(Icons.arrow_back_ios_new_outlined, size: 22)),
        title: Text("Tạo bài viết", style: AppText.text18),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: Container(
              height: 35.h,
              width: 70.w,
              decoration: BoxDecoration(
                color: ColorResources.LIGHT_GREY.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  "ĐĂNG",
                  style: AppText.text14_bold.copyWith(
                    color: Colors.black.withValues(alpha: 0.4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Observer(
      builder: (context) {
        return Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      buildBodyPost(),
                      Visibility(
                        visible:
                            !store.hasText && !store.hasVideo && !store.hasImage,
                        child: DraggableOption(store: store),
                      ),
                    ],
                  ),
                ),
                if (store.hasText || store.hasImage || store.hasVideo)
                  buildBottomNavigationBar(),
              ],
            );
      }
    );
  }

  Widget buildBodyPost() {
    return Observer(
      builder: (context) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 5.h),
                height: 1.h,
                decoration: const BoxDecoration(color: ColorResources.LIGHT_GREY),
              ),
              buildOptionPost(),
              Visibility(
                visible: store.hasImage || store.hasVideo,
                child: CreatePostImageOrVideo(store: store),
              ),
              Visibility(
                visible: !store.hasImage && !store.hasVideo,
                child: CreatePostText(store: store),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget buildBottomNavigationBar() {
    return Observer(
      builder: (context) {
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
              BottomBarCreatePost(
                onTap: () {
                  store.checkFileLimit(context);
                },
                imagePath: ImagesPath.icPhotos,
              ),
              BottomBarCreatePost(
                onTap: () {
                  Navigator.of(context).pushNamed(AuthRouters.TAG_FRIEND);
                },
                imagePath: ImagesPath.icTag,
              ),
              BottomBarCreatePost(
                onTap: () {

                },
                imagePath: ImagesPath.icFeeling,
              ),
              BottomBarCreatePost(
                onTap: () {

                },
                imagePath: ImagesPath.icCheckIn,
              ),
              BottomBarCreatePost(
                onTap: () {

                },
                imagePath: ImagesPath.icMore,
              ),
            ],
          ),
        );
      },
    );
  }

  Row buildOptionPost() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: CircleAvatar(
            radius: 25,
            child: ClipOval(
              child: SetUpAssetImage(
                ImagesPath.icPerson,
                height: 50.h,
                width: 50.w,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 7,
          child: SizedBox(
            height: 130.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Đoàn Hiếu", style: AppText.text16_bold),
                SizedBox(height: 5.h),
                Wrap(
                  runSpacing: 7.h,
                  spacing: 6.w,
                  children:
                      store.listNameItemOption.map<Widget>((option) {
                        return WidgetOption(
                          onTap: () {
                            print(option["valueNumber"]);
                            store.onTapOptionPost(
                              context,
                              option["valueNumber"],
                            );
                          },
                          name: option['name'],
                          icon: option['image'],
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
