import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/core/helper/app_custom_circle_avatar.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';

import '../../../../core/helper/size_util.dart';
import '../../../../core/utils/images_path.dart';

class StoriesPage extends StatelessWidget {
  const StoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        height: double.infinity,
        width: SizeUtil.getMaxWidth(),
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.7,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: null,
              child: index != 0
                      ? buildStoriesItem(
                           context,
                           id: "",
                           name: "Tưởng Thị Kim Ngân",
                           isOnline: index.isEven,
                           avatarUrl: ImagesPath.icPerson,
                           coverUrl: "https://picsum.photos/300/200?random=${index + 1}",
                      )
                      : buildUserStoriesItem(
                           context,
                           id: "",
                           name: "Thêm vào tin",
                           coverUrl: "https://picsum.photos/300/200?random=$index",
                      ),
            );
          },
        ),
      ),
    );
  }

  Widget buildStoriesItem(
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
      child: Stack(
        children: [
          Image.network(
            coverUrl,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Transform.translate(
            offset: Offset(10, 10),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(width: 3, color: Colors.indigoAccent),
              ),
              child: Center(
                child: Stack(
                  children: [
                    AppCustomCircleAvatar(
                      image: avatarUrl,
                      radius: 15,
                      height: 35,
                      width: 35,
                    ),
                    Transform.translate(
                      offset: Offset(21.5, 22),
                      child: Container(
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.transparent,
                        ),
                        child: Center(
                          child: Container(
                            height: 11,
                            width: 11,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(10, 200),
            child: SizedBox(
              width: 120,
              child: Text(
                name,
                style: AppText.text14_Inter.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUserStoriesItem(
    BuildContext context, {
    required String id,
    required String name,
    required String coverUrl,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Image.network(
            coverUrl,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Transform.translate(
            offset: Offset(10, 10),
            child: Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Center(
                child: Icon(Icons.add, size: 25),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(60, 220),
            child: SizedBox(
              width: 120,
              child: Text(
                name,
                style: AppText.text14_Inter.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
