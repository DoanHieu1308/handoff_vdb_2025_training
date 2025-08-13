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
  State<CustomReactionLikeButton> createState() => _CustomReactionLikeButtonState();
}

class _CustomReactionLikeButtonState extends State<CustomReactionLikeButton> {
  PostItemStore store = AppInit.instance.postStatusStore;
  final List<String> reactions = [
    ImagesPath.emojiLike,
    ImagesPath.emojiLove,
    ImagesPath.emojiHaha,
    ImagesPath.emojiWow,
    ImagesPath.emojiSad,
    ImagesPath.emojiAngry,
  ];

  // Map emoji => text name
  final Map<String, String> reactionNames = {
    ImagesPath.icLike : "unLike",
    ImagesPath.emojiLike : "Like",
    ImagesPath.emojiLove : "Love",
    ImagesPath.emojiHaha : "Haha",
    ImagesPath.emojiWow : "Wow",
    ImagesPath.emojiSad : "Sad",
    ImagesPath.emojiAngry : "Angry",
  };

  String selectedReaction = ImagesPath.icLike;

  OverlayEntry? overlayEntry;
  int hoveredIndex = -1;

  void showReactions(BuildContext context, Offset globalPosition) {
    final screenSize = MediaQuery.of(context).size;
    const double popupHeight = 60; // chiều cao container reactions
    const double popupWidth = 50; // chiều rộng reactions
    const double offsetY = 20; // khoảng cách so với icon

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          left: (globalPosition.dx - popupWidth / 2)
              .clamp(0.0, screenSize.width - popupWidth),
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
                      blurRadius: 8, color: Colors.black.withOpacity(0.2))
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(reactions.length, (index) {
                  final isHovered = index == hoveredIndex;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: AnimatedScale(
                      scale: isHovered ? 1.5 : 1.0,
                      duration: const Duration(milliseconds: 150),
                      child: SizedBox(
                        height: 35,
                        width: 35,
                        child: Lottie.asset(
                          reactions[index],
                        ),
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
    final iconWidth = 40.0;
    final dx = globalPosition.dx - startX;

    int newIndex = (dx / (iconWidth + 12)).floor();
    if (newIndex >= 0 && newIndex < reactions.length) {
      setState(() {
        hoveredIndex = newIndex;
      });
      overlayEntry?.markNeedsBuild();
    }
  }

  void hideReactions() {
    if (hoveredIndex != -1) {
      setState(() {
        selectedReaction = reactions[hoveredIndex];
        print("${reactionNames[selectedReaction]}");
        store.dropEmoji(
            postId: widget.itemPost.id ?? "",
            iconName: reactionNames[selectedReaction] ?? ""
        );
      });
    }
    overlayEntry?.remove();
    overlayEntry = null;
    hoveredIndex = -1;
  }

  void oneTapReactions() {
    setState(() {
      if (selectedReaction == ImagesPath.icLike) {
        selectedReaction = ImagesPath.emojiLike;
      } else if (selectedReaction == ImagesPath.emojiLike) {
        selectedReaction = ImagesPath.icLike;
      } else {
        selectedReaction = ImagesPath.icLike;
      }
    });

    store.dropEmoji(
      postId: widget.itemPost.id ?? "",
      iconName: reactionNames[selectedReaction] ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        oneTapReactions();
      },
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
            if(selectedReaction == ImagesPath.icLike)
              SetUpAssetImage(
                  height: 23,
                  width: 23,
                  ImagesPath.icLike,
                  fit: BoxFit.cover,
              )
            else SizedBox(
                height: 25,
                width: 25,
                child: Lottie.asset(selectedReaction)
            ),
            const SizedBox(width: 6),
            Text(selectedReaction == ImagesPath.icLike ?  "Like" : reactionNames[selectedReaction] ?? "Like",
              style: AppText.text10,
            ),
          ],
        ),
      ),
    );
  }
}
