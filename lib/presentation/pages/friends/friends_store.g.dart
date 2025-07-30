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
  ObservableList<UserModel> get friendList {
    _$friendListAtom.reportRead();
    return super.friendList;
  }

  @override
  set friendList(ObservableList<UserModel> value) {
    _$friendListAtom.reportWrite(value, super.friendList, () {
      super.friendList = value;
    });
  }

  late final _$friendListPendingAtom = Atom(
    name: '_FriendsStore.friendListPending',
    context: context,
  );

  @override
  ObservableList<FriendRequestModel> get friendListPending {
    _$friendListPendingAtom.reportRead();
    return super.friendListPending;
  }

  @override
  set friendListPending(ObservableList<FriendRequestModel> value) {
    _$friendListPendingAtom.reportWrite(value, super.friendListPending, () {
      super.friendListPending = value;
    });
  }

  late final _$friendListSuggestionAtom = Atom(
    name: '_FriendsStore.friendListSuggestion',
    context: context,
  );

  @override
  ObservableList<UserModel> get friendListSuggestion {
    _$friendListSuggestionAtom.reportRead();
    return super.friendListSuggestion;
  }

  @override
  set friendListSuggestion(ObservableList<UserModel> value) {
    _$friendListSuggestionAtom.reportWrite(
      value,
      super.friendListSuggestion,
      () {
        super.friendListSuggestion = value;
      },
    );
  }

  late final _$friendListSuggestionStatusAtom = Atom(
    name: '_FriendsStore.friendListSuggestionStatus',
    context: context,
  );

  @override
  ObservableList<Map<String, dynamic>> get friendListSuggestionStatus {
    _$friendListSuggestionStatusAtom.reportRead();
    return super.friendListSuggestionStatus;
  }

  @override
  set friendListSuggestionStatus(ObservableList<Map<String, dynamic>> value) {
    _$friendListSuggestionStatusAtom.reportWrite(
      value,
      super.friendListSuggestionStatus,
      () {
        super.friendListSuggestionStatus = value;
      },
    );
  }

  late final _$friendListSentAtom = Atom(
    name: '_FriendsStore.friendListSent',
    context: context,
  );

  @override
  ObservableList<FriendSentModel> get friendListSent {
    _$friendListSentAtom.reportRead();
    return super.friendListSent;
  }

  @override
  set friendListSent(ObservableList<FriendSentModel> value) {
    _$friendListSentAtom.reportWrite(value, super.friendListSent, () {
      super.friendListSent = value;
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
  Future<void> handleAcceptFriendRequest({required String friendId}) {
    return _$handleAcceptFriendRequestAsyncAction.run(
      () => super.handleAcceptFriendRequest(friendId: friendId),
    );
  }

  late final _$handleRejectFriendRequestAsyncAction = AsyncAction(
    '_FriendsStore.handleRejectFriendRequest',
    context: context,
  );

  @override
  Future<void> handleRejectFriendRequest({
    required String friendId,
    required BuildContext context,
    required String nameItemDetail,
    required dynamic Function() onSuccess,
  }) {
    return _$handleRejectFriendRequestAsyncAction.run(
      () => super.handleRejectFriendRequest(
        friendId: friendId,
        context: context,
        nameItemDetail: nameItemDetail,
        onSuccess: onSuccess,
      ),
    );
  }

  late final _$handleSentFriendRequestAsyncAction = AsyncAction(
    '_FriendsStore.handleSentFriendRequest',
    context: context,
  );

  @override
  Future<void> handleSentFriendRequest({
    required String friendId,
    required dynamic Function() onSuccess,
  }) {
    return _$handleSentFriendRequestAsyncAction.run(
      () => super.handleSentFriendRequest(
        friendId: friendId,
        onSuccess: onSuccess,
      ),
    );
  }

  late final _$handleCancelFriendRequestAsyncAction = AsyncAction(
    '_FriendsStore.handleCancelFriendRequest',
    context: context,
  );

  @override
  Future<void> handleCancelFriendRequest({
    required String friendId,
    required dynamic Function() onSuccess,
  }) {
    return _$handleCancelFriendRequestAsyncAction.run(
      () => super.handleCancelFriendRequest(
        friendId: friendId,
        onSuccess: onSuccess,
      ),
    );
  }

  late final _$goToInfoFriendAsyncAction = AsyncAction(
    '_FriendsStore.goToInfoFriend',
    context: context,
  );

  @override
  Future<void> goToInfoFriend({
    required String friendId,
    required BuildContext context,
  }) {
    return _$goToInfoFriendAsyncAction.run(
      () => super.goToInfoFriend(friendId: friendId, context: context),
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
  void removeFriendFromAllLists(String friendId) {
    final _$actionInfo = _$_FriendsStoreActionController.startAction(
      name: '_FriendsStore.removeFriendFromAllLists',
    );
    try {
      return super.removeFriendFromAllLists(friendId);
    } finally {
      _$_FriendsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeFriendFromSuggestionIfFailed(String friendId) {
    final _$actionInfo = _$_FriendsStoreActionController.startAction(
      name: '_FriendsStore.removeFriendFromSuggestionIfFailed',
    );
    try {
      return super.removeFriendFromSuggestionIfFailed(friendId);
    } finally {
      _$_FriendsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSendStatus(String friendId) {
    final _$actionInfo = _$_FriendsStoreActionController.startAction(
      name: '_FriendsStore.setSendStatus',
    );
    try {
      return super.setSendStatus(friendId);
    } finally {
      _$_FriendsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCancelStatus(String friendId) {
    final _$actionInfo = _$_FriendsStoreActionController.startAction(
      name: '_FriendsStore.setCancelStatus',
    );
    try {
      return super.setCancelStatus(friendId);
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
friendListPending: ${friendListPending},
friendListSuggestion: ${friendListSuggestion},
friendListSuggestionStatus: ${friendListSuggestionStatus},
friendListSent: ${friendListSent},
friendListSearch: ${friendListSearch},
acceptFriend: ${acceptFriend},
rejectFriend: ${rejectFriend}
    ''';
  }
}
