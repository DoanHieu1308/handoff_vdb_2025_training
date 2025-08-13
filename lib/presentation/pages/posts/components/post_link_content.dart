import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import '../../../../core/helper/size_util.dart';
import '../../../../data/model/post/post_output_model.dart';
import '../post_item_store.dart';

class PostLinkContent extends StatelessWidget {
  final PostOutputModel postData;
  const PostLinkContent({super.key, required this.postData});

  @override
  Widget build(BuildContext context) {
    final PostItemStore store = AppInit.instance.postStatusStore;
    final hasUrl = (postData.postLinkMeta?.postLinkUrl ?? '').isNotEmpty;

    if (!hasUrl) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Không lấy được nội dung xem trước.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (postData.postLinkMeta?.postLinkTitle != null && postData.postLinkMeta!.postLinkTitle!.isNotEmpty)
            Text(
              postData.postLinkMeta!.postLinkTitle!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (postData.postLinkMeta?.postLinkDescription != null && postData.postLinkMeta!.postLinkDescription!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                postData.postLinkMeta!.postLinkDescription!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ),
          GestureDetector(
            onTap: () {
              if (postData.postLinkMeta?.postLinkUrl != null) {
                store.createPostStore.openUrl(postData.postLinkMeta!.postLinkUrl!);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                postData.postLinkMeta?.postLinkUrl ?? '',
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 11,
                  decoration: TextDecoration.underline,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          if (postData.postLinkMeta?.postLinkImage != null && postData.postLinkMeta!.postLinkImage!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SizedBox(
                width: SizeUtil.getMaxWidth(),
                height: 200,
                child: Image.network(
                  postData.postLinkMeta!.postLinkImage!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.grey,
                    child: const Icon(Icons.broken_image),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
