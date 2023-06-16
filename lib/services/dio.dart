import 'package:dio/dio.dart';

Dio dio() {
  Dio dio = new Dio();
  // ios
  // dio.options.baseUrl = 'http://localhost:8000/api/';
  // android
  dio.options.baseUrl = '  https://5f25-200-188-1-212.ngrok-free.app/api/';

  dio.options.headers['accept'] = 'application/json';

  return dio;
}
