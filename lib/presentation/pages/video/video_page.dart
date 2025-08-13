import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/base_widget/video/set_up_video_player.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:handoff_vdb_2025/presentation/pages/video/video_store.dart';

import '../../../core/helper/size_util.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final VideoStore store = AppInit.instance.videoStore;

  @override
  void initState() {
    super.initState();
    store.init();
    store.pageController.addListener(() {
      setState(() {
        store.currentPage = store.pageController.page ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: double.infinity,
          width: SizeUtil.getMaxWidth(),
          child: PageView.builder(
            controller: store.pageController,
            scrollDirection: Axis.vertical,
            itemCount: 10,
            itemBuilder: (context, index) {
              double scale =
                  (index - store.currentPage).abs() < 1
                      ? 1 - (index - store.currentPage).abs() * 0.03
                      : 0.97;
              return Transform.scale(
                scale: scale,
                child: Container(
                  height: SizeUtil.getMaxHeight(),
                  color: Colors.black,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: SizeUtil.getMaxHeight(),
                        child: Center(
                          child: SetUpVideoPlayer(
                            videoUrl: ImagesPath.Video2,
                            isAsset: true,
                            autoPlay: true,
                            looping: true,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: SizeUtil.getMaxHeight() - 430.h,
                        ),
                        child: SizedBox(
                          height: 300.h,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 10,
                                child: Column(
                                  children: [
                                    Spacer(),
                                    SizedBox(
                                      width: 320,
                                      height: 120,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                child: SetUpAssetImage(
                                                  ImagesPath.icPerson,
                                                ),
                                              ),
                                              SizedBox(width: 10.w),
                                              Text(
                                                "Pets IsIand",
                                                style: AppText.text14_bold
                                                    .copyWith(
                                                      color: Colors.white,
                                                    ),
                                              ),
                                              SizedBox(width: 5.w),
                                              SetUpAssetImage(
                                                height: 15.h,
                                                width: 15.w,
                                                ImagesPath.icEarth,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 5.w),
                                              Container(
                                                height: 27.h,
                                                width: 80.w,
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    width: 1,
                                                    color: Colors.grey,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.transparent,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Theo dõi",
                                                    style: AppText.text14
                                                        .copyWith(
                                                          color: Colors.white,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12.h),
                                          Text(
                                            "Cắt cỏ he không phải chuyen dua phai biet dỗ ngot trước khi ra tay (279)",
                                            style: AppText.text14.copyWith(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  width: 50,
                                  height: 320,
                                  child: Column(
                                      children: [
                                        _buildItemIcon(
                                          icon: ImagesPath.icLike,
                                          number: "25.620"
                                        ),
                                        _buildItemIcon(
                                            icon: ImagesPath.icComment,
                                            number: "250"
                                        ),
                                        _buildItemIcon(
                                            icon: ImagesPath.icShare,
                                            number: "180"
                                        ),
                                        _buildItemIcon(
                                            icon: ImagesPath.icMessenger,
                                            number: "Gửi"
                                        ),
                                        SizedBox(
                                          height: 30.h,
                                          width: 50.h,
                                          child: Center(
                                            child: Text("...", style: AppText.text25_bold.copyWith(color: Colors.white),),
                                          ),
                                        )
                                      ]
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 20.w,
            right: 5.w,
            top: 10.h,
            bottom: 10.h,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 4,
                child: Text(
                  "Dành cho bạn",
                  style: AppText.text16.copyWith(color: Colors.white),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  "Khám phá",
                  style: AppText.text16.copyWith(color: Colors.white),
                ),
              ),
              Expanded(
                flex: 1,
                child: Icon(size: 35, Icons.search, color: Colors.white),
              ),
              SizedBox(width: 5.w),
              Expanded(
                flex: 1,
                child: SetUpAssetImage(
                  height: 30.h,
                  width: 30.w,
                  ImagesPath.icPerson,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  SizedBox _buildItemIcon({
    required String icon,
    required String number}) {
    return SizedBox(
      height: 60.h,
      width: 50.h,
      child: Column(
        children: [
          SetUpAssetImage(
            height: 30.h,
            width: 30.w,
            icon,
            color: Colors.white,
          ),
          SizedBox(height: 2.h,),
          Text(
            number,
            style: AppText.text10_Inter.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
