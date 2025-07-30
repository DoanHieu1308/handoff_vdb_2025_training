import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/presentation/pages/camera/camera_page.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/create_post_page.dart';
import 'package:handoff_vdb_2025/presentation/pages/dash_board/dash_board_page.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/friends_page.dart';
import 'package:handoff_vdb_2025/presentation/pages/info_friend/info_friend_page.dart';
import 'package:handoff_vdb_2025/presentation/pages/login/login_page.dart';
import 'package:handoff_vdb_2025/presentation/pages/info_friend/component/more_setting_info_friend.dart';
import 'package:handoff_vdb_2025/presentation/pages/sign_up/sign_up_page.dart';

import '../../../presentation/pages/create_post/component/post_advanced_options_setting/page/status_post_page.dart';
import '../../../presentation/pages/create_post/component/post_advanced_options_setting/page/tag_friends_page.dart';

mixin AuthRouters {
  static const String DASH_BOARD = '/dash_board';
  static const String FRIENDS = '/friends';
  static const String INFO_FRIENDS = '/info_friends';
  static const String LOGIN = '/login';
  static const String SIGNUP = '/sign_up';
  static const String MORE_SETTING_INFO_FRIEND = '/more_setting_info_friend';
  static const String CAMERA = '/camera';
  static const String CREATE_POST = '/create_post';
  static const String STATUS_POST = '/status_post';
  static const String TAG_FRIEND = '/tag_friend';

  static Route<dynamic> routes(RouteSettings settings) {
    if (settings.name == DASH_BOARD) {
      return MaterialPageRoute(
          builder: (context) => DashBoardPage(),
          settings: settings
      );
    }
    else if (settings.name == FRIENDS) {
      return MaterialPageRoute(
          builder: (context) => FriendsPage(),
          settings: settings
      );
    }
    else if (settings.name == INFO_FRIENDS) {
      return MaterialPageRoute(
          builder: (context) => InfoFriendPage(),
          settings: settings
      );
    }
    else if (settings.name == LOGIN) {
      return MaterialPageRoute(
          builder: (context) => LoginPage(),
          settings: settings
      );
    }
    else if (settings.name == SIGNUP) {
      return MaterialPageRoute(
          builder: (context) => SignUpPage(),
          settings: settings
      );
    }
    else if (settings.name == MORE_SETTING_INFO_FRIEND) {
      return MaterialPageRoute(
          builder: (context) => MoreSettingInfoFriend(),
          settings: settings
      );
    }
    else if (settings.name == CAMERA) {
      return MaterialPageRoute(
          builder: (context) => CameraPage(),
          settings: settings
      );
    }
    else if (settings.name == CREATE_POST) {
      return MaterialPageRoute(
          builder: (context) => CreatePostPage(),
          settings: settings
      );
    }
    else if (settings.name == STATUS_POST) {
      return MaterialPageRoute(
          builder: (context) => StatusPostPage(),
          settings: settings
      );
    }
    else if (settings.name == TAG_FRIEND) {
      return MaterialPageRoute(
          builder: (context) => TagFriendsPage(),
          settings: settings
      );
    }
    else {
      return MaterialPageRoute(
          builder: (context) => DashBoardPage(),
          settings: settings
      );
    }
  }
}
