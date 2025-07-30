import 'package:dio/dio.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/data/model/friend/friend_model.dart';
import 'package:handoff_vdb_2025/data/model/friend/friend_request_model.dart';
import 'package:handoff_vdb_2025/data/model/friend/friend_sent_model.dart';
import 'package:handoff_vdb_2025/data/model/response/user_model.dart';
import 'package:handoff_vdb_2025/domain/end_points/end_point.dart';
import '../../core/helper/validate.dart';
import '../../core/shared_pref/shared_preference_helper.dart';
import '../data_source/dio/dio_client.dart';
import '../exception/api_error_handler.dart';
import '../model/base/api_response.dart';

class FriendRepository {
  final DioClient _dio = AppInit.instance.dioClient;
  final SharedPreferenceHelper _sharedPreferenceHelper = AppInit.instance.sharedPreferenceHelper;

  FriendRepository() {
    _init();
  }

  Future<void> _init() async {
  }

  ///
  /// Get all friends
  ///
  Future<void> getAllFriend ({
    required Function(List<UserModel> data) onSuccess,
    required Function(dynamic error) onError
  }) async {
    
    // Check if user is logged in
    final accessToken = _sharedPreferenceHelper.getAccessToken;
    print("accessToken o get All friend ${accessToken}");
    
    if (accessToken == null || accessToken.isEmpty) {
      onError("User not logged in");
      return;
    }

    Response<dynamic> response;
    try{
      response = await _dio.get(
        EndPoint.ALL_FRIENDS_REQUESTS,
        queryParameters: {'type': 'all'},
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
    }catch (e) {
      print("Error details: $e");
      onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
      return;
    }
    if(!Validate.nullOrEmpty(response.statusCode) && response.statusCode! >= 200 && response.statusCode! <= 300){
      final results = response.data as Map<String, dynamic>;

      final metadata = results['metadata'] as Map<String, dynamic>;
      final data = metadata['data'] as List<dynamic>;

      final List<UserModel> allFriendList = data
          .map((item) => UserModel.fromMap(item as Map<String, dynamic>))
          .toList();
      onSuccess(allFriendList);
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
    final accessToken = _sharedPreferenceHelper.getAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      onError("User not logged in");
      return;
    }

    Response<dynamic> response;
    try{
      response = await _dio.get(
        EndPoint.ALL_FRIENDS_REQUESTS,
        queryParameters: {'type': 'pending'},
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
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
  /// Get all friends suggestion
  ///
  Future<void> getAllFriendSuggestions ({
    required Function(List<UserModel> data) onSuccess,
    required Function(dynamic error) onError
  }) async {

    // Check if user is logged in
    final accessToken = _sharedPreferenceHelper.getAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      onError("User not logged in");
      return;
    }

    Response<dynamic> response;
    try{
      response = await _dio.get(
        EndPoint.ALL_FRIENDS_SUGGESTIONS,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
        queryParameters: {
          'limit': 12,
          'page': 1,
        },
      );
    }catch (e) {
      print("Error details: $e");
      onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
      return;
    }
    if(!Validate.nullOrEmpty(response.statusCode) && response.statusCode! >= 200 && response.statusCode! <= 300){
      final results = response.data as Map<String, dynamic>;

      final metadata = results['metadata'] as Map<String, dynamic>;
      final data = metadata['data'] as List<dynamic>;

      final List<UserModel> allSuggestionFriendList = data
          .map((item) => UserModel.fromMap(item as Map<String, dynamic>))
          .toList();
      onSuccess(allSuggestionFriendList);
    }
  }

  ///
  /// Get all friends requests
  ///
  Future<void> getAllFriendSent ({
    required Function(List<FriendSentModel> data) onSuccess,
    required Function(dynamic error) onError
  }) async {

    // Check if user is logged in
    final accessToken = _sharedPreferenceHelper.getAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      onError("User not logged in");
      return;
    }

    Response<dynamic> response;
    try{
      response = await _dio.get(
        EndPoint.ALL_FRIENDS_REQUESTS,
        queryParameters: {'type': 'sent'},
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );
    }catch (e) {
      print("Error details: $e");
      onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
      return;
    }
    if(!Validate.nullOrEmpty(response.statusCode) && response.statusCode! >= 200 && response.statusCode! <= 300){
      final results = response.data as Map<String, dynamic>;

      final metadata = results['metadata'] as List<dynamic>;

      final List<FriendSentModel> friendSentList = metadata
          .map((item) => FriendSentModel.fromMap(item as Map<String, dynamic>)).toList();
      onSuccess(friendSentList);
    }
  }

  // ///
  // /// Get followers
  // ///
  // Future<void> getAllFriendFollowers ({
  //   required Function(List<FriendRequestModel> data) onSuccess,
  //   required Function(dynamic error) onError
  // }) async {
  //
  //   // Check if user is logged in
  //   final accessToken = _sharedPreferenceHelper.getAccessToken;
  //   if (accessToken == null || accessToken.isEmpty) {
  //     onError("User not logged in");
  //     return;
  //   }
  //
  //   Response<dynamic> response;
  //   try{
  //     response = await _dio.get(EndPoint.ALL_FRIENDS_FOLLOWERS);
  //   }catch (e) {
  //     print("Error details: $e");
  //     onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
  //     return;
  //   }
  //   if (!Validate.nullOrEmpty(response.statusCode) &&
  //       response.statusCode! >= 200 &&
  //       response.statusCode! <= 300) {
  //     final results = response.data as Map<String, dynamic>;
  //     final metadata = results['metadata'] as Map<String, dynamic>;
  //     final followers = metadata['followers'] as List<dynamic>;
  //
  //     final List<FriendRequestModel> friendRequestList = followers
  //         .map((item) => FriendRequestModel.fromMap(item as Map<String, dynamic>))
  //         .toList();
  //
  //     onSuccess(friendRequestList);
  //   }
  // }

  ///
  /// Accept friend
  ///
  Future<void> acceptFriendRequest ({
    required String userId,
    required Function(FriendModel data) onSuccess,
    required Function(dynamic error) onError
  }) async {

    // Check if user is logged in
    final accessToken = _sharedPreferenceHelper.getAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      onError("User not logged in");
      return;
    }

    Response<dynamic> response;
    try{
      response = await _dio.post(
        EndPoint.FRIENDS_REQUESTS,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
        data: {
          'userId' : userId,
          'type' : "accept"
        }
      );
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
  /// Reject friend
  ///
  Future<void> rejectFriendRequest ({
    required String friendId,
    required Function(FriendModel data) onSuccess,
    required Function(dynamic error) onError
  }) async {

    // Check if user is logged in
    final accessToken = _sharedPreferenceHelper.getAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      onError("User not logged in");
      return;
    }

    Response<dynamic> response;
    try{
      response = await _dio.post(
        EndPoint.FRIENDS_REQUESTS,
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ),
          data: {
            'userId' : friendId,
            'type' : "reject"
          }
      );
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
  /// unfriend friend
  ///
  Future<void> unFriend ({
    required String friendId,
    required Function() onSuccess,
    required Function(dynamic error) onError
  }) async {

    // Check if user is logged in
    final accessToken = _sharedPreferenceHelper.getAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      onError("User not logged in");
      return;
    }

    Response<dynamic> response;
    try{
      response = await _dio.post(
          EndPoint.FRIENDS_REQUESTS,
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ),
          data: {
            'userId' : friendId,
            'type' : "unfriend"
          }
      );
    }catch (e) {
      print("Error details: $e");
      onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
      return;
    }
    if(!Validate.nullOrEmpty(response.statusCode) && response.statusCode! >= 200 && response.statusCode! <= 300){
      onSuccess();
    }
  }

  ///
  /// Sent friend request
  ///
  Future<void> sentFriendRequest ({
    required String friendId,
    required Function() onSuccess,
    required Function(dynamic error) onError
  }) async {

    // Check if user is logged in
    final accessToken = _sharedPreferenceHelper.getAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      onError("User not logged in");
      return;
    }

    Response<dynamic> response;
    try{
      response = await _dio.post(
          EndPoint.FRIENDS_REQUESTS,
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ),
          data: {
            'userId' : friendId,
            'type' : "send"
          }
      );
    }catch (e) {
      print("Error details: $e");
      onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
      return;
    }
    if(!Validate.nullOrEmpty(response.statusCode) && response.statusCode! >= 200 && response.statusCode! <= 300){
      onSuccess();
    }
  }

  ///
  /// Cancel friend request
  ///
  Future<void> cancelFriendRequest ({
    required String friendId,
    required Function() onSuccess,
    required Function(dynamic error) onError
  }) async {

    // Check if user is logged in
    final accessToken = _sharedPreferenceHelper.getAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      onError("User not logged in");
      return;
    }

    Response<dynamic> response;
    try{
      response = await _dio.post(
          EndPoint.FRIENDS_REQUESTS,
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ),
          data: {
            'userId' : friendId,
            'type' : "deleted"
          }
      );
    }catch (e) {
      print("Error details: $e");
      onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
      return;
    }
    if(!Validate.nullOrEmpty(response.statusCode) && response.statusCode! >= 200 && response.statusCode! <= 300){
      onSuccess();
    }
  }
}