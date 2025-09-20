import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/utils/color_resources.dart';
import '../chat_bot_store.dart';

class SuggestionsPanel extends StatelessWidget {
  final ChatBotStore chatBotStore;
  
  const SuggestionsPanel({
    super.key,
    required this.chatBotStore,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        if (!chatBotStore.showSuggestions || chatBotStore.suggestedQuestions.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          margin: EdgeInsets.only(bottom: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'Gợi ý câu hỏi:',
                  style: AppText.text12.copyWith(
                    color: ColorResources.HINT_TEXT,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: chatBotStore.suggestedQuestions.map((suggestion) {
                    return Container(
                      margin: EdgeInsets.only(right: 8.w),
                      child: GestureDetector(
                        onTap: () => chatBotStore.selectSuggestion(suggestion),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: ColorResources.WHITE,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: ColorResources.COLOR_16B978.withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                size: 14.sp,
                                color: ColorResources.COLOR_16B978,
                              ),
                              SizedBox(width: 4.w),
                              Flexible(
                                child: Text(
                                  suggestion,
                                  style: AppText.text12.copyWith(
                                    color: ColorResources.COLOR_16B978,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
