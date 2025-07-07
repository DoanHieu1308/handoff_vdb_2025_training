import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/utils/color_resources.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:handoff_vdb_2025/presentation/pages/item_detail/item_detail_store.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class ItemDetailPage extends StatelessWidget {
  ItemDetailStore store = ItemDetailStore();
  ItemDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;
    return SafeArea(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          color: ColorResources.COLOR_F6F6F7,
        ),
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Container(
              width: 65.w,
              height: 5.h,
              decoration: BoxDecoration(color: ColorResources.COLOR_AFB0AB),
            ),
            SizedBox(height: 15.h),
            Expanded(
              child: ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(overscroll: false),
                child: ListView.separated(
                  controller: store.scrollController,
                  itemBuilder: (context, index) {
                    return _itemDetailCard(index, context);
                  },
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(height: 10.h);
                  },
                  itemCount: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemDetailCard(int index, BuildContext context) {
    return AutoScrollTag(
      key: ValueKey(index),
      controller: store.scrollController,
      index: index,
      child: GestureDetector(
        onTap: (){
          showDialog(
            context: context,
            builder: (_) => Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
              ),
              child: Container(
                padding: EdgeInsets.all(20),
                height: 200.h,
                width: 370.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Text('Confirm unfriending', style: AppText.text14_Inter),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text('You are about to unfriend Quốc Thuỷ. Are you sure you want to proceed?', style: AppText.text12),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      height: 0.5.h,
                      width: 370.w,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: SizedBox(
                                width: 70.w,
                                height: 50.h,
                                child: Center(
                                  child: Text("Cancel", style: TextStyle(
                                    color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500
                                  ),),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Builder(
                                builder: (scaffoldContext) {
                                  return GestureDetector(
                                    onTap: (){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.transparent,
                                          elevation: 0,
                                          behavior: SnackBarBehavior.floating,
                                          duration: Duration(seconds: 4),
                                          content: Container(
                                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(12),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.15),
                                                  blurRadius: 6,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(Icons.check_circle, color: Colors.green, size: 24),
                                                SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    "Successfully unfriended",
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                  },
                                                  child: Text("Undo"),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: SizedBox(
                                      width: 70.w,
                                      height: 50.h,
                                      child: Center(
                                        child: Text("Confirm", style: TextStyle(
                                            color: Colors.blue, fontSize: 15, fontWeight: FontWeight.w500
                                        ),),
                                      ),
                                    ),
                                  );
                                }
                            )
                          ],
                        )
                    )
                  ],
                ),
              ),
            ),
          );
        },
        child: Container(
          height: 50.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: ColorResources.WHITE,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Text("Remove", style: AppText.text14_Inter),
                ),
                Expanded(
                  flex: 2,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: ColorResources.COLOR_F6F6F7,
                    child: Image.asset(
                      height: 20.h,
                      width: 20.w,
                      fit: BoxFit.cover,
                      ImagesPath.icAddFriend,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
