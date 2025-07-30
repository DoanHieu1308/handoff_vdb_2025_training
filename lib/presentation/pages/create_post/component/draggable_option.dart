import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/helper/size_util.dart';
import 'package:handoff_vdb_2025/core/utils/color_resources.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/create_post_store.dart';


class DraggableOption extends StatefulWidget {
  final CreatePostStore store;
  const DraggableOption({super.key, required this.store});

  @override
  State<DraggableOption> createState() => _DraggableOptionState();
}

class _DraggableOptionState extends State<DraggableOption> {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: widget.store.initialChildSize,
          minChildSize: 0.14,
          maxChildSize: 0.63,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: ListView.builder(
                controller: scrollController,
                itemCount: 9,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      width: SizeUtil.getMaxWidth(),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Icon(
                              Icons.keyboard_arrow_up_outlined,
                              size: 24,
                              color: Colors.black.withOpacity(0.8),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      Container(
                        height: 1.h,
                        width: SizeUtil.getMaxWidth(),
                        color: ColorResources.LIGHT_GREY.withOpacity(0.5),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        child: GestureDetector(
                          onTap: () => widget.store.onTapOptionDraggable(context, index-1),
                          child: Row(
                            children: [
                              SetUpAssetImage(
                                  widget.store.listNameItemDraggable[index-1]['image'],
                                  height: 30.h,
                                  width: 30.w,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                widget.store.listNameItemDraggable[index-1]['name'],
                                style: AppText.text14,
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            );
          },
        );
      }
    );
  }
}

