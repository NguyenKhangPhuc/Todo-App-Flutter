import 'package:dio/dio.dart';
import 'package:todo_app_flutter/api/dio_client.dart';
import 'package:todo_app_flutter/models/user.dart';

class UserService {
  final Dio _dio = DioClient.dio;

  Future<String> login(User user) async {
    try {
      final response = await _dio.post('/user/login', data: user.toJson());
      print(response.data);
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final errorData = e.response?.data;

        if (statusCode == 401) {
          throw Exception(errorData['error'] ?? 'Invalid credentials');
        } else {
          throw Exception(errorData['error'] ?? 'Something went wrong');
        }
      } else {
        throw Exception("Network error: ${e.message}");
      }
    }
  }

  Future<String> signUp(User user) async {
    try {
      final response = await _dio.post('/user/signup', data: user.toJson());
      String message = response.data['mssg'];
      return message;
    } on DioException catch (e) {
      if (e.response != null) {
        final statusCode = e.response?.statusCode;
        final errorData = e.response?.data;

        if (statusCode == 401) {
          throw Exception(errorData['error'] ?? 'Invalid credentials');
        } else {
          throw Exception(errorData['error'] ?? 'Something went wrong');
        }
      } else {
        throw Exception("Network error: ${e.message}");
      }
    }
  }
}
