import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/friends_store.dart';
import 'component/Item_friend.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final FriendsStore store = FriendsStore();

  @override
  void initState() {
    store.getAllFriends();
    store.getAllFriendsRequests();
    super.initState();
  }

  @override
  void dispose() {
    store.disposeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
          child: Image.asset(
            height: 24.h,
            width: 24.w,
            ImagesPath.icBack,
            color: Colors.grey,
          ),
        ),
        title: Text("Friends"),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Image.asset(
              height: 24.h,
              width: 24.w,
              ImagesPath.icSearch,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      body: Observer(builder: (_) => _buildBodyFriend()),
    );
  }

  /// Body
  Widget _buildBodyFriend() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryFriends(),
          Padding(
            padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
            child: SizedBox(
              height: 20.h,
              child: Text(
                "1000 friends",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          Expanded(
            child: ItemFriend(store: store,),
          ),
        ],
      ),
    );
  }

  /// Category Friends Page
  Widget _buildCategoryFriends() {
    return Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Container(
            constraints: BoxConstraints(maxHeight: 35.h),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCategoryButton(ALL_FRIENDS),
                  _buildCategoryButton(SUGGESTIONS_FRIENDS),
                  _buildCategoryButton(FRIEND_REQUESTS),
                  _buildCategoryButton(FOLLOWING),
                ],
              ),
            ),
          ),
        );
  }

  /// Category button
  Widget _buildCategoryButton(String buttonText) {
    final isSelected = store.selectedCategoryName == buttonText;
    return Padding(
      padding: EdgeInsets.only(right: 12.w),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20),
          color: isSelected ? Colors.blue : Colors.white,
        ),
        child: Center(
          child: TextButton(
            onPressed: () {
              store.setSelectedCategory(buttonText);
            },
            child: Text(
              buttonText,
              style: AppText.text14.copyWith(
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


