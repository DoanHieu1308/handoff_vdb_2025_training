import 'package:flutter/material.dart';

import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/helper/app_sitebox.dart';
import '../../../../core/helper/app_tap_animation.dart';
import '../../../../core/helper/app_text.dart';
import '../../../../core/helper/size_util.dart';
import '../../../../core/init/app_init.dart';
import '../../../../core/utils/color_resources.dart';
import '../../../../core/utils/images_path.dart';

class ConversationBottomNavigationBar extends StatelessWidget {
  final conversationStore = AppInit.instance.conversationStore;
  ConversationBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _itemBottomNavigationBar(
          iconPath: ImagesPath.icChat,
          label: "Đoạn chat",
          index: 0,
          currentIndex: conversationStore.currentIndex,
          onTap: () => conversationStore.onChangedDashboardPage(index: 0),
        ),
        _itemBottomNavigationBar(
          iconPath: ImagesPath.icStories,
          label: "Tin",
          index: 1,
          currentIndex: conversationStore.currentIndex,
          onTap: () => conversationStore.onChangedDashboardPage(index: 1),
        ),
      ],
    );
  }


  Widget _itemBottomNavigationBar({
    required String iconPath,
    required String label,
    required int index,
    required int currentIndex,
    required VoidCallback onTap,
  }) {
    return AppTapAnimation(
      enabled: true,
      onTap: onTap,
      child: Container(
        width: SizeUtil.getMaxWidth() / 3 - 10,
        height: 58,
        color: Colors.transparent,
        child: Column(
          children: [
            AppSiteBox.h5,
            SetUpAssetImage(
              iconPath,
              width: 24,
              height: 24,
              color: currentIndex == index
                  ? ColorResources.COLOR_0956D6
                  : ColorResources.COLOR_071A52,
              fit: BoxFit.fill,
            ),
            AppSiteBox.h5,
            Text(label, style: AppText.text11),
          ],
        ),
      ),
    );
  }
}
