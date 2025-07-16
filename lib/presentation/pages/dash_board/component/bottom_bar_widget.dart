import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';

import '../../../../core/helper/app_text.dart';
import '../../../../core/utils/color_resources.dart';


class BottomBarWidget extends StatefulWidget {
  final String imagePath;
  final bool isSelected;
  final VoidCallback? onTap;
  const BottomBarWidget({Key? key,
    required this.onTap,
    required this.imagePath,
    required this.isSelected,
  }) : super(key: key);

  @override
  State<BottomBarWidget> createState() => _BottomBarWidgetState();
}

class _BottomBarWidgetState extends State<BottomBarWidget> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: width / 4 - 10.w,
        height: 60.h ,
        color: Colors.transparent,
        child: Column(
          children: [
            SizedBox(
              height: 2.h,
            ),
            SetUpAssetImage(
              widget.imagePath,
              width: 24.w,
              height: 24.h,
              color:  widget.isSelected
                  ? ColorResources.COLOR_0956D6
                  : ColorResources.COLOR_071A52,
              fit: BoxFit.fill,
            ),
          ],
        ),
      ),
    );
  }
}
