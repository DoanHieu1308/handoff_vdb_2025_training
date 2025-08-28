import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handoff_vdb_2025/core/helper/app_tap_animation.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/presentation/pages/posts/post_item_store.dart';

import '../../../../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../../../../core/helper/app_sitebox.dart';
import '../../../../../../../core/helper/app_text.dart';
import '../../../../../../../core/helper/size_util.dart';
import '../../../../../../../core/utils/images_path.dart';


class CommentInputAndSent extends StatelessWidget {
  final PostItemStore postItemStore = AppInit.instance.postItemStore;
  final String postId;
  CommentInputAndSent({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: SizeUtil.getMaxWidth(),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: Column(
            children: [
              if(postItemStore.commentUserName != "")
              SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Text("Đang phản hồi", style: AppText.text12),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(postItemStore.commentUserName, style: AppText.text14_bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text("-", style: AppText.text14_bold),
                    ),
                    AppTapAnimation(
                        enabled: true,
                        onTap: (){
                          postItemStore.commentParentId = "";
                          postItemStore.commentUserName = "";
                          postItemStore.mentionKey.currentState?.controller?.text = "";
                          print("Da bam huy");
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          height: 30,
                          alignment: Alignment.center,
                          child: Text(
                            "Hủy",
                            style: AppText.text14_bold.copyWith(color: Colors.grey.shade600),
                          ),
                        )
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  if(!postItemStore.hasTextComment)
                  CircleAvatar(
                    child: ClipOval(
                      child: SizedBox(
                        height: 44,
                        width: 44,
                        child: SetUpAssetImage(
                          postItemStore.profileStore.userProfile.avatar ?? ImagesPath.icPerson,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  AppSiteBox.w10,
                  Container(
                    padding: const EdgeInsets.only(left: 10),
                    constraints: BoxConstraints(
                      minHeight: 46
                    ),
                    width: postItemStore.hasTextComment ? 300 : 260,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: FlutterMentions(
                      key: postItemStore.mentionKey,
                      focusNode: postItemStore.commentFocusNode,
                      suggestionPosition: SuggestionPosition.Top,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Viết bình luận công khai...",
                        hintStyle: AppText.text14.copyWith(
                          color: Colors.grey.shade500,
                          fontFamily: 'Inter-Regular',
                        ),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      mentions: [
                        Mention(
                          trigger: '@',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                          data: postItemStore.friendsStore.friendList
                              .map(
                                (f) => {
                              'id': f.id ?? '',
                              'display': f.name ?? 'Ẩn danh',
                              'photo': f.avatar ?? ImagesPath.icPerson,
                            },
                          ).toList(),
                          matchAll: false,
                          suggestionBuilder: (data) {
                            return Container(
                              padding: const EdgeInsets.only(
                                left: 65,
                                top: 8,
                                bottom: 8,
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 15,
                                    child: ClipOval(
                                      child: SizedBox(
                                        height: 35,
                                        width: 35,
                                        child: SetUpAssetImage(
                                          data['photo'],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    data['display'],
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                      onMentionAdd: (mention) {
                        debugPrint("Mention added: $mention");
                      },
                    ),
                  ),
                  AppSiteBox.w15,
                  GestureDetector(
                    onTap: () {
                      if (postItemStore.hasTextComment) {
                        postItemStore.createCommentPost(
                          commentPostId: postId ?? "",
                          commentParentId: postItemStore.commentParentId,
                          onSuccess: () {
                            postItemStore.getCommentByPostId(commentPostId: postId);
                            postItemStore.commentUserName = "";
                          },
                          onError: (error) {},
                        );
                        postItemStore.commentParentId = "";
                      }
                    },
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: SetUpAssetImage(
                        postItemStore.hasTextComment
                            ? ImagesPath.icSend
                            : ImagesPath.icSendNoFocus,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
