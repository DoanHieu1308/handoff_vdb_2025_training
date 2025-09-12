import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handoff_vdb_2025/config/routes/route_path/auth_routers.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/presentation/pages/conversation/messenger/messenger_page.dart';
import 'package:handoff_vdb_2025/presentation/pages/conversation/stories/stories_page.dart';

import '../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../core/base_widget/lazy_index_stack.dart';
import '../../../core/helper/app_tap_animation.dart';
import '../../../core/helper/app_text.dart';
import '../../../core/utils/color_resources.dart';
import '../../../core/utils/images_path.dart';
import 'components/conversation_bottom_navigation_bar.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final conversationStore = AppInit.instance.conversationStore;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Scaffold(
          backgroundColor: ColorResources.WHITE,
          appBar: AppBar(
            backgroundColor: ColorResources.WHITE,
            title: Text("Messenger"),
            titleTextStyle: AppText.text25_bold.copyWith(
              color: Colors.indigoAccent,
            ),
            leading: AppTapAnimation(
              enabled: true,
              onTap: () {
                router.pop();
              },
              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
                size: 20,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 30),
                child: AppTapAnimation(
                  child: SetUpAssetImage(
                    ImagesPath.icNewNoteChat,
                    height: 20,
                    width: 20,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
                border: Border.all(
                    width: 0.5,
                    color: Colors.grey
                )
            ),
            child: BottomAppBar(
              color: ColorResources.WHITE,
              height: 77,
              child: ConversationBottomNavigationBar(),
            ),
          ),
          body: LazyIndexedStack(
            index: conversationStore.currentIndex,
            preloadCount: 0,
            children: [
              const MessengerPage(), // Tab "Đoạn chat" - hiển thị danh sách chat
              const StoriesPage(), // Tab "Tin"
            ],
          ),
        );
      }
    );
  }
}
