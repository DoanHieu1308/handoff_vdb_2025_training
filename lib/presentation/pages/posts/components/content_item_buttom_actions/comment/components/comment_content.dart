import 'package:comment_tree/data/comment.dart';
import 'package:comment_tree/widgets/comment_tree_widget.dart';
import 'package:comment_tree/widgets/tree_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handoff_vdb_2025/core/helper/app_custom_circle_avatar.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/presentation/pages/posts/post_item_store.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../../../../core/helper/app_sitebox.dart';
import '../../../../../../../core/helper/app_text.dart';
import '../../../../../../../core/helper/size_util.dart';
import '../../../../../../../core/utils/images_path.dart';
import '../../../../../../../data/model/post/post_comment_model.dart';


class CommentContent extends StatelessWidget {
  final postItemStore = AppInit.instance.postItemStore;
  final String postId;

  CommentContent({super.key, required this.postId});

  void onLoading() {
    postItemStore.getMoreComments(commentPostId: postId);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (context) {
          if (postItemStore.commentList.isEmpty) {
            return SizedBox(
              height: 270,
              width: SizeUtil.getMaxWidth(),
              child: Padding(
                padding: const EdgeInsets.all(50),
                child: Center(
                  child: Text(
                    "Hãy là người đầu tiên bình luận bài viết này",
                    style: AppText.text16_bold.copyWith(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }

          return Expanded(
            child: SmartRefresher(
              controller: postItemStore.refreshController,
              enablePullDown: false,
              enablePullUp: true,
              onLoading: onLoading,
              child: ListView.builder(
                controller: postItemStore.scrollCommentController,
                padding: const EdgeInsets.all(10),
                itemCount: postItemStore.commentList.length,
                itemBuilder: (context, index) {
                  final comment = postItemStore.commentList[index];

                  final keyComment = GlobalKey();
                  postItemStore.commentKeys[comment.id ?? index.toString()] = keyComment;

                  return CommentItemWidget(
                    key: ValueKey(comment.id ?? index),
                    keyComment: keyComment,
                    comment: comment,
                  );
                },
                cacheExtent: 1000,
                physics: const BouncingScrollPhysics(),
                addAutomaticKeepAlives: true,
              ),
            ),
          );
        }
    );
  }

}

class CommentItemWidget extends StatefulWidget {
  final PostCommentModel comment;
  final GlobalKey keyComment;

  const CommentItemWidget({
    super.key,
    required this.comment,
    required this.keyComment}
  );

  @override
  State<CommentItemWidget> createState() => _CommentItemWidgetState();
}

class _CommentItemWidgetState extends State<CommentItemWidget> {
  bool isSeeMore = true;
  final PostItemStore postItemStore = AppInit.instance.postItemStore;

  @override
  void initState() {
    super.initState();
    final childCount = widget.comment.replies?.length ?? 0;
    if (childCount <= 1) {
      isSeeMore = false;
    }
  }


  Comment _mapToComment(PostCommentModel model) {
    return Comment(
      avatar: model.user?.avatar ?? ImagesPath.icPerson,
      userName: model.user?.name ?? "Ẩn danh",
      content: model.commentContent ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    final root = _mapToComment(widget.comment);

    final children = isSeeMore && (widget.comment.replies?.length ?? 0) > 1
        ? [Comment(avatar: null, userName: null, content: null,)]
        : (widget.comment.replies?.map(_mapToComment).toList() ?? []);

    return Container(
      key: widget.keyComment,
      child: Column(
        children: [
          CommentTreeWidget<Comment, Comment>(
            root,
            children,
            treeThemeData: TreeThemeData(
              lineColor: Colors.grey.shade300,
              lineWidth: 2,
            ),
            avatarRoot: (context, data) => PreferredSize(
              preferredSize: const Size.fromRadius(20),
              child: AppCustomCircleAvatar(
                radius: 20,
                height: 40,
                width: 40,
                image: data.avatar ?? ImagesPath.icPerson,
              ),
            ),
            avatarChild: (context, data) {
              if (data.content == null) {
                return PreferredSize(
                    preferredSize: const Size.fromRadius(20),
                    child: SizedBox.shrink());
              }
              return PreferredSize(
                preferredSize: const Size.fromRadius(15),
                child: AppCustomCircleAvatar(
                  radius: 15,
                  height: 30,
                  width: 30,
                  image: data.avatar ?? ImagesPath.icPerson,
                ),
              );
            },
            contentRoot: (context, data) {
              return _buildCommentContent(data, isRoot: true);
            },
            contentChild: (context, data) {
              if (data.content == null) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      isSeeMore = false;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: buildCommentHidden(
                      comment: widget.comment.replies!.first,
                      numberCommentOther: widget.comment.replies!.length - 1,
                    ),
                  ),
                );
              }

              return _buildCommentContent(data);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCommentContent(Comment data, {bool isRoot = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: SizeUtil.getMaxWidth(),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.userName ?? "Ẩn danh",
                    style: isRoot ? AppText.text16_bold : AppText.text14_bold),
                buildCustomCommentText(data.content),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text("1 giờ", style: AppText.text13),
              AppSiteBox.w15,
              buildCommentActionButton(label: "Thích", onTap: () {}),
              AppSiteBox.w15,
              buildCommentActionButton(
                label: "Trả lời",
                onTap: () {
                  postItemStore.setMentionText("@${data.userName} ");
                  postItemStore.commentUserName = data.userName ?? "";
                  postItemStore.commentParentId = widget.comment.commentParentId ?? widget.comment.id ?? "";
                  postItemStore.commentFocusNode.requestFocus();

                  postItemStore.scrollToComment(widget.comment.id ?? "");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildCustomCommentText(String? content) {
    final text = content ?? "";
    final spans = <TextSpan>[];
    final regex = RegExp(r'(@\w+)');

    int start = 0;
    for (final match in regex.allMatches(text)) {
      if (match.start > start) {
        spans.add(TextSpan(
          text: text.substring(start, match.start),
          style: const TextStyle(color: Colors.black),
        ));
      }

      spans.add(TextSpan(
        text: match.group(0),
        style: const TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.bold,
        ),
      ));

      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: const TextStyle(color: Colors.black),
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }

  Widget buildCommentActionButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        splashColor: Colors.grey.withValues(alpha: 0.2),
        highlightColor: Colors.grey.withValues(alpha: 0.1),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.transparent,
          ),
          child: Text(label, style: AppText.text13_Inter),
        ),
      ),
    );
  }

  Widget buildCommentHidden({required PostCommentModel comment, required int numberCommentOther}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 15,
              child: ClipOval(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: SetUpAssetImage(
                    comment.user!.avatar ?? "",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            SizedBox(
              width: 250,
              child: Row(
                children: [
                  Text(
                    comment.user!.name ?? "",
                    style: AppText.text14_Inter,
                  ),
                  AppSiteBox.w5,
                  Expanded(
                    child: Text(
                      comment.commentContent ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        AppSiteBox.h10,
        if(numberCommentOther != 0)
          Text(numberCommentOther != 0
              ? "Xem $numberCommentOther phản hồi khác..."
              : "", style: AppText.text14_bold),
        AppSiteBox.h10,
      ],
    );
  }
}

