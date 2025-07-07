import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/base_widget/lazy_index_stack.dart';
import 'package:handoff_vdb_2025/core/utils/color_resources.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:handoff_vdb_2025/presentation/pages/dash_board/component/bottom_bar_widget.dart';
import 'package:handoff_vdb_2025/presentation/pages/dash_board/dash_board_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/dash_board/component/custom_bottom_bar.dart';
import '../../../config/routes/route_path/auth_routers.dart';
import '../profile/profile_page.dart';
import 'component/item_menu.dart';

class DashBoardPage extends StatelessWidget {
  final DashBoardStore store = DashBoardStore();

  DashBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Observer(builder: (_) =>
        Stack(
          children: [
            Scaffold(
                appBar: AppBar(
                  title: Text('HandOff'),
                  actions: [
                    ItemMenu(image: ImagesPath.icBell, onTap: () {}, number: 1),
                    ItemMenu(image: ImagesPath.icMessenger, onTap: () {}, number: 1),
                    ItemMenu(
                      image: ImagesPath.icFriends,
                      onTap: () {
                        Navigator.of(context).pushNamed(AuthRouters.FRIENDS);
                      },
                      number: 1,
                    ),
                  ],
                ),
                bottomNavigationBar: BottomAppBar(
                  color: ColorResources.WHITE,
                  height: 80.h,
                  child: Padding(
                    padding: EdgeInsets.only(top: 0.h),
                    child: _buildBottomNavigationBar(),
                  ),
                ),
                body: LazyIndexedStack(
                  index: store.currentIndex,
                  children: [
                    ProfilePage(
                      name: "Video",
                    ),
                    ProfilePage(
                      name: "Home",
                    ),
                    ProfilePage(
                      name: "Profile",
                    ),
                  ],
                )

            ),
            Positioned(
              right: width / 2 - 33.w,
              bottom: 15.h,
              child: CustomBottomBar(
                onTap: (){
                    store.onChangedDashboardPage(index: 1);
                },
                  imagePath: ImagesPath.icHome,
                  isSelected: store.currentIndex == 1),
            )
          ],
        )
    );
  }

  Row _buildBottomNavigationBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        BottomBarWidget(
          text: 'Video',
          onTap: () {
            store.onChangedDashboardPage(index: 0);
          },
          imagePath: ImagesPath.icVideoLibrary,
          isSelected: store.currentIndex == 0,
        ),
        SizedBox(
          width: 90.w,
        ),
        BottomBarWidget(
          text: 'Profile',
          onTap: () {
            store.onChangedDashboardPage(index: 2);
          },
          imagePath: ImagesPath.icPerson,
          isSelected: store.currentIndex == 2,
        ),
      ],
    );
  }
}

