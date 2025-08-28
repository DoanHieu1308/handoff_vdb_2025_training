import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../../core/helper/app_text.dart';
import '../../../../../core/helper/size_util.dart';
import '../../../../../core/utils/color_resources.dart';
import '../../../../../core/utils/images_path.dart';
import '../chat_store.dart';

class WriteChat extends StatelessWidget {
  final ChatStore chatStore;
  const WriteChat({
    super.key,
    required this.chatStore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 135.h,
      width: SizeUtil.getMaxWidth(),
      color: ColorResources.WHITE,
      child: Column(
        children: [
          SizedBox(height: 5.h),
          Container(
            width: 42.w,
            height: 4.h,
            decoration: const BoxDecoration(
              color: ColorResources.COLOR_D9D9D9,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          SizedBox(height: 5.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Observer(
                builder: (context) {
                  return Stack(
                    children: [
                      Row(crossAxisAlignment: chatStore.isHasInput
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 10.h),
                              child: TextFormField(
                                controller: chatStore.writeMessController,
                                focusNode: chatStore.chatFocusNode,
                                style: AppText.text14_Inter,
                                decoration: InputDecoration(
                                  hintText: 'Viết tin nhắn của bạn vào đây',
                                  hintStyle: AppText.text14_Inter.copyWith(
                                    color: ColorResources.HINT_TEXT,
                                  ),
                                  border: InputBorder.none,
                                  counterStyle: const TextStyle(
                                    color: ColorResources.COLOR_918F95,
                                  ),
                                ),
                                maxLines: 3,
                                maxLength: chatStore.isHasInput ? 1000 : null,
                                cursorColor: ColorResources.COLOR_5D4D87,
                                onChanged: (val) {
                                  chatStore.isHasInput = val.isNotEmpty;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {},
                            child: SetUpAssetImage(
                              chatStore.isHasInput
                                  ? ImagesPath.icSend
                                  : ImagesPath.icSendNoFocus,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                      Positioned(
                        bottom: 0.h,
                        left: 0.w,
                        child: GestureDetector(
                          onTap: () {
                            // controller.onTapScan(context);
                          },
                          child: SetUpAssetImage(ImagesPath.icScan),
                        ),
                      ),
                      Visibility(
                        visible: !chatStore.isHasInput,
                        child: Positioned(
                          bottom: 0.h,
                          left: 36.w,
                          child: GestureDetector(
                            onTap: () async {
                              // final String result = await showModalBottomSheet(
                              //   context: context,
                              //   builder: (BuildContext context) {
                              //     return const SpeedToText();
                              //   },
                              // );
                              // if (result.isNotEmpty) {
                              //   chatStore.writeMessController.text = result;
                              //   chatStore.isHasInput = true;
                              // } else {
                              //   log('User canceled A.');
                              // }
                            },
                            child: SetUpAssetImage(ImagesPath.icMic),
                          ),
                        ),
                      ),
                      Visibility(
                          visible: !chatStore.isHasInput,
                          child: Positioned(
                            bottom: 0.h,
                            right: 7.w,
                            child: const Text(
                              "0/1000", style: TextStyle(fontSize: 12, color: ColorResources.HINT_TEXT),
                            ),
                          )
                      )
                    ],
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}