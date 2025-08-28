import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';

import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/helper/app_sitebox.dart';
import '../../../../core/helper/app_text.dart';
import '../../../../core/helper/size_util.dart';
import '../../../../data/model/post/post_output_model.dart';

class PostReactionOverview extends StatelessWidget {
  final PostOutputModel itemPost;
  const PostReactionOverview({super.key, required this.itemPost});

  @override
  Widget build(BuildContext context) {
    final postItemStore = AppInit.instance.postItemStore;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        height: 25.h,
        width: SizeUtil.getMaxWidth(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child:
                  itemPost.feels != null && itemPost.top2!.isNotEmpty
                      ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Transform.translate(
                            offset: Offset(0, 4),
                            child: SizedBox(
                              width: itemPost.top2 != null && itemPost.top2!
                                                  .where((e) => e.isNotEmpty)
                                                  .length > 1 ? 35 : 20,
                              child: Stack(
                                children: List.generate(
                                  itemPost.top2!.where((e) => e.isNotEmpty).length,
                                  (index) {
                                    final filteredTop2 = itemPost.top2!
                                            .where((e) => e.isNotEmpty)
                                            .toList();
                                    double left = (filteredTop2.length - index - 1) * 15.0;

                                    return Positioned(
                                      left: left,
                                      child: SizedBox(
                                        height: 17,
                                        width: 17,
                                        child: SetUpAssetImage(
                                          postItemStore.feelNames[filteredTop2[index]] ?? "",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          AppSiteBox.w3,
                          Text("${itemPost.totalFeel}", style: AppText.text12),
                        ],
                      )
                      : SizedBox(),
            ),
            Expanded(
              flex: 3,
              child:
                  itemPost.comments != 0
                      ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            itemPost.comments.toString() ?? '',
                            style: AppText.text12,
                          ),
                          const SizedBox(width: 3),
                          Text("bình luận", style: AppText.text11),
                        ],
                      )
                      : SizedBox(),
            ),
            Expanded(
              flex: 3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("88", style: AppText.text12),
                  const SizedBox(width: 3),
                  Text("lượt chia sẻ", style: AppText.text11),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("12k", style: AppText.text12),
                  const SizedBox(width: 3),
                  Text("lượt xem", style: AppText.text11),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
