import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handoff_vdb_2025/core/helper/app_text.dart';
import 'package:handoff_vdb_2025/core/helper/size_util.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';
import 'package:handoff_vdb_2025/core/utils/images_path.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/friends_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/search/component/list_item_friend_search.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'component/header.dart';
import 'component/list_friend_request.dart';
import 'component/list_user_friend.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  late FriendsStore store;
  late RefreshController searchRefreshController;
  late VoidCallback searchListener;

  @override
  void initState() {
    super.initState();

    store = AppInit.instance.friendsStore;
    searchRefreshController = RefreshController();

    store.searchCtrl.searchText = '';

    // Thêm listener cho search text thay đổi
    searchListener = () {
      if (mounted) {
        store.getItemSearch();
        // Tắt bàn phím khi search text rỗng
        if (store.searchCtrl.searchText.isEmpty) {
          FocusScope.of(context).unfocus();
        }
      }
    };
    store.searchCtrl.textEditingController.addListener(searchListener);
  }

  @override
  void dispose() {
    store.disposeAll();
    searchRefreshController.dispose();
    
    // Remove listener
    store.searchCtrl.textEditingController.removeListener(searchListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder:
          (_) => WillPopScope(
            onWillPop: () async {
              FocusScope.of(context).unfocus();
              return true;
            },
            child: SafeArea(
              child: GestureDetector(
                onTap: () {
                  // Tắt bàn phím khi tap vào màn hình
                  FocusScope.of(context).unfocus();
                },
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: Column(
                children: [
                  SizedBox(height: 30.h,),
                  Header(),
                  Container(
                    margin: EdgeInsets.only(top: 10.h),
                    height: 1.h,
                    width: SizeUtil.getMaxWidth(),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        if (store.searchCtrl.searchText.isNotEmpty)
                          _buildData()
                        else
                          Expanded(child: _buildBodyFriend()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
    )));
  }

  Widget _buildData() {
    return Expanded(
        child: Observer(builder: (context){
          if(store.friendListSearch.isNotEmpty) {
            return ListItemFriendSearch(
              friendList:store.friendListSearch,
              icon: ImagesPath.icMessenger,
              numberFriend: "${store.friendListSearch.length} friends",
              store: store,
            );
          } else {
            return Center(child: Text("No friends found"));
          }
        })
    );
  }

  /// Body
  Widget _buildBodyFriend() {
    return Observer(
      builder:
          (_) => Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryFriends(),
              SizedBox(height: 10.h),
              Expanded(
                  child: _buildFriendList()
              ),
            ],
          ),
    );
  }

  /// Build friend list
  Widget _buildFriendList() {
    final category = store.selectedCategoryName;

    if (store.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (category == ALL_FRIENDS || category == SUGGESTIONS_FRIENDS) {
      return ListUserFriend(store: store);
    }
    else {
      return ListFriendRequest(store: store);
    }
  }

  /// Category Friends Page
  Widget _buildCategoryFriends() {
    return Observer(
      builder:
          (_) => Padding(
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
                    _buildCategoryButton(FRIEND_SEND),
                  ],
                ),
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
              store.getDataFriend(buttonText);
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
