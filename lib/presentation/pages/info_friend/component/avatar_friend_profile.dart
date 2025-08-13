import 'package:flutter/material.dart';

import '../../../../core/base_widget/images/set_up_asset_image.dart';
import '../../../../core/init/app_init.dart';
import '../../../../core/utils/images_path.dart';
import '../info_friend_store.dart';

class AvatarFriendProfile extends StatelessWidget {
  final InfoFriendStore store = AppInit.instance.infoFriendStore;
  AvatarFriendProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 90,
      backgroundColor: Colors.indigoAccent,
      child: ClipOval(
        child: SizedBox(
          width: 180,
          height: 180,
          child: SetUpAssetImage(
            store.profileFriend.user?.avatar ?? ImagesPath.icPerson,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
