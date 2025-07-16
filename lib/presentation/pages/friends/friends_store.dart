import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:handoff_vdb_2025/config/routes/route_path/auth_routers.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/utils/app_constants.dart';
import 'package:handoff_vdb_2025/data/model/friend/friend_model.dart';
import 'package:handoff_vdb_2025/data/model/friend/friend_request_model.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import 'package:handoff_vdb_2025/data/repositories/friend_repository.dart';
import 'package:handoff_vdb_2025/presentation/pages/search/search_store.dart';
import 'package:mobx/mobx.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../core/shared_pref/shared_preference_helper.dart';
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

  /// Repository
  late final FriendRepository _friendRepository;

  /// SharePreference
  late final _sharedPreferenceHelper;

  /// Select Category
  @observable
  String selectedCategoryName = "All";

  /// Loading
  @observable
  bool isLoading = false;

  /// ALl
  @observable
  List<UserModel> friendList = [];

  /// Pending
  @observable
  List<FriendRequestModel> listRequests = [];
  @observable
  List<UserModel> friendListPending = [];

  /// Suggestion
  @observable
  List<UserModel> friendListSuggestion = [];

  /// Follow
  @observable
  List<UserModel> friendListFollower = [];

  /// Search
  @observable
  List<UserModel> friendListSearch = [];

  /// Accept
  @observable
  FriendModel acceptFriend = FriendModel();
  @observable
  ObservableMap<String, bool> acceptedFriends = ObservableMap<String, bool>();

  /// Reject
  @observable
  FriendModel rejectFriend = FriendModel();

  ///
  /// Init
  ///
  _FriendsStore() {
     _init();
  }
  Future<void> _init() async {
    // Get dependencies directly
    _friendRepository = FriendRepository();
    _sharedPreferenceHelper = SharedPreferenceHelper.instance;
  }

  ///
  /// on Refresh
  ///
  void onRefresh() async{
    try{
      await Future.delayed(Duration(milliseconds: 1000));
      await getAllFriendsRequests();
      print("acceptedFriends ${acceptedFriends.length}");
      refreshController.refreshCompleted();
    }catch (e) {
      refreshController.refreshFailed();
    }

  }

  ///
  /// on Loading
  ///
  void onLoading() async{
    await Future.delayed(Duration(milliseconds: 1000));
    refreshController.loadComplete();
  }

  ///
  /// Dispose
  ///
  void disposeAll() {
    _refreshController?.dispose();
    _refreshController = null;
    searchCtrl.disposeAll();
  }

  ///
  /// Selected Category
  ///
  @action
  void setSelectedCategory(String name) {
    selectedCategoryName = name;
  }

  ///
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
    else if(name == FOLLOWING){
      Future.delayed(const Duration(milliseconds: 700), () async {
        isLoading = false;
      });
    }
  }

  ///
  /// Get All Friends
  ///
  Future<void> getAllFriends() async {
     isLoading = true;
     // Debug: Check token before making request
         await _friendRepository.getAllFriend(
         onSuccess: (list) {
           friendList = list;

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

  ///
  /// Get All Friends
  ///
  Future<void> getAllFriendSuggestions() async {
    isLoading = true;

    await _friendRepository.getAllFriendSuggestions(
        onSuccess: (list) {
          friendListSuggestion = list;

          if (friendListSuggestion.isNotEmpty) {
            print("friend list ${friendListSuggestion[0].name}");
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

  ///
  /// Get All Friends Requests
  ///
  Future<void> getAllFriendsRequests() async {
    isLoading = true;

    await _friendRepository.getAllFriendRequests(
        onSuccess: (list) {
          listRequests = list;

          if (listRequests.isNotEmpty) {
            print(listRequests[0].fromUser?.name);
          } else {
            print("No friend requests found");
          }

          friendListPending = ObservableList.of(
            listRequests.map((item) => item.fromUser!).toList(),
          );

          if (friendListPending.isNotEmpty) {
            print(friendListPending[0].name);
          } else {
            print("No pending friends found");
          }
          print("Updated friendListPending length: ${friendListPending.length}");

          acceptedFriends.clear();
          isLoading = false;
        },
        onError: (error){
          isLoading = false;
          print("loi o friend requests $error");
        }
    );
  }

  ///
  /// List check friend accepted
  ///
  @action
  void markFriendAccepted(String friendId) {
    acceptedFriends[friendId] = true;
    print("Marked friend $friendId as accepted");
  }

  ///
  /// Kiểm tra xem friend đã được chấp nhận chưa
  ///
  bool isFriendAccepted(String friendId) {
    return acceptedFriends[friendId] == true;
  }

  ///
  /// Reset accepted friends status
  ///
  @action
  void resetAcceptedFriends() {
    acceptedFriends.clear();
    print("Reset all accepted friends status");
  }

  ///
  /// Remove accept friend
  ///
  @action
  void removeAcceptedFriend(String friendId) {
    acceptedFriends.remove(friendId);
    print("Removed friend $friendId from accepted list");
  }

  ///
  /// Get All Friends Requests
  ///
  Future<void> acceptFriendRequest({
    required String userId,
    required Function() onSuccess,
    required Function(dynamic error) onError
  }) async {
    isLoading = true;

    await _friendRepository.acceptFriendRequest(
        userId: userId,
        onSuccess: (data) {
          acceptFriend = data;
          print("accept: ${acceptFriend.toUser}");

          isLoading = false;
          onSuccess();
        },
        onError: (error){
          isLoading = false;
          print("loi o friend requests $error");
          onError(error);
        }
    );
  }

  ///
  /// Handle accept friend request from UI
  ///
  @action
  Future<void> handleAcceptFriendRequest(int index) async {
    if (index < listRequests.length) {
      final requestId = listRequests[index].id;
      final friendId = listRequests[index].fromUser?.id;
      
      if (requestId != null && friendId != null) {
        markFriendAccepted(friendId);
        
        await acceptFriendRequest(
          userId: friendId,
          onSuccess: () async {
            print("Friend request accepted successfully");
            await getAllFriends();
          },
          onError: (error) {
            removeAcceptedFriend(friendId);
            print("Error accepting friend request: $error");
          },
        );
      }
    }
  }


  ///
  /// Handle reject friend request from UI
  ///
  // Remove friend request from lists
  @action
  void removeFriendRequestFromLists(String requestId) {
    // Remove from listRequests
    listRequests.removeWhere((request) => request.id == requestId);

    // Force update friendListPending to trigger UI rebuild
    friendListPending = ObservableList.of(
      listRequests.map((item) => item.fromUser!).toList(),
    );
  }

  @action
  Future<void> handleRejectFriendRequest({
    required String userId,
    required String requestId,
    required BuildContext context,
    required String nameItemDetail,
  }) async {
    isLoading = true;

    await _friendRepository.rejectFriendRequest(
      userId: userId,
      onSuccess: (data) async {
        rejectFriend = data;
        print("reject: ${rejectFriend.toUser}");
        isLoading = false;

        ScaffoldMessenger.of(context).showSnackBar(
          buildSnackBarNotify(textNotify: "Successfully $nameItemDetail"),
        );

        removeFriendRequestFromLists(requestId);
        await getAllFriendsRequests();
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


  ///
  ///  Go to info friend
  ///
  @action
  Future<void> goToInfoFriend({
    required BuildContext context
  })async {
      Navigator.of(context).pushNamed(
          AuthRouters.INFO_FRIENDS,
      );

  }

  ///
  ///  Unfriend
  ///
  Future<void> unFriend({
    required String friendId,
    required Function() onSuccess,
    required Function(dynamic error) onError
  }) async {
    isLoading = true;

    await _friendRepository.unFriend(
        friendId: friendId,
        onSuccess: (data) {
          isLoading = false;
          onSuccess();
        },
        onError: (error){
          isLoading = false;
          print("loi o unfriend $error");
          onError(error);
        }
    );
  }

  ///
  /// Searching
  ///
  @action
  void getItemSearch() {
    friendListSearch.clear();
    final lowerSearch = searchCtrl.searchText.toLowerCase();
    for (final item in friendList) {
      if (item.name != null && item.name!.toLowerCase().contains(lowerSearch)) {
        friendListSearch.add(item);
      }
    }
  }


  ///
  /// Kiểm tra trạng thái đăng nhập
  ///
  @action
  Future<void> checkLoginStatus() async {
    // await ensureInitialized();
    
    final accessToken = _sharedPreferenceHelper?.getAccessToken;
    final refreshToken = _sharedPreferenceHelper?.getRefreshToken;
    final email = _sharedPreferenceHelper?.getEmail;
  }
}