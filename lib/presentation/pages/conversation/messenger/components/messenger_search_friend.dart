import 'package:flutter/material.dart';

import '../../../../../core/helper/app_sitebox.dart';
import '../../../../../core/helper/app_text.dart';
import '../../../../../core/helper/size_util.dart';
import '../../../../../core/init/app_init.dart';
import '../../../../../core/utils/color_resources.dart';

class MessengerSearchFriend extends StatelessWidget {
  final messengerStore = AppInit.instance.messengerStore;
  MessengerSearchFriend({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      width: SizeUtil.getMaxWidth() - 40,
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        color: Colors.indigoAccent.shade100.withValues(alpha: 0.09),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 23,
            height: 23,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.pink.shade700,
                  Colors.indigoAccent,
                  Colors.blue,
                ],
              ),
            ),
            child: Center(
              child: Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          AppSiteBox.w7,
          Expanded(
            child: TextFormField(
              controller: messengerStore.searchMessController,
              focusNode: messengerStore.searchFocusNode,
              style: AppText.text14_Inter,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm',
                hintStyle: AppText.text14.copyWith(
                  color: ColorResources.HINT_TEXT,
                ),
                border: InputBorder.none,
                counterStyle: const TextStyle(
                  color: ColorResources.COLOR_918F95,
                ),
              ),
              maxLines: 1,
              cursorColor: ColorResources.COLOR_5D4D87,
              onChanged: (val) {
                messengerStore.isHasInput = val.isNotEmpty;
              },
            ),
          ),
        ],
      ),
    );
  }
}
