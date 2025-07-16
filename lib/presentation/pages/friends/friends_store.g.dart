// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friends_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FriendsStore on _FriendsStore, Store {
  late final _$selectedCategoryNameAtom = Atom(
    name: '_FriendsStore.selectedCategoryName',
    context: context,
  );

  @override
  String get selectedCategoryName {
    _$selectedCategoryNameAtom.reportRead();
    return super.selectedCategoryName;
  }

  @override
  set selectedCategoryName(String value) {
    _$selectedCategoryNameAtom.reportWrite(
      value,
      super.selectedCategoryName,
      () {
        super.selectedCategoryName = value;
      },
    );
  }

  late final _$isLoadingAtom = Atom(
    name: '_FriendsStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$friendListAtom = Atom(
    name: '_FriendsStore.friendList',
    context: context,
  );

  @override
  List<UserModel> get friendList {
    _$friendListAtom.reportRead();
    return super.friendList;
  }

  @override
  set friendList(List<UserModel> value) {
    _$friendListAtom.reportWrite(value, super.friendList, () {
      super.friendList = value;
    });
  }

  late final _$listRequestsAtom = Atom(
    name: '_FriendsStore.listRequests',
    context: context,
  );

  @override
  List<FriendRequestModel> get listRequests {
    _$listRequestsAtom.reportRead();
    return super.listRequests;
  }

  @override
  set listRequests(List<FriendRequestModel> value) {
    _$listRequestsAtom.reportWrite(value, super.listRequests, () {
      super.listRequests = value;
    });
  }

  late final _$friendListPendingAtom = Atom(
    name: '_FriendsStore.friendListPending',
    context: context,
  );

  @override
  List<UserModel> get friendListPending {
    _$friendListPendingAtom.reportRead();
    return super.friendListPending;
  }

  @override
  set friendListPending(List<UserModel> value) {
    _$friendListPendingAtom.reportWrite(value, super.friendListPending, () {
      super.friendListPending = value;
    });
  }

  late final _$friendListSuggestionAtom = Atom(
    name: '_FriendsStore.friendListSuggestion',
    context: context,
  );

  @override
  List<UserModel> get friendListSuggestion {
    _$friendListSuggestionAtom.reportRead();
    return super.friendListSuggestion;
  }

  @override
  set friendListSuggestion(List<UserModel> value) {
    _$friendListSuggestionAtom.reportWrite(
      value,
      super.friendListSuggestion,
      () {
        super.friendListSuggestion = value;
      },
    );
  }

  late final _$friendListFollowerAtom = Atom(
    name: '_FriendsStore.friendListFollower',
    context: context,
  );

  @override
  List<UserModel> get friendListFollower {
    _$friendListFollowerAtom.reportRead();
    return super.friendListFollower;
  }

  @override
  set friendListFollower(List<UserModel> value) {
    _$friendListFollowerAtom.reportWrite(value, super.friendListFollower, () {
      super.friendListFollower = value;
    });
  }

  late final _$friendListSearchAtom = Atom(
    name: '_FriendsStore.friendListSearch',
    context: context,
  );

  @override
  List<UserModel> get friendListSearch {
    _$friendListSearchAtom.reportRead();
    return super.friendListSearch;
  }

  @override
  set friendListSearch(List<UserModel> value) {
    _$friendListSearchAtom.reportWrite(value, super.friendListSearch, () {
      super.friendListSearch = value;
    });
  }

  late final _$acceptFriendAtom = Atom(
    name: '_FriendsStore.acceptFriend',
    context: context,
  );

  @override
  FriendModel get acceptFriend {
    _$acceptFriendAtom.reportRead();
    return super.acceptFriend;
  }

  @override
  set acceptFriend(FriendModel value) {
    _$acceptFriendAtom.reportWrite(value, super.acceptFriend, () {
      super.acceptFriend = value;
    });
  }

  late final _$acceptedFriendsAtom = Atom(
    name: '_FriendsStore.acceptedFriends',
    context: context,
  );

  @override
  ObservableMap<String, bool> get acceptedFriends {
    _$acceptedFriendsAtom.reportRead();
    return super.acceptedFriends;
  }

  @override
  set acceptedFriends(ObservableMap<String, bool> value) {
    _$acceptedFriendsAtom.reportWrite(value, super.acceptedFriends, () {
      super.acceptedFriends = value;
    });
  }

  late final _$rejectFriendAtom = Atom(
    name: '_FriendsStore.rejectFriend',
    context: context,
  );

  @override
  FriendModel get rejectFriend {
    _$rejectFriendAtom.reportRead();
    return super.rejectFriend;
  }

  @override
  set rejectFriend(FriendModel value) {
    _$rejectFriendAtom.reportWrite(value, super.rejectFriend, () {
      super.rejectFriend = value;
    });
  }

  late final _$getDataFriendAsyncAction = AsyncAction(
    '_FriendsStore.getDataFriend',
    context: context,
  );

  @override
  Future<void> getDataFriend(String name) {
    return _$getDataFriendAsyncAction.run(() => super.getDataFriend(name));
  }

  late final _$handleAcceptFriendRequestAsyncAction = AsyncAction(
    '_FriendsStore.handleAcceptFriendRequest',
    context: context,
  );

  @override
  Future<void> handleAcceptFriendRequest(int index) {
    return _$handleAcceptFriendRequestAsyncAction.run(
      () => super.handleAcceptFriendRequest(index),
    );
  }

  late final _$handleRejectFriendRequestAsyncAction = AsyncAction(
    '_FriendsStore.handleRejectFriendRequest',
    context: context,
  );

  @override
  Future<void> handleRejectFriendRequest({
    required String userId,
    required String requestId,
    required BuildContext context,
    required String nameItemDetail,
  }) {
    return _$handleRejectFriendRequestAsyncAction.run(
      () => super.handleRejectFriendRequest(
        userId: userId,
        requestId: requestId,
        context: context,
        nameItemDetail: nameItemDetail,
      ),
    );
  }

  late final _$goToInfoFriendAsyncAction = AsyncAction(
    '_FriendsStore.goToInfoFriend',
    context: context,
  );

  @override
  Future<void> goToInfoFriend({required BuildContext context}) {
    return _$goToInfoFriendAsyncAction.run(
      () => super.goToInfoFriend(context: context),
    );
  }

  late final _$checkLoginStatusAsyncAction = AsyncAction(
    '_FriendsStore.checkLoginStatus',
    context: context,
  );

  @override
  Future<void> checkLoginStatus() {
    return _$checkLoginStatusAsyncAction.run(() => super.checkLoginStatus());
  }

  late final _$_FriendsStoreActionController = ActionController(
    name: '_FriendsStore',
    context: context,
  );

  @override
  void setSelectedCategory(String name) {
    final _$actionInfo = _$_FriendsStoreActionController.startAction(
      name: '_FriendsStore.setSelectedCategory',
    );
    try {
      return super.setSelectedCategory(name);
    } finally {
      _$_FriendsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void markFriendAccepted(String friendId) {
    final _$actionInfo = _$_FriendsStoreActionController.startAction(
      name: '_FriendsStore.markFriendAccepted',
    );
    try {
      return super.markFriendAccepted(friendId);
    } finally {
      _$_FriendsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetAcceptedFriends() {
    final _$actionInfo = _$_FriendsStoreActionController.startAction(
      name: '_FriendsStore.resetAcceptedFriends',
    );
    try {
      return super.resetAcceptedFriends();
    } finally {
      _$_FriendsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeAcceptedFriend(String friendId) {
    final _$actionInfo = _$_FriendsStoreActionController.startAction(
      name: '_FriendsStore.removeAcceptedFriend',
    );
    try {
      return super.removeAcceptedFriend(friendId);
    } finally {
      _$_FriendsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeFriendRequestFromLists(String requestId) {
    final _$actionInfo = _$_FriendsStoreActionController.startAction(
      name: '_FriendsStore.removeFriendRequestFromLists',
    );
    try {
      return super.removeFriendRequestFromLists(requestId);
    } finally {
      _$_FriendsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getItemSearch() {
    final _$actionInfo = _$_FriendsStoreActionController.startAction(
      name: '_FriendsStore.getItemSearch',
    );
    try {
      return super.getItemSearch();
    } finally {
      _$_FriendsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedCategoryName: ${selectedCategoryName},
isLoading: ${isLoading},
friendList: ${friendList},
listRequests: ${listRequests},
friendListPending: ${friendListPending},
friendListSuggestion: ${friendListSuggestion},
friendListFollower: ${friendListFollower},
friendListSearch: ${friendListSearch},
acceptFriend: ${acceptFriend},
acceptedFriends: ${acceptedFriends},
rejectFriend: ${rejectFriend}
    ''';
  }
}
