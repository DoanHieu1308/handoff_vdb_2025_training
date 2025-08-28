import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/base_widget/images/set_up_asset_image.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post_advanced_options_setting/create_post_advanced_options_setting_store.dart';

import '../create_post/component/widget_option.dart';

class CreatePostAdvancedOptionSetting extends StatefulWidget {
  const CreatePostAdvancedOptionSetting({super.key});

  @override
  State<CreatePostAdvancedOptionSetting> createState() => _CreatePostAdvancedOptionSettingState();
}

class _CreatePostAdvancedOptionSettingState extends State<CreatePostAdvancedOptionSetting> {
  final CreatePostAdvancedOptionSettingStore store = AppInit.instance.createPostAdvancedOptionSettingStore;

  @override
  void initState() {
    store.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
        builder: (context) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: CircleAvatar(
                  radius: 25,
                  child: ClipOval(
                    child: SizedBox(
                      height: 50.h,
                      width: 50.w,
                      child: SetUpAssetImage(
                        store.profileStore.userProfile.avatar ?? ImagesPath.icPerson,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: SizedBox(
                  height: 130.h,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            store.profileStore.userProfile.name ?? "",
                            style: AppText.text16_bold,
                          ),
                          if (store.tagFriendList.isNotEmpty) ...[
                            const SizedBox(width: 4),
                            Text(
                              "- với ",
                              style: AppText.text16,
                            ),
                            Text(
                              store.tagFriendList.first.name ?? "",
                              style: AppText.text16_bold,
                            ),
                            if (store.tagFriendList.length > 1) ...[
                              const SizedBox(width: 4),
                              Text(
                                "và ${store.tagFriendList.length - 1} người khác",
                                style: AppText.text16,
                              ),
                            ],
                          ],
                        ],
                      ),
                      SizedBox(height: 5.h),
                      Wrap(
                        runSpacing: 7.h,
                        spacing: 6.w,
                        children:
                        store.listNameItemOption.map<Widget>((option) {
                          return WidgetOption(
                            onTap: () {
                              store.onTapOptionPost(
                                context,
                                option.type,
                              );
                            },
                            name: option.name,
                            icon: option.icon,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }
    );
  }
}
