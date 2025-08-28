import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:handoff_vdb_2025/core/base_widget/lazy_index_stack.dart';
import 'package:handoff_vdb_2025/core/enums/auth_enums.dart';
import 'package:handoff_vdb_2025/core/utils/color_resources.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/presentation/pages/dash_board/component/bottom_bar_widget.dart';
import 'package:handoff_vdb_2025/presentation/pages/dash_board/dash_board_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/friends_page.dart';
import 'package:handoff_vdb_2025/presentation/pages/home/home_page.dart';
import 'package:handoff_vdb_2025/presentation/pages/video/video_page.dart';
import 'package:handoff_vdb_2025/presentation/widget/custom_dialog.dart';
import '../profile/pages/profile_page/profile_page.dart';
import 'component/item_menu.dart';

class DashBoardPage extends StatefulWidget {

  DashBoardPage({super.key});

  @override
  State<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends State<DashBoardPage> with WidgetsBindingObserver {
  final DashBoardStore store = AppInit.instance.dashBoardStore;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    store.init();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      store.createPostStore.retryPendingPosts();
    }
    print("App lifecycle state changed: $state");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await _showExitDialog();
        if (shouldExit) {
          exit(0);
        }
        return false;
      },
      child: Observer(
        builder: (context) {
          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: const Text('HandOff'),
                actions: [
                  ItemMenu(image: ImagesPath.icBell, number: 1),
                  ItemMenu(
                      onTap: (){
                        context.push(AuthRoutes.CONVERSATION);
                      },
                      image: ImagesPath.icMessenger, number: 1
                  )
                ],
              ),
              bottomNavigationBar:
              store.postItemStore.isShowBottomSheet
              ? const SizedBox()
              : BottomAppBar(
                color: ColorResources.WHITE,
                height: 55.h,
                child: Padding(
                  padding: EdgeInsets.only(top: 0.h),
                  child: _buildBottomNavigationBar(),
                ),
              ),
              body: LazyIndexedStack(
                index: store.currentIndex,
                preloadCount: 1, // Preload adjacent pages for better UX
                children: [
                  const HomePage(),
                  const VideoPage(),
                  const FriendsPage(),
                  const ProfilePage(),
                ],
              )
          );
        }
      ),
    );
  }

  Future<bool> _showExitDialog() async {
    return await showDialog<bool>(
      context: context, 
      builder: (context) {
        return CustomDialog(
          title: "Bạn có muốn thoát?",
          message: "------------------",
          textNumber1: "Không",
          textNumber2: "Có",
          onTapNumber1: () {
            Navigator.pop(context, false);
          },
          onTapNumber2: () {
            Navigator.pop(context, true);
          },
        );
      },
    ) ?? false;
  }

  Widget _buildBottomNavigationBar() {
    return Observer(builder: (_) =>
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BottomBarWidget(
              onTap: () {
                store.onChangedDashboardPage(index: 0);
              },
              imagePath: ImagesPath.icHome,
              isSelected: store.currentIndex == 0,
            ),
            BottomBarWidget(
              onTap: () {
                store.onChangedDashboardPage(index: 1);
              },
              imagePath: ImagesPath.icVideoLibrary,
              isSelected: store.currentIndex == 1,
            ),
            BottomBarWidget(
              onTap: () {
                store.friendsStore.searchCtrl.textEditingController.text = '';
                store.onChangedDashboardPage(index: 2);
              },
              imagePath: ImagesPath.icFriends,
              isSelected: store.currentIndex == 2,
            ),
            BottomBarWidget(
              onTap: () {
                store.profileStore.getUserProfile();
                store.profileStore.loadInitialPostsByUserId();
                store.onChangedDashboardPage(index: 3);
              },
              imagePath: ImagesPath.icPerson,
              isSelected: store.currentIndex == 3,
            ),
          ],
        )
    );
  }
}

