import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/helper/app_custom_circle_avatar.dart';
import 'package:handoff_vdb_2025/core/helper/app_sitebox.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/friends_store.dart';

class ShowAllFriendInProfile extends StatelessWidget {
  final FriendsStore friendsStore = AppInit.instance.friendsStore;
  ShowAllFriendInProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Scaffold(
          appBar: AppBar(title: const Text("Tất cả bạn bè"), centerTitle: true),
          body: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.68,
            ),
            itemCount: friendsStore.friendList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => friendsStore.goToInfoFriend(context: context, friendId: friendsStore.friendList[index].id ?? ''),
                child: buildFriendCard(
                  context,
                  id: friendsStore.friendList[index].id ?? "",
                  name: friendsStore.friendList[index].name ?? "",
                  isOnline: index.isEven,
                  avatarUrl: friendsStore.friendList[index].avatar ?? ImagesPath.icPerson,
                  coverUrl: "https://picsum.photos/300/200?random=$index",
                ),
              );
            },
          ),
        );
      }
    );
  }

  Widget buildFriendCard(
      BuildContext context, {
        required String id,
        required String name,
        required bool isOnline,
        required String avatarUrl,
        required String coverUrl,
      }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Image.network(
                coverUrl,
                height: 100.h,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: -30,
                child: Hero(
                  tag: id,
                  child: AppCustomCircleAvatar(
                    radius: 35,
                    height: 70,
                    width: 70,
                    image: avatarUrl,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 35),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          AppSiteBox.h5,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "1.2K",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "Người theo dõi",
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 25),
              Row(
                children: [
                  Icon(Icons.circle, size: 10, color: isOnline ? Colors.green : Colors.grey,),
                  const SizedBox(width: 4),
                  Text(
                    isOnline ? "Online" : "Offline",
                    style: AppText.text11.copyWith(
                      color: isOnline ? Colors.green : Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FriendActionButton(
              onTap: () {
                print("Nhắn tin");
              },
              icon: SetUpAssetImage(
                height: 14,
                ImagesPath.icMessenger,
                color: Colors.white,
              ),
              label: "Nhắn tin",
              isPrimary: true,
            ),
          ),
        ],
      ),
    );
  }
}

class FriendActionButton extends StatefulWidget {
  final VoidCallback onTap;
  final Widget icon;
  final String label;
  final bool isPrimary;

  const FriendActionButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
    this.isPrimary = false,
  });

  @override
  State<FriendActionButton> createState() => _FriendActionButtonState();
}

class _FriendActionButtonState extends State<FriendActionButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.95);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        child: Material(
          borderRadius: BorderRadius.circular(6),
          color: widget.isPrimary ? Colors.blue : Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(6),
            splashColor: widget.isPrimary
                ? Colors.white.withOpacity(0.2)
                : Colors.grey.withOpacity(0.2),
            onTap: widget.onTap,
            child: Container(
              width: 200,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: widget.isPrimary
                    ? null
                    : Border.all(color: Colors.grey, width: 0.8),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 14,
                      width: 14,
                      child: Center(child: widget.icon),
                    ),
                    const SizedBox(width: 3),
                    Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: 10,
                        color: widget.isPrimary ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}





