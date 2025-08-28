import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/core/helper/app_sitebox.dart';
import 'package:handoff_vdb_2025/core/helper/size_util.dart';
import 'components/messenger_item.dart';
import 'components/messenger_list_friend_story.dart';
import 'components/messenger_search_friend.dart';

class MessengerPage extends StatefulWidget {
  const MessengerPage({super.key});

  @override
  State<MessengerPage> createState() => _MessengerPageState();
}

class _MessengerPageState extends State<MessengerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        height: double.infinity,
        width: SizeUtil.getMaxWidth(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MessengerSearchFriend(),
            AppSiteBox.h15,
            MessengerListFriendStory(),
            buildListItemChat(),
          ],
        ),
      ),
    );
  }

  Widget buildListItemChat() {
    return Expanded(
      child: ListView.builder(
          itemCount: 10,
          itemBuilder: (_, index) => MessengerItem()
      ),
    );
  }
}
