import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';

import '../../../core/utils/color_resources.dart';
import '../../widget/post_status.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20.h,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  flex: 4,
                  child: CircleAvatar(
                    radius: 25,
                    child: SetUpAssetImage(
                      ImagesPath.icPerson
                    ),
                  ),
                ),
                Container(
                  height: 40.h,
                  width: 250.w,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 20.w, top: 7.h, bottom: 5.h),
                      child: Text("Bạn dang nghi gi?", style: AppText.text16,)),
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
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.h),
              height: 3.h,
              decoration: BoxDecoration(
                color: ColorResources.LIGHT_GREY,
              ),
            ),
            Container(
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
                          margin: EdgeInsets.symmetric(horizontal: 5.w),
                            width: 105.w,
                            height: 170.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            color: Colors.grey
                          ),
                          child: SetUpAssetImage(
                              width: 105.w,
                              height: 170.h,
                              ImagesPath.imgAnhNen,
                              fit: BoxFit.cover,
                          )
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 10.w, top: 5.h),
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
                          padding: EdgeInsets.only(left: 10.w, top: 145.h),
                          child: Text("Hanh Dieu", style: AppText.text13_bold.copyWith(color: Colors.white),)
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.h),
              height: 3.h,
              decoration: BoxDecoration(
                color: ColorResources.LIGHT_GREY,
              ),
            ),
            PostStatus(),
          ],
        ),
      ),
    );
  }
}


