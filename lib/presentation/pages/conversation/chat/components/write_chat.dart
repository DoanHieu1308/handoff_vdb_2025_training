import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/config/routes/route_path/auth_routers.dart';
import 'package:handoff_vdb_2025/core/enums/auth_enums.dart';
import 'package:handoff_vdb_2025/core/enums/message_content_type.dart';
import 'package:handoff_vdb_2025/core/helper/app_sitebox.dart';
import 'package:handoff_vdb_2025/core/helper/app_tap_animation.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';
import 'package:handoff_vdb_2025/data/model/chat/chat_message_model.dart';
import 'package:mobx/mobx.dart';
import '../../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../../core/helper/app_text.dart';
import '../../../../../core/helper/size_util.dart';
import '../../../../../core/utils/color_resources.dart';
import '../../../../../core/utils/images_path.dart';
import '../chat_store.dart';

class WriteChat extends StatefulWidget {
  final ChatStore chatStore;
  const WriteChat({
    super.key,
    required this.chatStore,
  });

  @override
  State<WriteChat> createState() => _WriteChatState();
}

class _WriteChatState extends State<WriteChat> {
  late ReactionDisposer _reactionDisposer;

  @override
  void initState() {
    super.initState();
    _reactionDisposer = autorun((_) {
      if (widget.chatStore.replyMessage != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(widget.chatStore.chatFocusNode);

            Future.delayed(Duration(milliseconds: 100), () {
              if (mounted) {
                SystemChannels.textInput.invokeMethod('TextInput.show');
              }
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _reactionDisposer();
    super.dispose();
  }

  void _onSendTap(String message, ChatMessageModel? reply, MessageContentType messageType) async {
    await widget.chatStore.sendMessage(
      content: message,
      type: messageType,
      replyMessage: reply,
    );
    await widget.chatStore.sendTypingIndicator(false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeUtil.getMaxWidth(),
      color: ColorResources.WHITE,
      child: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 20.w, top: 10.h),
        child: KeyboardVisibilityBuilder(
            builder: (context, isVisible) {
              if(isVisible){
                widget.chatStore.showItemAction = "";
              }
              return Observer(
                  builder: (context) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if(!isVisible)
                      Transform.translate(
                        offset: Offset(0, -5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AppTapAnimation(
                              enabled: true,
                              onTap: (){
                                if(widget.chatStore.showItemAction != ACTION_MORE){
                                  widget.chatStore.showItemAction = ACTION_MORE;
                                }
                                else{
                                  widget.chatStore.showItemAction = "";
                                }
                              },
                              child: SetUpAssetImage(
                                  height: 20,
                                  width: 20,
                                  ImagesPath.icActionsChat,
                                  color: Colors.blueAccent,
                              ),
                            ),
                            AppSiteBox.w15,
                            AppTapAnimation(
                              enabled: true,
                              onTap: (){

                              },
                              child: SetUpAssetImage(
                                  height: 20,
                                  width: 20,
                                  ImagesPath.icPhotoChat,
                                  color: Colors.blueAccent,
                              ),
                            ),
                            AppSiteBox.w15,
                            AppTapAnimation(
                              enabled: true,
                              onTap: (){
                                if(widget.chatStore.showItemAction != ACTION_OPEN_GALLERY){
                                  widget.chatStore.showItemAction = ACTION_OPEN_GALLERY;
                                }
                                else{
                                  widget.chatStore.showItemAction = "";
                                }
                              },
                              child: SetUpAssetImage(
                                  height: 20,
                                  width: 20,
                                  ImagesPath.icGalleryChat,
                                  color: Colors.blueAccent,
                              ),
                            ),
                            AppSiteBox.w15,
                            SetUpAssetImage(
                                height: 20,
                                width: 20,
                                ImagesPath.icAudioChat,
                                color: Colors.blueAccent,
                            ),
                            AppSiteBox.w10,
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: widget.chatStore.isHasInput ? SizeUtil.getMaxWidth() : 50 ,
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: ColorResources.COLOR_000000.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: widget.chatStore.writeMessController,
                                  focusNode: widget.chatStore.chatFocusNode,
                                  style: AppText.text14_Inter,
                                  decoration: InputDecoration(
                                    hintText: 'Nhắn tin',
                                    hintStyle: AppText.text12_Inter.copyWith(
                                      color: ColorResources.HINT_TEXT,
                                    ),
                                    border: InputBorder.none,
                                    counterStyle: const TextStyle(
                                      color: ColorResources.COLOR_918F95,
                                    ),
                                  ),
                                  maxLines: 3,
                                  minLines: 1,
                                  cursorColor: ColorResources.COLOR_5D4D87,
                                  onChanged: (val) {
                                    widget.chatStore.isHasInput = val.isNotEmpty;
                                  },
                                ),
                              ),
                              SetUpAssetImage(
                                  height: 20,
                                  width: 20,
                                  ImagesPath.icEmojiChat,
                                  color: Colors.blueAccent,
                              )
                            ],
                          ),
                        ),
                      ),
                      AppSiteBox.w10,
                      Transform.translate(
                        offset: Offset(0, -5),
                        child: Row(
                          children: [
                            if(widget.chatStore.isHasInput)
                            GestureDetector(
                              onTap: () {
                                if(widget.chatStore.isHasInput){
                                  _onSendTap(
                                      widget.chatStore.writeMessController.text,
                                      widget.chatStore.replyMessage,
                                      MessageContentType.text
                                  );
                                  widget.chatStore.writeMessController.text = "";
                                  widget.chatStore.replyMessage = null;
                                }
                              },
                              child: SetUpAssetImage(
                                  height: 26,
                                  width: 26,
                                  ImagesPath.icSendChat,
                                  color: Colors.blueAccent,
                              ),
                            ),
                            if(!widget.chatStore.isHasInput)
                            SetUpAssetImage(
                                height: 24,
                                width: 24,
                                ImagesPath.icShapeLikeChat,
                                color: Colors.blueAccent,
                            ),
                          ],
                        ),
                      ),

                    ],
                  );
                }
              );
            }
        ),
      ),
    );
  }
}