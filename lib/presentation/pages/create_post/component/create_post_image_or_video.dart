import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/extensions/string_extension.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/create_post_store.dart';

import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/base_widget/video/set_up_video_player.dart';
import '../../../../core/helper/app_text.dart';
import '../../../../core/helper/size_util.dart';
import '../../../../core/utils/color_resources.dart';
import '../../../../core/utils/images_path.dart';
import '../../account/personal_information/widget/auth_input.dart';

class CreatePostImageOrVideo extends StatelessWidget {
  CreatePostStore store;
  CreatePostImageOrVideo({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Column(
          children: [
            AuthInput(
              controller: store.feelingEditingController,
              hintText: "Hãy nói gì đó về các bức ảnh/video này...",
              maxLine: 2,
              hintStyle: AppText.text14.copyWith(color: ColorResources.GREY),
              textStyle: AppText.text20_bold,
              focusNode: store.feelingFocusNode,
            ),
            ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              shrinkWrap: true,
              controller: store.scrollController,
              itemCount: store.listFile.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                final file = store.listFile[index];
                final isVideo = file.path.isVideoFile;

                return Stack(
                  key: ValueKey(file.path),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                      child: isVideo ? buildShowVideo(file) : buildShowImage(file),
                    ),
                    Positioned(
                      top: 15.h,
                      left: SizeUtil.getMaxWidth() - 50.w,
                      child: buildDeleteButton(
                        onTap: () {
                          store.removeFile(file);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: (){
                  store.checkFileLimit(context);
              },
              child: SizedBox(
                height: 130.h,
                width: 120.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 40.h,
                      width: 40.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorResources.LIGHT_GREY,
                      ),
                      child: Center(
                        child: SetUpAssetImage(
                          height: 23.h,
                          width: 23.w,
                          ImagesPath.icAddImageVideo,
                        ),
                      ),
                    ),
                    Text("Thêm ảnh/\nvideo khác", style: AppText.text12),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildShowVideo(File fileVideo) {
    return SizedBox(
      width: SizeUtil.getMaxWidth(),
      child: SetUpVideoPlayer(
        key: UniqueKey(),
        fileVideo: fileVideo,
        videoUrl: '',
        autoPlay: true,
        looping: true,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildShowImage(File fileImage) {
    return Observer(
        builder: (context) {
          return FutureBuilder<Size>(
            future: store.getImageSize(fileImage),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final imageSize = snapshot.data!;
                final aspectRatio = imageSize.width / imageSize.height;
                return AspectRatio(
                  aspectRatio: aspectRatio,
                  child: Image.file(
                    key: UniqueKey(),
                    fileImage,
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.high,
                    errorBuilder: (context, error, stackTrace) {
                      return Text('Image load error');
                    },
                  ),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        }
    );
  }

  GestureDetector buildDeleteButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 25.h,
        width: 25.w,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.transparent,
        ),
        child: Center(
          child: SetUpAssetImage(
            height: 15.h,
            width: 15.w,
            ImagesPath.icCancel,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
