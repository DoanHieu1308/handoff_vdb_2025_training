import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:handoff_vdb_2025/core/shared_pref/auth_helper.dart';
import 'package:handoff_vdb_2025/presentation/pages/conversation/chat/components/chat_custom_show_media_gallery.dart';
import 'package:handoff_vdb_2025/presentation/pages/conversation/conversation_page.dart';
import 'package:handoff_vdb_2025/presentation/pages/conversation/messenger/messenger_page.dart';
import 'package:handoff_vdb_2025/presentation/pages/create_post/create_post_page.dart';
import 'package:handoff_vdb_2025/presentation/pages/dash_board/dash_board_page.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/friends_page.dart';
import 'package:handoff_vdb_2025/presentation/pages/info_friend/info_friend_page.dart';
import 'package:handoff_vdb_2025/presentation/pages/login/login_page.dart';
import 'package:handoff_vdb_2025/presentation/pages/info_friend/component/more_setting_info_friend.dart';
import 'package:handoff_vdb_2025/presentation/pages/profile/component/show_all_friend_in_profile.dart';
import 'package:handoff_vdb_2025/presentation/pages/sign_up/sign_up_page.dart';
import '../../../core/enums/auth_enums.dart';
import '../../../data/model/post/post_output_model.dart';
import '../../../presentation/pages/create_post_advanced_options_setting/component/status_post_page.dart';
import '../../../presentation/pages/create_post_advanced_options_setting/component/tag_friends_page.dart';
import '../../../presentation/pages/posts/components/show_all_image.dart';
import '../../../presentation/pages/profile/pages/profile_picture_camera/profile_picture_camera.dart';
import '../../../presentation/pages/conversation/chat/chat_page.dart';
import '../../../data/model/response/user_model.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();


final GoRouter router = GoRouter(
  initialLocation: AuthRoutes.SIGNUP,
    redirect: (context, state) {
      final bool isLoggedIn = AuthHelper.isUserLoggedIn();
      final String goingTo = state.matchedLocation;

      // Nếu chưa đăng nhập và đang cố vào trang ngoài login/signup → bắt về login
      if (!isLoggedIn &&
          goingTo != AuthRoutes.LOGIN &&
          goingTo != AuthRoutes.SIGNUP) {
        return AuthRoutes.LOGIN;
      }

      // Nếu đã login mà lại vào login/signup → chuyển về dashboard
      if (isLoggedIn &&
          (goingTo == AuthRoutes.LOGIN || goingTo == AuthRoutes.SIGNUP)) {
        return AuthRoutes.DASH_BOARD;
      }

      // Ngược lại → cho đi đúng trang đã chọn
      return null;
    },
  routes: [
    GoRoute(
      path: AuthRoutes.DASH_BOARD,
      builder: (context, state) => DashBoardPage(),
    ),
    GoRoute(
      path: AuthRoutes.FRIENDS,
      builder: (context, state) => FriendsPage(),
    ),
    GoRoute(
      path: AuthRoutes.INFO_FRIENDS,
      builder: (context, state) => InfoFriendPage(),
    ),
    GoRoute(
      path: AuthRoutes.LOGIN,
      builder: (context, state) {
        return LoginPage();
      },
    ),
    GoRoute(
      path: AuthRoutes.SIGNUP,
      builder: (context, state) => SignUpPage(),
    ),
    GoRoute(
      path: AuthRoutes.MORE_SETTING_INFO_FRIEND,
      builder: (context, state) => MoreSettingInfoFriend(),
    ),
    GoRoute(
      path: AuthRoutes.CAMERA,
      builder: (context, state) => ProfilePictureCamera(),
    ),
    GoRoute(
      path: AuthRoutes.CREATE_POST,
      builder: (context, state) {
        return CreatePostPage();
      },
    ),
    GoRoute(
      path: AuthRoutes.STATUS_POST,
      builder: (context, state) => StatusPostPage(),
    ),
    GoRoute(
      path: AuthRoutes.TAG_FRIEND,
      builder: (context, state) => TagFriendsPage(),
    ),
    GoRoute(
      path: AuthRoutes.CHAT,
      builder: (context, state) {
        final friend = state.extra as UserModel;
        return ChatPage(friend: friend);
      },
    ),
    GoRoute(
      path: AuthRoutes.MESSENGER,
      builder: (context, state) => MessengerPage(),
    ),
    GoRoute(
      path: AuthRoutes.CONVERSATION,
      builder: (context, state) => ConversationPage(),
    ),
    GoRoute(
      path: AuthRoutes.ALL_FRIEND,
      builder: (context, state) => ShowAllFriendInProfile(),
    ),
    GoRoute(
      path: AuthRoutes.CHAT_CUSTOM_SHOW_MEDIA,
      builder: (context, state) => ChatCustomShowMediaGallery(),
    ),
    GoRoute(
      path: AuthRoutes.SHOW_ALL_IMAGE,
      builder: (context, state) {
        final postData = state.extra as PostOutputModel;
        return ShowAllImage(postData: postData);
      }
    ),
  ],
  observers: [routeObserver]
);
