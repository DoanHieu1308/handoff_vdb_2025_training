import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:handoff_vdb_2025/core/helper/validate.dart';
import 'package:handoff_vdb_2025/core/init/app_init.dart';
import 'package:handoff_vdb_2025/core/shared_pref/shared_preference_helper.dart';
import 'package:handoff_vdb_2025/data/data_source/dio/dio_client.dart';
import 'package:handoff_vdb_2025/data/exception/api_error_handler.dart';
import 'package:handoff_vdb_2025/data/model/base/api_response.dart';
import 'package:handoff_vdb_2025/data/model/post/post_link_meta.dart';
import 'package:handoff_vdb_2025/data/model/post/post_input_model.dart';
import 'package:handoff_vdb_2025/data/model/post/post_output_model.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as path;

import '../../domain/end_points/end_point.dart';
import '../model/post/post_comment_model.dart';
import '../model/post/post_list_response_model.dart';

class PostRepository {
  final DioClient _dio = AppInit.instance.dioClient;
  late SharedPreferenceHelper _sharedPreferenceHelper;

  PostRepository() {
    _init();
  }

  Future<void> _init() async {
    _sharedPreferenceHelper = AppInit.instance.sharedPreferenceHelper;
  }

  ///
  /// Preview link
  ///
  Future<void> previewLink ({
    required String url,
    required Function(PostLinkMeta data) onSuccess,
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
          EndPoint.PREVIEW_LINK,
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ),
          data: {
            'url' : url,
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

      final PostLinkMeta data = PostLinkMeta.fromMap(metadata);
      onSuccess(data);
    }
  }

  ///
  /// Post status
  ///
  Future<void> createPost({
    required PostInputModel data,
    required void Function() onSuccess,
    required void Function(dynamic error) onError,
  }) async {
    final accessToken = _sharedPreferenceHelper.getAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      onError("User not logged in");
      return;
    }

    Response<dynamic> response;
    try {
      final payload = <String, dynamic>{};

      payload['title'] = data.title ?? "";
      payload['content'] = data.content ?? "";
      payload['privacy'] = data.privacy ?? "";

      payload['hashtags'] = data.hashtags ?? [];
      payload['friends_tagged'] = data.friends_tagged ?? [];
      payload['images'] = data.images ?? [];
      payload['videos'] = data.videos ?? [];

      if (data.postLinkMeta != null) {
        payload['post_link_meta'] = data.postLinkMeta!.toMap();
      }

      response = await _dio.post(
        EndPoint.POST_CREATE,
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
        data: payload,
      );
    } catch (e) {
      print("Error details: $e");
      onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
      return;
    }

    if(!Validate.nullOrEmpty(response.statusCode) && response.statusCode! >= 200 && response.statusCode! <= 300){
      onSuccess();
    }else {
      final message = response.data != null ? ApiErrorHandler.getMessage(response.data) : 'Request failed with status ${response.statusCode}';
      onError(ApiResponse.withError(message).error);
    }
  }

  /// Get list Post By userID
  Future<void> getPostsByUserId({
    required String userId,
    required int page,
    required void Function(PostListResponseModel data) onSuccess,
    required void Function(dynamic error) onError,
  }) async {
    final accessToken = _sharedPreferenceHelper.getAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      onError("User not logged in");
      return;
    }
    
    print("acces: $accessToken");

    try {
      final response = await _dio.get(
        "${EndPoint.POSTS}/user",
        queryParameters: {
          'userId': userId,
          'limit' : 10,
          'page': page,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        final results = response.data as Map<String, dynamic>;

        final PostListResponseModel postList = PostListResponseModel.fromMap(results);

        onSuccess(postList);
      } else {
        final message = ApiErrorHandler.getMessage(response.data);
        onError(ApiResponse.withError(message).error);
      }
    } catch (e) {
      print("Get Posts Error: $e");
      onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
    }
  }

  /// Get list Post By userID
  Future<void> getAllPosts({
    required int page,
    required int limit,
    required String type,
    required void Function(PostListResponseModel data) onSuccess,
    required void Function(dynamic error) onError,
  }) async {
    final accessToken = _sharedPreferenceHelper.getAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      onError("User not logged in");
      return;
    }

    print("acces: $accessToken");

    try {
      final response = await _dio.get(
        EndPoint.POSTS,
        queryParameters: {
          'page': page,
          'limit' : limit,
          'type' : type
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        final results = response.data as Map<String, dynamic>;

        final PostListResponseModel postList = PostListResponseModel.fromMap(results);
        onSuccess(postList);
      } else {
        final message = ApiErrorHandler.getMessage(response.data);
        onError(ApiResponse.withError(message).error);
      }
    } catch (e) {
      print("Get Posts Error: $e");
      onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
    }
  }

  /// Upload file multipart
  Future<void> uploadFileMultipart({
    required File file,
    required void Function(String finalUrl) onSuccess,
    required void Function(dynamic error) onError,
  }) async {
    final accessToken = _sharedPreferenceHelper.getAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      onError("User not logged in");
      return;
    }

    final filePath = file.path;
    final fileName = path.basename(filePath);
    final contentTypeString = lookupMimeType(filePath) ?? 'application/octet-stream';

    final mediaTypeParts = contentTypeString.split('/');
    final mediaType = MediaType(mediaTypeParts[0], mediaTypeParts[1]);

    // Bước 1: Tạo multipart upload
    final createRes = await _dio.post(
      "${EndPoint.UPLOAD}/create-multipart",
      data: jsonEncode({
        "fileName": fileName,
        "contentType": contentTypeString,
      }),
    );

    if (createRes.statusCode! < 200 && createRes.statusCode! >= 300) {
      throw Exception('Failed to create multipart upload');
    }

    final createData = createRes.data;
    final uploadId = createData['uploadId'];
    final key = createData['key'];

    // Bước 2: Lấy presigned URL
    final encodedKey = Uri.encodeComponent(key);
    final presignedUrlRes = await _dio.get(
      "${EndPoint.UPLOAD}/presigned-url?uploadId=$uploadId&key=$encodedKey&partNumber=1",
    );

    if (presignedUrlRes.statusCode! < 200 && presignedUrlRes.statusCode! >= 300) {
      throw Exception('Failed to get presigned URL');
    }

    final presignedUrl = presignedUrlRes.data['url'];

    // Bước 3: Gửi file đến presigned URL qua backend
    final formData = FormData.fromMap({
      'presignedUrl': presignedUrl,
      'partNumber': '1',
      'file': await MultipartFile.fromFile(
        filePath,
        filename: fileName,
        contentType: mediaType,
      ),
    });

    final uploadPartRes = await _dio.post(
      '${EndPoint.UPLOAD}/upload-part',
      data: formData,
    );

    if (uploadPartRes.statusCode! < 200 && uploadPartRes.statusCode! >= 300) {
      throw Exception('Failed to upload part');
    }

    final partData = uploadPartRes.data;
    final eTag = partData['ETag'];
    final partNumber = partData['PartNumber'];

    // Bước 4: Gửi yêu cầu hoàn tất multipart
    final completeRes = await _dio.post(
      "${EndPoint.UPLOAD}/complete-multipart",
      data: jsonEncode({
        "key": key,
        "uploadId": uploadId,
        "parts": [
          {
            "ETag": eTag,
            "PartNumber": partNumber,
          }
        ]
      }),
    );

    if (completeRes.statusCode! < 200 && completeRes.statusCode! >= 300) {
      throw Exception('Failed to complete multipart upload');
    }

    final finalUrl = completeRes.data['location'];
    
    print("finalUrl: $finalUrl");
    onSuccess(finalUrl);
  }

  /// Add feel icon
  Future<void> addFeelIcon ({
    required String postId,
    required String iconName,
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
          EndPoint.FEEL,
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ),
          data: {
            "postId" : postId,
            'type' : iconName,
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

  /// Get list Post By userID
  Future<void> getPostById({
    required String postId,
    required void Function(PostOutputModel data) onSuccess,
    required void Function(dynamic error) onError,
  }) async {
    final accessToken = _sharedPreferenceHelper.getAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      onError("User not logged in");
      return;
    }

    print("acces: $accessToken");

    try {
      final response = await _dio.get(
        "${EndPoint.POSTS}/$postId",
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      final statusCode = response.statusCode ?? 0;

      if (statusCode >= 200 && statusCode < 300) {
        final results = response.data as Map<String, dynamic>;
        final metadata = results['metadata'] as Map<String, dynamic>;

        final PostOutputModel post = PostOutputModel.fromMap(metadata);
        onSuccess(post);
      } else {
        final message = ApiErrorHandler.getMessage(response.data);
        onError(ApiResponse.withError(message).error);
      }
    } catch (e) {
      print("Get Posts Error: $e");
      onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
    }
  }


  /// Delete post
  Future<void> deletePost({
    required String postId,
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
      response = await _dio.delete(
          "${EndPoint.POSTS}/$postId",
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
      onSuccess();
    }
  }


  ///
  /// Post status
  ///
  Future<void> editPostStatus({
    required PostOutputModel data,
    required void Function(PostOutputModel data) onSuccess,
    required void Function(dynamic error) onError,
  }) async {
    final accessToken = _sharedPreferenceHelper.getAccessToken;
    if (accessToken == null || accessToken.isEmpty) {
      onError("User not logged in");
      return;
    }

    Response<dynamic> response;
    try {
      final payload = <String, dynamic>{};
      if (!Validate.nullOrEmpty(data.title)) payload['title'] = data.title;
      if (!Validate.nullOrEmpty(data.content)) payload['content'] = "ahihi";
      if (!Validate.nullOrEmpty(data.privacy)) payload['privacy'] = data.privacy;
      if (data.hashtags != null && data.hashtags!.isNotEmpty) payload['hashtags'] = data.hashtags;
      if (data.images != null && data.images!.isNotEmpty) payload['images'] = data.images;
      if (data.videos != null && data.videos!.isNotEmpty) payload['videos'] = data.videos;
      if (data.postLinkMeta != null) payload['post_link_meta'] = data.postLinkMeta!.toMap();
      payload['friends_tagged'] = data.friendsTagged
          ?.map((f) => f.id?.trim())
          .whereType<String>()
          .where((id) => id.isNotEmpty)
          .toList() ??
          [];

      response = await _dio.patch(
        "${EndPoint.POSTS}/${data.id}",
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
        data: payload,
      );
    } catch (e) {
      print("Error details: $e");
      onError(ApiResponse.withError(ApiErrorHandler.getMessage(e)).error);
      return;
    }

    if(!Validate.nullOrEmpty(response.statusCode) && response.statusCode! >= 200 && response.statusCode! <= 300){
      final results = response.data;
      print("PostItem response: $results"); // Debug log

      if (results is Map<String, dynamic>) {
        try {
          final post = PostOutputModel.fromMap(results);
          onSuccess(post);
        } catch (e) {
          print("Error parsing PostOutputModel: $e");
          print("Response data: $results");
          onError("Failed to parse post response: $e");
        }
      } else {
        print("Unexpected response format: ${results.runtimeType}");
        onError("Unexpected response format");
      }
    }else {
      final message = response.data != null ? ApiErrorHandler.getMessage(response.data) : 'Request failed with status ${response.statusCode}';
      onError(ApiResponse.withError(message).error);
    }
  }

  /// Create comment post
  Future<void> createCommentPost ({
    required String commentPostId,
    required String commentUserId,
    required String commentContent,
    required String commentParentId,
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
          "${EndPoint.COMMENT}/create",
          options: Options(
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ),
          data: {
            'commentPostId' : commentPostId,
            'commentUserId' : commentUserId,
            'commentContent' : commentContent,
            'commentParentId' : commentParentId,
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

  /// Get comment by postId
  Future<void> getCommentByPostId ({
    required String commentPostId,
    required int page,
    required Function(List<PostCommentModel>) onSuccess,
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
        "${EndPoint.COMMENT}/$commentPostId",
        queryParameters: {
          'page': page,
          'limit' : 10,
        },
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
      final commentList = data
          .map((json) => PostCommentModel.fromJson(json as Map<String, dynamic>))
          .toList();
      print(commentList);
      onSuccess(commentList);
    }
  }



  /// Delete comment
  Future<void> deleteComment({
    required String commentId,
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
        "${EndPoint.COMMENT}/delete",
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
        data: {
          "commentId" : commentId
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