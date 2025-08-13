import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/helper/size_util.dart';
import 'package:handoff_vdb_2025/presentation/pages/home/home_store.dart';

import '../../../../core/init/app_init.dart';

class PostCreationProgress extends StatelessWidget {
  final HomeStore store = AppInit.instance.homeStore;
  PostCreationProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: SizedBox(
        height: 60,
        width: SizeUtil.getMaxWidth(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              child: ClipOval(
                child: SizedBox(
                  height: 45,
                  width: 45,
                  child: SetUpAssetImage(
                      store.profileStore.userProfile.avatar ?? "",
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      gaplessPlayback: true,
                      errorBuilder: (context, error, stackTrace) {
                        return Text('Image load error');
                      },
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Đang đăng..."),
                Text("Không đóng ứng dụng", style: AppText.text14.copyWith(color: Colors.grey.shade500))
              ],
            ),
            const Spacer(),
            const SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator()
            ),
          ],
        ),
      ),
    );
  }
}
