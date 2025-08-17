import 'package:dio/dio.dart';
import 'package:todo_app_flutter/helpers/secure_storage.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:3005/api',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 3),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  static void setUpInterceptor() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          var token = await SecureStorage.readToken();
          print('Token when doing request');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
        onResponse: (response, handler) => handler.next(response),
        onError: (error, handler) => handler.next(error),
      ),
    );
  }
}
