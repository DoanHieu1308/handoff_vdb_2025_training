import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/helper/app_sitebox.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:hive/hive.dart';
import 'package:photo_manager/photo_manager.dart';

class ChatCustomShowMediaGallery extends StatelessWidget {
  final chatStore = AppInit.instance.chatStore;

  ChatCustomShowMediaGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.33,
      minChildSize: 0.33,
      maxChildSize: 1,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
            ),
            child: Column(
              children: [
                Container(
                  height: 5,
                  width: 50,
                  margin: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Tất cả ảnh", style: AppText.text14_bold),
                            Icon(Icons.keyboard_arrow_down, size: 25,),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey.shade300,
                                  width: 1
                                )
                              ),
                              child: Center(
                                child: SetUpAssetImage(
                                    ImagesPath.icGooglePhoto,
                                    height: 20,
                                    width: 2,
                                ),
                              ),
                            ),
                            AppSiteBox.w10,
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.all(Radius.circular(15))
                              ),
                              child: Row(
                                children: [
                                  SetUpAssetImage(
                                    ImagesPath.icHDImage,
                                    height: 18,
                                    width: 18,
                                  ),
                                  AppSiteBox.w5,
                                  Text("Tắt", style: AppText.text14_bold)
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Observer(
                  builder: (_) {
                    if (chatStore.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (chatStore.entities.isEmpty) {
                      return const Center(child: Text("No media found"));
                    }
                    return GridView.builder(
                      controller: chatStore.imageScrollController,
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemCount: chatStore.entities.length,
                      itemBuilder: (context, index) {
                        final entity = chatStore.entities[index];
                        return FutureBuilder<Uint8List?>(
                          future: entity.thumbnailDataWithSize(const ThumbnailSize.square(200)),
                          builder: (context, snapshot) {
                            final bytes = snapshot.data;
                            if (bytes == null) {
                              return const ColoredBox(color: Colors.grey);
                            }
                            return GestureDetector(
                              onTap: () async {
                                final id = entity.id;
                                if (id == null) return;

                                final isSelected = chatStore.selectedIds.contains(id);

                                if (isSelected) {
                                  chatStore.selectedIds.remove(id);

                                  final file = await entity.file;
                                  if (file != null) {
                                    chatStore.listFile.removeWhere((f) => f.path == file.path);
                                  }
                                  return;
                                }

                                chatStore.selectedIds.add(id);

                                final file = await entity.file;
                                if (file == null) {
                                  chatStore.selectedIds.remove(id);
                                  print("Không lấy được file gốc");
                                  return;
                                }

                                final exists = chatStore.listFile.any((f) => f.path == file.path);
                                if (!exists) {
                                  chatStore.listFile.add(file);
                                  print("");
                                }
                              },
                              child: Observer(
                                builder: (_) {

                                  final idx = chatStore.selectedIds.indexOf(entity.id);

                                  final isSelected = idx != -1;

                                  return SizedBox.expand(
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(3),
                                          child: Image.memory(
                                            bytes,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        if (isSelected)
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white24,
                                              borderRadius: BorderRadius.circular(3),
                                            ),
                                            child: Center(
                                              child: Container(
                                                height: 25,
                                                width: 25,
                                                decoration: const BoxDecoration(
                                                  color: Colors.deepPurple,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "${idx + 1}",
                                                    style: AppText.text14_bold.copyWith(color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

