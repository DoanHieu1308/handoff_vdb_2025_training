import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/base_widget/lazy_index_stack.dart';
import 'package:handoff_vdb_2025/core/utils/color_resources.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:handoff_vdb_2025/presentation/pages/dash_board/component/bottom_bar_widget.dart';
import 'package:handoff_vdb_2025/presentation/pages/dash_board/dash_board_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/friends_page.dart';
import 'package:handoff_vdb_2025/presentation/pages/home/home_page.dart';
import 'package:handoff_vdb_2025/presentation/pages/video/video_page.dart';
import 'package:handoff_vdb_2025/presentation/widget/custom_dialog.dart';
import '../profile/profile_page.dart';
import 'component/item_menu.dart';

class DashBoardPage extends StatelessWidget {
  final DashBoardStore store = DashBoardStore();

  DashBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Observer(builder: (_) =>
        WillPopScope(
          onWillPop: () async {
            showDialog(context: context, builder: (context) {
              return CustomDialog(
                title: "Ban co muon thoat?",
                message: "------------------",
                textNumber1: "No",
                textNumber2: "Yes",
                onTapNumber1: (){
                  Navigator.pop(context);
                },
                onTapNumber2: (){
                  exit(0);
                },
              );
            });
            return true;
          },
          child: Scaffold(
              appBar: AppBar(
                title: Text('HandOff'),
                actions: [
                  ItemMenu(image: ImagesPath.icBell, onTap: () {}, number: 1),
                  ItemMenu(image: ImagesPath.icMessenger, onTap: () {}, number: 1),
                ],
              ),
              bottomNavigationBar: BottomAppBar(
                color: ColorResources.WHITE,
                height: 55.h,
                child: Padding(
                  padding: EdgeInsets.only(top: 0.h),
                  child: _buildBottomNavigationBar(),
                ),
              ),
              body: LazyIndexedStack(
                index: store.currentIndex,
                children: [
                  HomePage(),
                  VideoPage(),
                  FriendsPage(),
                  ProfilePage(),
                ],
              )
          
          ),
        )
    );
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

