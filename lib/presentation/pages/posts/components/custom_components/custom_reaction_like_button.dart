import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:handoff_vdb_2025/data/model/post/post_output_model.dart';
import 'package:lottie/lottie.dart';
import '../../../../../core/helper/app_text.dart';
import '../../post_item_store.dart';

class CustomReactionLikeButton extends StatefulWidget {
  final PostOutputModel itemPost;
  const CustomReactionLikeButton({super.key, required this.itemPost});

  @override
  State<CustomReactionLikeButton> createState() =>
      _CustomReactionLikeButtonState();
}

class _CustomReactionLikeButtonState extends State<CustomReactionLikeButton> {
  PostItemStore postItemStore = AppInit.instance.postItemStore;

  String selectedReaction = "";

  @override
  void initState() {
    super.initState();
    selectedReaction = widget.itemPost.myFeel ?? "";
  }

  OverlayEntry? overlayEntry;
  int hoveredIndex = -1;

  final List<String> reactionKeys = [
    "like",
    "love",
    "haha",
    "wow",
    "sad",
    "angry",
  ];

  void showReactions(BuildContext context, Offset globalPosition) {
    final screenSize = MediaQuery.of(context).size;
    const double popupHeight = 60;
    const double popupWidth = 50;
    const double offsetY = 20;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: (globalPosition.dx - popupWidth / 2).clamp(
            0.0,
            screenSize.width - popupWidth,
          ),
          top: globalPosition.dy - popupHeight - offsetY,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 8,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(reactionKeys.length, (index) {
                  final isHovered = index == hoveredIndex;
                  final key = reactionKeys[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: AnimatedScale(
                      scale: isHovered ? 1.5 : 1.0,
                      duration: const Duration(milliseconds: 150),
                      child: SizedBox(
                        height: 35,
                        width: 35,
                        child: Lottie.asset(postItemStore.reactionNames[key]!),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
    Overlay.of(context).insert(overlayEntry!);
  }

  void updateHoveredIcon(Offset globalPosition) {
    final screenWidth = MediaQuery.of(context).size.width;
    final startX = screenWidth / 2 - 150;
    const iconWidth = 40.0;
    final dx = globalPosition.dx - startX;

    int newIndex = (dx / (iconWidth + 12)).floor();
    if (newIndex >= 0 && newIndex < reactionKeys.length) {
      setState(() {
        hoveredIndex = newIndex;
      });
      overlayEntry?.markNeedsBuild();
    }
  }

  void handleReactionUpdate({
    required String selectedReaction,
  }) {
    // Cập nhật trong homeStore.allPostsPublic
    postItemStore.updateReactionInPostsList(
      postId: widget.itemPost.id ?? "",
      selectedReaction: selectedReaction,
      postsList: postItemStore.homeStore.allPostsPublic,
    );

    // Cập nhật trong profileStore.posts
    postItemStore.updateReactionInPostsList(
      postId: widget.itemPost.id ?? "",
      selectedReaction: selectedReaction,
      postsList: postItemStore.profileStore.posts,
    );

    // Cập nhật trong infoFriendStore.posts (nếu có)
    try {
      final infoFriendStore = AppInit.instance.infoFriendStore;
      if (infoFriendStore.posts.isNotEmpty) {
        postItemStore.updateReactionInPostsList(
          postId: widget.itemPost.id ?? "",
          selectedReaction: selectedReaction,
          postsList: infoFriendStore.posts,
        );
      }
    } catch (e) {
      // Bỏ qua nếu infoFriendStore chưa được khởi tạo
    }
  }

  void hideReactions() {
    if (hoveredIndex != -1) {
      setState(() {
        selectedReaction = reactionKeys[hoveredIndex];
        postItemStore.dropEmoji(
          postId: widget.itemPost.id ?? "",
          iconName: selectedReaction,
          onSuccess: () {
            handleReactionUpdate(
              selectedReaction: selectedReaction,
            );
          },
          onError: (error) {},
        );
      });
    }
    overlayEntry?.remove();
    overlayEntry = null;
    hoveredIndex = -1;
  }

  void oneTapReactions() {
    setState(() {
      if (selectedReaction == "") {
        selectedReaction = "like";
      } else {
        selectedReaction = "";
      }
    });

    postItemStore.dropEmoji(
      postId: widget.itemPost.id ?? "",
      iconName: selectedReaction,
      onSuccess: () {
        handleReactionUpdate(
          selectedReaction: selectedReaction,
        );
      },
      onError: (error) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final iconPath = postItemStore.reactionNames[selectedReaction] ?? ImagesPath.icLike;
    return GestureDetector(
      onTap: oneTapReactions,
      onLongPressStart: (details) {
        showReactions(context, details.globalPosition);
      },
      onLongPressMoveUpdate: (details) {
        updateHoveredIcon(details.globalPosition);
      },
      onLongPressEnd: (details) {
        hideReactions();
      },
      child: Container(
        height: 55,
        color: Colors.transparent,
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedReaction == "")
              SetUpAssetImage(
                height: 23,
                width: 23,
                iconPath,
                fit: BoxFit.cover,
              )
            else
              SizedBox(height: 25, width: 25, child: Lottie.asset(iconPath)),
            const SizedBox(width: 6),
            Text(
              selectedReaction == "" ? "like" : selectedReaction,
              style: AppText.text10,
            ),
          ],
        ),
      ),
    );
  }
}
