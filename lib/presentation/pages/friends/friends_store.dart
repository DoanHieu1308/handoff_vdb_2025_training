import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/config/routes/route_path/auth_routers.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';
import 'package:handoff_vdb_2025/data/model/friend/friend_model.dart';
import 'package:handoff_vdb_2025/data/model/friend/friend_request_model.dart';
import 'package:handoff_vdb_2025/data/model/friend/friend_sent_model.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import 'package:handoff_vdb_2025/data/repositories/friend_repository.dart';
import 'package:handoff_vdb_2025/presentation/pages/info_friend/info_friend_store.dart';
import 'package:handoff_vdb_2025/presentation/pages/search/search_store.dart';
import 'package:mobx/mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../widget/build_snackbar.dart';

part 'friends_store.g.dart';

class FriendsStore = _FriendsStore with _$FriendsStore;

abstract class _FriendsStore with Store {
  /// Controller
  RefreshController? _refreshController;

  /// Getter cho refreshController
  RefreshController get refreshController {
    _refreshController ??= RefreshController();
    return _refreshController!;
  }

  /// Store
  final SearchStore searchCtrl = AppInit.instance.searchStore;
  // Lazy initialization to break circular dependency
  InfoFriendStore get infoFriendStore => AppInit.instance.infoFriendStore;

  /// Repository
  late final FriendRepository _friendRepository;

  /// SharePreference
  final _sharedPreferenceHelper = AppInit.instance.sharedPreferenceHelper;

  /// Select Category
  @observable
  String selectedCategoryName = "All";

  /// Loading
  @observable
  bool isLoading = false;

  /// ALl
  @observable
  ObservableList<UserModel> friendList = ObservableList.of([]);

  /// Pending
  @observable
  ObservableList<FriendRequestModel> friendListPending = ObservableList.of([]);

  /// Suggestion
  @observable
  ObservableList<UserModel> friendListSuggestion = ObservableList.of([]);
  @observable
  ObservableList<Map<String, dynamic>> friendListSuggestionStatus = ObservableList.of([]);

  /// Sent
  @observable
  ObservableList<FriendSentModel> friendListSent = ObservableList.of([]);


  /// Search
  @observable
  List<UserModel> friendListSearch = [];

  /// Accept
  @observable
  FriendModel acceptFriend = FriendModel();

  /// Reject
  @observable
  FriendModel rejectFriend = FriendModel();

  ///-------------------------------------------------------------
  /// Init
  ///
  _FriendsStore() {
     _init();
  }
  Future<void> _init() async {
    // Get dependencies directly
    _friendRepository = FriendRepository();
  }

  ///------------------------------------------------------------
  /// Dispose
  ///
  void disposeAll() {
    _refreshController?.dispose();
    _refreshController = null;
    searchCtrl.disposeAll();
  }

  ///------------------------------------------------------------
  /// Selected Category
  ///
  @action
  void setSelectedCategory(String name) {
    selectedCategoryName = name;
  }

  ///------------------------------------------------------------
  /// Get data
  ///
  @action
  Future<void> getDataFriend(String name) async {
    isLoading = true;
    if(name == ALL_FRIENDS){
      Future.delayed(const Duration(milliseconds: 700), () async {
        await getAllFriends();
        isLoading = false;
      });
    }
    else if(name == FRIEND_REQUESTS){
      Future.delayed(const Duration(milliseconds: 700), () async {
        await getAllFriendsRequests();
        isLoading = false;
      });
    }
    else if(name == SUGGESTIONS_FRIENDS){
      Future.delayed(const Duration(milliseconds: 700), () async {
        await getAllFriendSuggestions();
        isLoading = false;
      });
    }
    else if(name == FRIEND_SEND){
      Future.delayed(const Duration(milliseconds: 700), () async {
        await getAllFriendsSent();
        isLoading = false;
      });
    }
  }



  ///---------------------------------------------------------------
  /// Get All Friends
  ///
  Future<void> getAllFriends() async {
     isLoading = true;
     print("get all friend access __${_sharedPreferenceHelper.getAccessToken}");
     // Debug: Check token before making request
         await _friendRepository.getAllFriend(
         onSuccess: (list) {
           friendList = ObservableList.of(list);

           if (friendList.isNotEmpty) {
             print("friend list ${friendList[0].name}");
           } else {
             print("No friends found");
           }
           isLoading = false;
         },
         onError: (error){
           isLoading = false;
           print("loi o all friend $error");
         }
     );
  }



  ///----------------------------------------------------------
  /// Get All Friends Suggestion
  ///
  Future<void> getAllFriendSuggestions() async {
    isLoading = true;

    await _friendRepository.getAllFriendSuggestions(
        onSuccess: (list) {
          friendListSuggestion = ObservableList.of(list);

          if (friendListSuggestion.isNotEmpty) {
            print("friend list sugges ${friendListSuggestion[0].name}");
          } else {
            print("No friends found");
          }
          isLoading = false;
        },
        onError: (error){
          isLoading = false;
          print("loi o all friend $error");
        }
    );
  }



  ///-------------------------------------------------------
  /// Get All Friends Requests
  ///
  Future<void> getAllFriendsRequests() async {
    isLoading = true;

    await _friendRepository.getAllFriendRequests(
        onSuccess: (list) {
          friendListPending = ObservableList.of(list);

          if (friendListPending.isNotEmpty) {
            print(friendListPending[0].fromUser?.name);
          } else {
            print("No friend requests found");
          }
          print("Updated friendListPending length: ${friendListPending.length}");

          isLoading = false;
        },
        onError: (error){
          isLoading = false;
          print("loi o friend requests $error");
        }
    );
  }



  ///-------------------------------------------------------
  /// Get All Friends Sent
  ///
  Future<void> getAllFriendsSent() async {
    isLoading = true;

    await _friendRepository.getAllFriendSent(
        onSuccess: (list) {
          friendListSent = ObservableList.of(list);

          if (friendListSent.isNotEmpty) {
            print(friendListSent[0].toUser?.name);
          } else {
            print("No friend requests found");
          }
          print("Updated friendListPending length: ${friendListSent.length}");

          isLoading = false;
        },
        onError: (error){
          isLoading = false;
          print("loi o friend requests $error");
        }
    );
  }

  ///--------------------------------------------------
  /// Accept
  ///
  Future<void> acceptFriendRequest({
    required String userId,
    required Function() onSuccess,
    required Function(dynamic error) onError
  }) async {

    await _friendRepository.acceptFriendRequest(
        userId: userId,
        onSuccess: (data) {
          acceptFriend = data;
          print("accept: ${acceptFriend.toUser}");
          onSuccess();
        },
        onError: (error){
          print("loi o friend requests $error");
          onError(error);
        }
    );
  }

  /// Handle accept friend request from UI
  @action
  Future<void> handleAcceptFriendRequest({required String friendId}) async {
    if (friendId.isNotEmpty) {
      await acceptFriendRequest(
        userId: friendId,
        onSuccess: () async {
          final index = friendListPending.indexWhere(
                  (friend) => friend.fromUser?.id == friendId);
          if (index != -1) {
            final updatedFriend = friendListPending[index].copyWith(status: "accepted");
            friendListPending[index] = updatedFriend;
            print("Friend request accepted successfully");
          } else {
            print("Friend not found in pending list.");
          }
        },
        onError: (error) {
          print("Error accepting friend request: $error");
        },
      );
    }
  }

  ///----------------------------------------------------------------
  /// Handle reject friend request from UI
  ///
  // Remove friend request from lists
  void removeFriendRequestFromLists(String friendId) {
    friendListPending.removeWhere((request) => request.fromUser?.id == friendId);
  }
  // Handle reject
  @action
  Future<void> handleRejectFriendRequest({
    required String friendId,
    required BuildContext context,
    required String nameItemDetail,
    required Function() onSuccess,
  }) async {
    isLoading = true;

    await _friendRepository.rejectFriendRequest(
      friendId: friendId,
      onSuccess: (data) async {
        rejectFriend = data;
        print("reject: ${rejectFriend.toUser}");
        isLoading = false;

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            buildSnackBarNotify(textNotify: "Successfully $nameItemDetail"),
          );
        }
        removeFriendRequestFromLists(friendId);
        await getAllFriendsRequests();
        onSuccess();
      },
      onError: (error) {
        isLoading = false;
        print("Error rejecting friend request: $error");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      },
    );
  }

  ///--------------------------------------------------------
  ///  Unfriend
  ///
  @action
  void removeFriendFromAllLists(String friendId) {
    friendList.removeWhere((friend) => friend.id == friendId);
  }

  Future<void> handleUnFriendRequest({
    required String friendId,
    required BuildContext context,
    required String nameItemDetail,
  }) async {
    isLoading = true;

    await _friendRepository.unFriend(
        friendId: friendId,
        onSuccess: () async {
          isLoading = false;
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              buildSnackBarNotify(textNotify: "Successfully $nameItemDetail"),
            );
          }
          removeFriendFromAllLists(friendId);
          await getAllFriends();
        },
        onError: (error){
          isLoading = false;
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(error)));
        }
    );
  }



  ///------------------------------------------------------------------------
  /// Sent
  ///

  /// Get All Friends Requests
  Future<void> sentFriendRequest({
    required String friendId,
    required Function() onSuccess,
    required Function(dynamic error) onError
  }) async {
    await _friendRepository.sentFriendRequest(
        friendId: friendId,
        onSuccess: () {
          onSuccess();
        },
        onError: (error){
          print("loi o sent friend requests $error");
          onError(error);
        }
    );
  }

  /// Remove friend from suggestion if fail
  @action
  void removeFriendFromSuggestionIfFailed(String friendId) {
    final index = friendListSuggestionStatus.indexWhere(
          (friend) => friend['id'] == friendId,
    );

    if (index != -1) {
      friendListSuggestionStatus.removeAt(index);
      print("Removed friend with id $friendId due to failed request.");
    } else {
      print("Friend with id $friendId not found.");
    }
  }

  String getStatusForFriend(String friendId) {
    final index = friendListSuggestionStatus.indexWhere(
          (item) => item['id'] == friendId,
    );
    return index != -1 ? friendListSuggestionStatus[index]['type'] ?? 'none' : 'none';
  }

  /// Set send status in friend suggestion
  @action
  void setSendStatus(String friendId){
    final index = friendListSuggestion.indexWhere(
          (friend) => friend.id == friendId,
    );

    if (index != -1) {
      final statusIndex = friendListSuggestionStatus.indexWhere(
            (item) => item['id'] == friendId,
      );

      if (statusIndex != -1) {
        // Nếu đã có, cập nhật lại status
        friendListSuggestionStatus[statusIndex] = {
          ...friendListSuggestionStatus[statusIndex],
          'type': 'send',
        };
      } else {
        // Nếu chưa có, thêm mới
        friendListSuggestionStatus.add({
          'id': friendId,
          'type': 'send',
        });
      }
      print("Friend request sent successfully");
    } else {
      print("Friend not found in suggestion list.");
    }
  }

  /// Handle accept friend request from UI
  @action
  Future<void> handleSentFriendRequest({
    required String friendId,
    required Function() onSuccess,
  }) async {
    if (friendId.isNotEmpty) {
      await sentFriendRequest(
        friendId: friendId,
        onSuccess: () async {
          setSendStatus(friendId);
          onSuccess();
        },
        onError: (error) {
          removeFriendFromSuggestionIfFailed(friendId);
          print("Error sending friend request: $error");
        },
      );
    }
  }


  /// -------------------------------------------------------------
  /// Cancel sent friend request
  ///

  /// Cancel friend request
  Future<void> cancelFriendRequest({
    required String friendId,
    required Function() onSuccess,
    required Function(dynamic error) onError
  }) async {
    await _friendRepository.cancelFriendRequest(
        friendId: friendId,
        onSuccess: () {
          onSuccess();
        },
        onError: (error){
          print("loi o sent friend requests $error");
          onError(error);
        }
    );
  }

  @action
  void setCancelStatus(String friendId){
    print(friendListSuggestionStatus.toString());
    final index = friendListSuggestionStatus.indexWhere(
          (friend) => friend['id'] == friendId,
    );
    print("index$index");
    if (index != -1) {
      final statusIndex = friendListSuggestionStatus.indexWhere(
            (item) => item['id'] == friendId,
      );

      if (statusIndex != -1) {
        // Nếu đã tồn tại, cập nhật lại status
        friendListSuggestionStatus[statusIndex] = {
          ...friendListSuggestionStatus[statusIndex],
          'type': 'canceled',
        };
      } else {
        // Nếu chưa tồn tại thì thêm mới
        friendListSuggestionStatus.add({
          'id': friendId,
          'type': 'canceled',
        });
      }

      print("Friend request canceled successfully");
    } else {
      print("Friend not found in pending list.");
    }
  }

  /// Handle cancel friend request from UI
  @action
  Future<void> handleCancelFriendRequest({
    required String friendId,
    required Function() onSuccess,
  }) async {
    if (friendId.isNotEmpty) {
      await cancelFriendRequest(
        friendId: friendId,
        onSuccess: () async {
            setCancelStatus(friendId);
            onSuccess();
        },
        onError: (error) {
          removeFriendFromSuggestionIfFailed(friendId);
          print("Error canceling friend request: $error");
        },
      );
    }
  }

  /// -----------------------------------------------------------
  /// Searching
  ///
  @action
  void getItemSearch() {
    friendListSearch.clear();
    final lowerSearch = searchCtrl.searchText.toLowerCase();

    for (final item in friendList) {
      final name = item.name;
      if (name != null && name.toLowerCase().contains(lowerSearch)) {
        friendListSearch.add(item);
      }
    }
  }

  ///--------------------------------------------------------
  ///  Go to info friend
  ///
  @action
  Future<void> goToInfoFriend({
    required String friendId,
    required BuildContext context
  })async {
    await infoFriendStore.getFriendProfile(friendId: friendId).then((_) {
      Navigator.of(context).pushNamed(
        AuthRouters.INFO_FRIENDS,
      );
    });
  }

  /// --------------------------------------------------------------
  /// Kiểm tra trạng thái đăng nhập
  ///
  @action
  Future<void> checkLoginStatus() async {
    print("Friend store");
    final accessToken = _sharedPreferenceHelper.getAccessToken;
    final refreshToken = _sharedPreferenceHelper.getRefreshToken;
    final email = _sharedPreferenceHelper.getEmail;
    print("accessToken: $accessToken");
  }

}
