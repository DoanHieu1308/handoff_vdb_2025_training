import 'package:draggable_fab/draggable_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';

import '../../../../core/utils/color_resources.dart';
import '../../../../core/utils/images_path.dart';

class ChatBotActionButton extends StatelessWidget {
  final Function() onPress;
  const ChatBotActionButton({super.key, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return DraggableFab(
      child: Container(
        margin: EdgeInsets.fromLTRB(0,100.h,0,0),
        child: SizedBox(
          height: 55.h,
          width: 80.w,
          child: DecoratedBox(
            decoration:const BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.indigoAccent,
                      blurRadius: 6,
                      offset: Offset(-0.5, 3)
                  )
                ]
            ),
            child: FloatingActionButton(
              onPressed: onPress,
              backgroundColor: ColorResources.COLOR_0B142E,
              shape: CircleBorder(
                side: BorderSide(
                    width: 0.63.w,
                    color: ColorResources.PRIMARY_1
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 20.w,
                    child: SetUpAssetImage(
                      ImagesPath.geniusTouch,
                      height: 50.h,
                      width: 60.w,
                    ),),
                  Positioned(
                      left: 18.w,
                      top: 10.h,
                      child: SetUpAssetImage(
                        ImagesPath.messTouch,
                        height: 20.h,
                        width: 20.w,
                      )
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
