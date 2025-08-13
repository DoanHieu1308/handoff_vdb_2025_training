import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handoff_vdb_2025/core/helper/size_util.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/component/create_post_text.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/create_post_store.dart';
import '../../../../core/helper/app_text.dart';
import '../../account/personal_information/widget/auth_input.dart';

class CreatePostLink extends StatefulWidget {
  const CreatePostLink({super.key});

  @override
  State<CreatePostLink> createState() => _CreatePostLinkState();
}

class _CreatePostLinkState extends State<CreatePostLink> {
  CreatePostStore store = AppInit.instance.createPostStore;
  @override
  void initState() {
    super.initState();
    store.init();
  }

  @override
  void dispose() {
    super.dispose();
    store.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            !store.linkPreviewStore.hasLink
                ? CreatePostText(
                    feelingEditingController: store.textStore.feelingEditingController,
                    hasText: store.textStore.hasText,
                    feelingFocusNode: store.feelingFocusNode,
                  )
                : AuthInput(
              controller: store.textStore.feelingEditingController,
              maxLine: store.linkPreviewStore.hasLink ? 5 : 2,
              textStyle: AppText.text16,
              fillColor: Colors.transparent,
              focusNode: store.feelingFocusNode,
              hintText: '',
            ),
            const SizedBox(height: 8),
            if (store.linkPreviewStore.isLoadingPreview)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: const [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Đang tải xem trước...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )
            else if (store.linkPreviewStore.detectedLink != null)
              _buildPreviewCard(store),
          ],
        );
      },
    );
  }

  Widget _buildPreviewCard(CreatePostStore store) {
    final data = store.linkPreviewStore.previewData;
    final hasUrl = (data.postLinkUrl ?? '').isNotEmpty;

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
          if (data.postLinkTitle != null && data.postLinkTitle!.isNotEmpty)
            Text(
              data.postLinkTitle!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (data.postLinkDescription != null && data.postLinkDescription!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                data.postLinkDescription!,
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
              if (data.postLinkUrl != null) {
                store.openUrl(data.postLinkUrl!);
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                data.postLinkUrl ?? '',
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
          if (data.postLinkImage != null && data.postLinkImage!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SizedBox(
                width: SizeUtil.getMaxWidth(),
                height: 200,
                child: Image.network(
                  data.postLinkImage!,
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


