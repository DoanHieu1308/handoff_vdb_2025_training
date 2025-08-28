import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/create_post_store.dart';

import '../../../../core/helper/app_text.dart';
import '../../../../core/helper/size_util.dart';
import '../../../../core/utils/color_resources.dart';
import '../../account/personal_information/widget/auth_input.dart';

class CreatePostText extends StatelessWidget {
  final TextEditingController feelingEditingController;
  final bool hasText;
  final FocusNode feelingFocusNode;
  CreatePostText({super.key, required this.feelingEditingController, required this.hasText, required this.feelingFocusNode});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 280.h,
          width: SizeUtil.getMaxWidth(),
          decoration:const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFE91E63), Color(0xFF2196F3)],
            ),
          ),
        ),
        AuthInput(
          controller: feelingEditingController,
          hintText: "Bạn đang nghĩ gì?",
          maxLine: hasText ? 7 : 10,
          hintStyle: AppText.text22.copyWith(color: ColorResources.LIGHT_GREY),
          textStyle: AppText.text23_bold,
          fillColor: Colors.transparent,
          focusNode: feelingFocusNode,
        ),
      ],
    );
  }
}
