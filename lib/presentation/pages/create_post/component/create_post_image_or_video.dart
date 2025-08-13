import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/extensions/dynamic_extension.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/component/show_image.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/component/show_video.dart';
import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/helper/app_text.dart';
import '../../../../core/helper/size_util.dart';
import '../../../../core/utils/color_resources.dart';
import '../../../../core/utils/images_path.dart';
import '../../account/personal_information/widget/auth_input.dart';

class CreatePostImageOrVideo extends StatelessWidget {
  final store = AppInit.instance.createPostStore;
  final List<dynamic>? listFile;
  final String? title;
  CreatePostImageOrVideo({super.key, this.listFile, this.title});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Column(
          children: [
            AuthInput(
              controller: store.textStore.feelingEditingController,
              hintText: "Hãy nói gì đó về các bức ảnh/video này...",
              maxLine: 2,
              textStyle: AppText.text20_bold,
              focusNode: store.feelingFocusNode,
            ),
            ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              shrinkWrap: true,
              controller: store.mediaStore.scrollController,
              itemCount: listFile?.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                final file = listFile?[index];
                if (file == null) return const SizedBox();
                bool isVideoFile = false;
                bool isUrlFile = false;

                if (file is String) {
                  isVideoFile = file.isVideo;
                  isUrlFile = file.isUrl;
                } else if (file is File) {
                  isVideoFile = file.isVideo;
                  isUrlFile = file.isUrl;
                } else {
                  final path = file.path ?? file.toString();
                  isUrlFile = path.startsWith('http://') || path.startsWith('https://');
                  isVideoFile = path.toLowerCase().endsWith('.mp4') ||
                               path.toLowerCase().endsWith('.mov') ||
                               path.toLowerCase().endsWith('.avi') ||
                               path.toLowerCase().endsWith('.mkv');
                }
                
                return Stack(
                  key: ValueKey(file is String ? file : file.path),
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                      child: isVideoFile
                          ? ShowVideo(
                              fileVideo: file,
                              isNetwork: isUrlFile,
                            )
                          : ShowImage(
                              fileImage: file,
                              isNetwork: isUrlFile,
                            ),
                    ),
                    Positioned(
                      top: 20.h,
                      left: SizeUtil.getMaxWidth() - 40.w,
                      child: buildDeleteButton(
                        onTap: () {
                          store.mediaStore.removeFile(file);
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
                  store.mediaStore.checkFileLimit(context);
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

  GestureDetector buildDeleteButton({required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 25.h,
        width: 25.w,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white70,
        ),
        child: Center(
          child: SetUpAssetImage(
            height: 13.h,
            width: 13.w,
            ImagesPath.icCancel,
            color: Colors.black54,
          ),
        ),
      ),
    );
  }
}
