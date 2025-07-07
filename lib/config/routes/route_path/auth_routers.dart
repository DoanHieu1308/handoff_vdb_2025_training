import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/presentation/pages/dash_board/dash_board_page.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/friends_page.dart';
import 'package:handoff_vdb_2025/presentation/pages/login/login_page.dart';
import 'package:handoff_vdb_2025/presentation/pages/sign_up/sign_up_page.dart';

mixin AuthRouters {
  static const String DASH_BOARD = '/dash_board';
  static const String FRIENDS = '/friends';
  static const String LOGIN = '/login';
  static const String SIGNUP = '/sign_up';

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
    else {
      return MaterialPageRoute(
          builder: (context) => DashBoardPage(),
          settings: settings
      );
    }
  }
}
