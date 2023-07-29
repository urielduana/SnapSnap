import 'package:dio/dio.dart';

Dio dio() {
  Dio dio = new Dio();
  // ios
  // dio.options.baseUrl = 'http://localhost:8000/api/';
  // android
  dio.options.baseUrl = 'http://18.118.200.206:8000/api/';

  dio.options.headers['accept'] = 'application/json';

  return dio;
}
