import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import 'package:handoff_vdb_2025/data/repositories/user_repository.dart';
import 'package:handoff_vdb_2025/presentation/pages/friends/friends_store.dart';
import 'package:mobx/mobx.dart';
part 'dash_board_store.g.dart';

class DashBoardStore = _DashBoardStore with _$DashBoardStore;

abstract class _DashBoardStore with Store {
  /// Repository
  late final _userRepository;

  /// SharePreference
  late final _sharedPreferenceHelper;

  /// Store
  late FriendsStore friendsStore;

  @observable
  int currentIndex = 2;

  @observable
  bool isLoading = false;

  /// Accept
  @observable
  UserModel userProfile = UserModel();


  ///
  /// Init
  ///
  _DashBoardStore() {
    _init();
  }
  Future<void> _init() async {
    // Get dependencies directly
    _sharedPreferenceHelper = AppInit.instance.sharedPreferenceHelper;
    _userRepository = UserRepository();
    // TODO
    friendsStore = FriendsStore();
    friendsStore.getAllFriends();
  }


  ///
  /// Dispose
  ///
  void disposeAll() {
    friendsStore.disposeAll();
  }


  @action
  void onChangedDashboardPage({required int index}){
    if (index == currentIndex) return;
    currentIndex = index;
  }

  ///
  /// Get All Friends
  ///
  Future<void> getUserProfile() async {
    isLoading = true;

    await _userRepository.getUserProfile(
        onSuccess: (data) {
          userProfile = data;

          print(userProfile.name);
          isLoading = false;
        },
        onError: (error){
          isLoading = false;
          print("loi o all friend $error");
        }
    );
  }
}