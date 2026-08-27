import 'package:dio/dio.dart';

class Failure {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ErrorHandler {
  static Failure handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const Failure('Connection timeout, please try again.');
        case DioExceptionType.badResponse:
          final response = error.response;
          if (response != null) {
            final data = response.data;
            if (data is Map && data.containsKey('message')) {
              return Failure(data['message'].toString(), statusCode: response.statusCode);
            }
            return Failure('Server error: ${response.statusCode}', statusCode: response.statusCode);
          }
          return const Failure('An unexpected error occurred.');
        case DioExceptionType.cancel:
          return const Failure('Request was cancelled.');
        default:
          return const Failure('No internet connection.');
      }
    } else if (error is Failure) {
      return error;
    }
    return Failure(error.toString());
  }
}
