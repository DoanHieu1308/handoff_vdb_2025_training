import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/core/helper/app_sitebox.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/data/model/post/post_output_model.dart';
import 'package:handoff_vdb_2025/presentation/pages/posts/post_item_store.dart';

import 'components/comment_content.dart';
import 'components/comment_input_and_sent.dart';
import 'components/comment_view_header.dart';


class CommentsView extends StatefulWidget {
  final PostOutputModel itemPost;
  CommentsView({super.key, required this.itemPost});

  @override
  State<CommentsView> createState() => _CommentsViewState();
}

class _CommentsViewState extends State<CommentsView> {
  final PostItemStore postItemStore = AppInit.instance.postItemStore;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      postItemStore.initMentionListener(force: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  AppSiteBox.h5,
                  CommentViewHeader(itemPost: widget.itemPost),
                  AppSiteBox.h15,
                  CommentContent(postId: widget.itemPost.id ?? ""),
                ],
              ),
            ),
          ),
          CommentInputAndSent(postId: widget.itemPost.id ?? ""),
        ],
      ),
    );
  }
}
