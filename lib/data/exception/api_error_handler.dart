import 'package:dio/dio.dart';
import '../model/base/error_response.dart';

mixin ApiErrorHandler {
  static dynamic getMessage(dynamic error) {
    dynamic errorDescription = '';
    if (error is Exception) {
      try {
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              errorDescription = 'Request to API server was cancelled';
              break;
            case DioExceptionType.connectionTimeout:
              errorDescription = 'Connection timeout with API server';
              break;
            case DioExceptionType.unknown:
              errorDescription = 'Connection to API server failed due to internet connection';
              break;
            case DioExceptionType.receiveTimeout:
              errorDescription = 'Receive timeout in connection with API server';
              break;
            case DioExceptionType.badResponse:
              switch (error.response!.statusCode) {
                case 400:
                  final ErrorResponse errors = ErrorResponse.fromJson(error.response!.data);
                  errorDescription = errors.errors.isNotEmpty 
                      ? errors.errors[0].detail.toString()
                      : 'Bad Request';
                  break;
                case 404:
                  final ErrorResponse errors = ErrorResponse.fromJson(error.response!.data);
                  errorDescription = errors.errors.isNotEmpty 
                      ? errors.errors[0].detail.toString()
                      : 'Not Found';
                  break;
                case 409:
                  final ErrorResponse errors = ErrorResponse.fromJson(error.response!.data);
                  errorDescription = errors.errors.isNotEmpty 
                      ? errors.errors[0].detail.toString()
                      : 'Conflict';
                  break;
                case 413:
                  final ErrorResponse errors = ErrorResponse.fromJson(error.response!.data);
                  errorDescription = errors.errors.isNotEmpty 
                      ? errors.errors[0].detail.toString()
                      : 'Payload Too Large';
                  break;
                case 500:
                  final ErrorResponse errors = ErrorResponse.fromJson(error.response!.data);
                  errorDescription = errors.errors.isNotEmpty 
                      ? errors.errors[0].detail.toString()
                      : 'Internal Server Error';
                  break;
                case 503:
                  final ErrorResponse errors = ErrorResponse.fromJson(error.response!.data);
                  errorDescription = errors.errors.isNotEmpty 
                      ? errors.errors[0].detail.toString()
                      : 'Service Unavailable';
                  break;

                default:
                  final Errors errors = Errors.fromJson(error.response!.data);
                  if (errors.message != '') {
                    errorDescription = errors.message;
                  } else {
                    errorDescription = 'Failed to load data - status code: ${error.response!.statusCode}';
                  }
              }
              break;
            case DioExceptionType.sendTimeout:
              errorDescription = 'Send timeout with server';
              break;

            case DioExceptionType.badCertificate:
              errorDescription = 'Connection to API server failed due to internet connection bad Certificate';
              break;

            case DioExceptionType.connectionError:
              errorDescription = 'Connection to API server failed';
              break;
          }
        } else {
          errorDescription = 'Unexpected error occurred';
        }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      }
    } else if (error is String) {
      errorDescription = error;
    } else {
      errorDescription = error.toString();
    }

    // TODO: Edit alert.error
    // show errors
    // Get.snackbar(
    //   "Hey i'm a Errors SnackBar!", // title
    //   errorDescription.toString(), // message
    //   icon: const Icon(Icons.error_outline),
    //   backgroundColor: ColorResources.PINK,
    //   shouldIconPulse: true,
    //   isDismissible: true,
    //   duration: const Duration(seconds: 3),
    // );
    return errorDescription;
  }
}
