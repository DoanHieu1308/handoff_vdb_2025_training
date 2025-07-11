import 'package:dio/dio.dart';
import 'package:handoff_vdb_2025/data/model/friend/friend_model.dart';
import 'package:handoff_vdb_2025/data/model/friend/friend_request_model.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import 'package:handoff_vdb_2025/domain/end_points/end_point.dart';
import '../../core/helper/validate.dart';
import '../../core/shared_pref/shared_preference_helper.dart';
import '../data_source/dio/dio_client.dart';
import '../exception/api_error_handler.dart';
import '../model/base/api_response.dart';

class FriendRepository {
  late DioClient _dio;
  SharedPreferenceHelper? _sharedPreferenceHelper;

  FriendRepository() {
    _init();
  }

  Future<void> _init() async {
    _dio = DioClient();
    _sharedPreferenceHelper = SharedPreferenceHelper.instance;
  }

  ///
  /// Get all friends
  ///
  Future<void> getAllFriend ({
    required Function(List<UserModel> data) onSuccess,
    required Function(dynamic error) onError
  }) async {
    
    // Check if user is logged in
    final accessToken = _sharedPreferenceHelper?.getAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      onError("User not logged in");
      return;
    }

    Response<dynamic> response;
    try{
      response = await _dio.get(EndPoint.ALL_FRIENDS);
    }catch (e) {
      print("Error details: $e");
      onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
      return;
    }
    if(!Validate.nullOrEmpty(response.statusCode) && response.statusCode! >= 200 && response.statusCode! <= 300){
      final results = response.data as Map<String, dynamic>;

      final metadata = results['metadata'] as Map<String, dynamic>;
      final friends = metadata['friends'] as List<dynamic>;

      final List<UserModel> friendList = friends
          .map((friend) => UserModel.fromMap(friend as Map<String, dynamic>))
          .toList();
      onSuccess(friendList);
    }
  }

  ///
  /// Get all friends requests
  ///
  Future<void> getAllFriendRequests ({
    required Function(List<FriendRequestModel> data) onSuccess,
    required Function(dynamic error) onError
  }) async {

    // Check if user is logged in
    final accessToken = _sharedPreferenceHelper?.getAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      onError("User not logged in");
      return;
    }

    Response<dynamic> response;
    try{
      response = await _dio.get(EndPoint.ALL_FRIENDS_REQUESTS);
    }catch (e) {
      print("Error details: $e");
      onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
      return;
    }
    if(!Validate.nullOrEmpty(response.statusCode) && response.statusCode! >= 200 && response.statusCode! <= 300){
      final results = response.data as Map<String, dynamic>;

      final metadata = results['metadata'] as List<dynamic>;

      final List<FriendRequestModel> friendRequestList = metadata
          .map((item) => FriendRequestModel.fromMap(item as Map<String, dynamic>)).toList();
      onSuccess(friendRequestList);
    }
  }

  ///
  /// Accept friend
  ///
  Future<void> acceptFriendRequest ({
    required String requestId,
    required Function(FriendModel data) onSuccess,
    required Function(dynamic error) onError
  }) async {

    // Check if user is logged in
    final accessToken = _sharedPreferenceHelper?.getAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      onError("User not logged in");
      return;
    }

    Response<dynamic> response;
    try{
      response = await _dio.post("${EndPoint.ACCEPT_FRIENDS_REQUESTS}/$requestId");
    }catch (e) {
      print("Error details: $e");
      onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
      return;
    }
    if(!Validate.nullOrEmpty(response.statusCode) && response.statusCode! >= 200 && response.statusCode! <= 300){
      final results = response.data as Map<String, dynamic>;
      final metadata = results['metadata'] as Map<String, dynamic>;
      
      final FriendModel friend = FriendModel.fromMap(metadata);
      onSuccess(friend);
    }
  }

  ///
  /// Accept friend
  ///
  Future<void> rejectFriendRequest ({
    required String requestId,
    required Function(FriendModel data) onSuccess,
    required Function(dynamic error) onError
  }) async {

    // Check if user is logged in
    final accessToken = _sharedPreferenceHelper?.getAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      onError("User not logged in");
      return;
    }

    Response<dynamic> response;
    try{
      response = await _dio.post("${EndPoint.REJECT_FRIENDS_REQUESTS}/$requestId");
    }catch (e) {
      print("Error details: $e");
      onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
      return;
    }
    if(!Validate.nullOrEmpty(response.statusCode) && response.statusCode! >= 200 && response.statusCode! <= 300){
      final results = response.data as Map<String, dynamic>;
      final metadata = results['metadata'] as Map<String, dynamic>;

      final FriendModel friend = FriendModel.fromMap(metadata);
      onSuccess(friend);
    }
  }
}