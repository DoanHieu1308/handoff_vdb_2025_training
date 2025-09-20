import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/utils/color_resources.dart';
import '../chat_bot_store.dart';
import 'suggestions_panel.dart';

class WriteChatBot extends StatefulWidget {
  final ChatBotStore chatBotStore;
  
  const WriteChatBot({
    super.key,
    required this.chatBotStore,
  });

  @override
  State<WriteChatBot> createState() => _WriteChatBotState();
}

class _WriteChatBotState extends State<WriteChatBot> {
  bool _isTyping = false;

  void _onSendMessage() {
    final message = widget.chatBotStore.messageController.text.trim();
    if (message.isNotEmpty && !widget.chatBotStore.isLoading) {
      widget.chatBotStore.addMessage(message);
      widget.chatBotStore.messageController.clear();
      setState(() {
        _isTyping = false;
      });
    }
  }

  void _onTextChanged(String text) {
    setState(() {
      _isTyping = text.trim().isNotEmpty;
    });
    
    // Update suggestions based on input
    widget.chatBotStore.updateSuggestions(text);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) => Column(
        children: [
          SuggestionsPanel(chatBotStore: widget.chatBotStore),
          Container(
            width: double.infinity,
            color: ColorResources.WHITE,
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 10.h,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    decoration: BoxDecoration(
                      color: ColorResources.COLOR_F5F6F8,
                      borderRadius: BorderRadius.circular(25.r),
                      border: Border.all(
                        color: _isTyping 
                          ? ColorResources.COLOR_16B978 
                          : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: TextField(
                      controller: widget.chatBotStore.messageController,
                      style: AppText.text14,
                      enabled: !widget.chatBotStore.isLoading,
                      decoration: InputDecoration(
                        hintText: widget.chatBotStore.isLoading 
                          ? 'Đang xử lý...' 
                          : 'Nhập tin nhắn...',
                        hintStyle: AppText.text14.copyWith(
                          color: ColorResources.HINT_TEXT,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                      ),
                      maxLines: 3,
                      minLines: 1,
                      cursorColor: ColorResources.COLOR_16B978,
                      onChanged: _onTextChanged,
                      onSubmitted: (_) => _onSendMessage(),
                      onTap: () {
                        // Show suggestions when user taps on input field
                        if (widget.chatBotStore.messageController.text.isEmpty) {
                          widget.chatBotStore.showSuggestionsPanel();
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: (_isTyping && !widget.chatBotStore.isLoading) 
                    ? _onSendMessage 
                    : null,
                  child: Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: (_isTyping && !widget.chatBotStore.isLoading)
                        ? ColorResources.COLOR_16B978 
                        : ColorResources.COLOR_F5F6F8,
                      shape: BoxShape.circle,
                    ),
                    child: widget.chatBotStore.isLoading
                      ? SizedBox(
                          width: 16.w,
                          height: 16.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              ColorResources.COLOR_16B978,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.send_rounded,
                          color: (_isTyping && !widget.chatBotStore.isLoading)
                            ? ColorResources.WHITE 
                            : ColorResources.HINT_TEXT,
                          size: 20.sp,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
