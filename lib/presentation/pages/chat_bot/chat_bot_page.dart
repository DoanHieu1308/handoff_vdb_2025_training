import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:handoff_vdb_2025/core/extensions/string_extension.dart';
import 'package:handoff_vdb_2025/core/helper/app_tap_animation.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import '../../../core/utils/color_resources.dart';
import '../loading/loading_page.dart';
import 'components/write_chat_bot.dart';

class ChatBotPage extends StatefulWidget {
  ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final chatBotStore = AppInit.instance.chatBotStore;

  @override
  void initState() {
    super.initState();
    // Initialize suggestions when page loads
    chatBotStore.showSuggestionsPanel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Observer(
        builder: (context) {
          return Stack(
              children: [
                Scaffold(
                    backgroundColor: ColorResources.COLOR_F5F6F8,
                    appBar: AppBar(
                      title: Row(
                        children: [
                          Container(
                            width: 32.w,
                            height: 32.w,
                            decoration: BoxDecoration(
                              color: ColorResources.COLOR_16B978,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.smart_toy,
                              color: ColorResources.WHITE,
                              size: 18.sp,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text("Assistant"),
                        ],
                      ),
                      titleTextStyle: AppText.text16_Inter,
                      centerTitle: false,
                      backgroundColor: ColorResources.COLOR_F5F6F8,
                      elevation: 0,
                      leading: AppTapAnimation(
                        enabled: true,
                        onTap: (){
                          Navigator.of(context).pop();
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                          child: Container(
                            padding: const EdgeInsets.only(right: 15, top: 10, bottom: 10),
                            height: 17.h,
                            width: 19.w,
                            color: Colors.transparent,
                            child: Icon(Icons.arrow_back_ios_new_outlined, size: 20),
                          ),
                        ),
                      ),
                      actions: [
                        Observer(
                          builder: (context) => IconButton(
                            onPressed: () => chatBotStore.showSuggestionsPanel(),
                            icon: Icon(
                              Icons.lightbulb_outline,
                              color: ColorResources.COLOR_16B978,
                            ),
                            tooltip: 'Gợi ý câu hỏi',
                          ),
                        ),
                        Observer(
                          builder: (context) => IconButton(
                            onPressed: chatBotStore.messages.isNotEmpty 
                              ? () => _showClearDialog(context)
                              : null,
                            icon: Icon(
                              Icons.clear_all,
                              color: chatBotStore.messages.isNotEmpty 
                                ? ColorResources.COLOR_16B978 
                                : ColorResources.HINT_TEXT,
                            ),
                            tooltip: 'Xóa cuộc trò chuyện',
                          ),
                        ),
                      ],
                    ),
                    body: buildBody(context)),
                if(chatBotStore.isLoading) const LoadingPage()
              ]
          );
        }
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: chatBotStore.chatBotScrollController,
                child: Observer(
                  builder: (context) {
                    return Column(
                      children: [
                        Visibility(
                          visible: !chatBotStore.isAssistantFromHistory,
                          child: buildEmpty(),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return buildMessage(index);
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(height: 5);
                          },
                          itemCount: chatBotStore.messages.length,
                        ),
                      ],
                    );
                  },
                ),
              ),
              Observer(
                builder: (context) => Visibility(
                  visible: chatBotStore.showAutoscroll,
                  child: Positioned(
                    bottom: 20.w,
                    right: 16.w,
                    child: GestureDetector(
                      onTap: () {
                        chatBotStore.scrollToBottom();
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: ColorResources.COLOR_16B978,
                          shape: BoxShape.circle,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(3),
                          child: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: ColorResources.WHITE,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        WriteChatBot(chatBotStore: chatBotStore),
      ],
    );
  }

  Widget buildMessage(int index) {
    final message = chatBotStore.messages[index];
    
    if (message.isFromUser) {
      // User message
      return Padding(
        padding: EdgeInsets.only(
          left: 60.w,
          right: 16.w,
          top: 8.h,
          bottom: 8.h,
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Container(
            decoration: const BoxDecoration(
              color: ColorResources.COLOR_16B978,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(12.w),
              child: Text(
                message.content,
                style: AppText.text14.copyWith(color: ColorResources.WHITE),
              ),
            ),
          ),
        ),
      );
    } else {
      // Bot message
      return Padding(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 60.w,
          top: 8.h,
          bottom: 8.h,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: ColorResources.COLOR_16B978,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.smart_toy,
                color: ColorResources.WHITE,
                size: 18.sp,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: ColorResources.WHITE,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: message.isLoading
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16.w,
                            height: 16.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                ColorResources.COLOR_16B978,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Đang trả lời...',
                            style: AppText.text14.copyWith(
                              color: ColorResources.HINT_TEXT,
                            ),
                          ),
                        ],
                      )
                      : buildBotText(message.botResponse ?? ''),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget buildBotText(String text) {
    final regex = RegExp(r'\(?handoff:\/\/[^\s\)]+\)?');
    final matches = regex.allMatches(text).toList();

    if (matches.isEmpty) {
      return Text(text, style: AppText.text14);
    }

    List<InlineSpan> spans = [];
    int lastEnd = 0;

    for (final match in matches) {
      final beforeText = text.substring(lastEnd, match.start);
      if (beforeText.isNotEmpty) {
        spans.add(TextSpan(text: beforeText, style: AppText.text14));
      }

      // Lấy url, loại bỏ ngoặc nếu có
      var url = match.group(0)!;
      url = url.replaceAll("(", "").replaceAll(")", "");

      // Bỏ các dấu . , ! ? ở cuối URL nếu có
      url = url.replaceAll(RegExp(r'[.,!?]$'), "");

      final uri = Uri.parse(url);
      final route = "/${uri.host}${uri.path}";

      print(route);

      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorResources.COLOR_16B978,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                textStyle: AppText.text12.copyWith(color: ColorResources.WHITE),
              ),
              onPressed: () {
                context.push(route);
              },
              child: Text(
                uri.pathSegments.isNotEmpty
                    ? uri.pathSegments.last.replaceAll('_', ' ').capitalize()
                    : uri.host.capitalize(),
              ),
            ),
          ),
        ),
      );

      lastEnd = match.end;
    }

    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: AppText.text14,
      ));
    }

    return RichText(text: TextSpan(children: spans));
  }

  Widget buildEmpty() {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 60.w,
        top: 20.h,
        bottom: 20.h,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: ColorResources.COLOR_16B978,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.smart_toy,
              color: ColorResources.WHITE,
              size: 18.sp,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: ColorResources.WHITE,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Text(
                  'Xin chào! Tôi là trợ lý AI của bạn. Hãy hỏi tôi bất cứ điều gì!',
                  style: AppText.text14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Xóa cuộc trò chuyện',
            style: AppText.text16,
          ),
          content: Text(
            'Bạn có chắc chắn muốn xóa toàn bộ cuộc trò chuyện này không?',
            style: AppText.text14,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Hủy',
                style: AppText.text14.copyWith(
                  color: ColorResources.HINT_TEXT,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                chatBotStore.clearMessages();
                Navigator.of(context).pop();
              },
              child: Text(
                'Xóa',
                style: AppText.text14.copyWith(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}



