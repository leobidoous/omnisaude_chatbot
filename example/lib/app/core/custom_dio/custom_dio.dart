import 'package:dio/dio.dart';
import 'package:omnisaude_chatbot_example/app/core/constants/constants.dart';

import 'dio_interceptor.dart';

class CustomDio {
  final Dio dio;

  CustomDio(this.dio) {
    dio.options.baseUrl = BASE_URL + DEFAULT_API;
    dio.interceptors.add(DioInterceptors());
    dio.options.connectTimeout = CONNECT_TIMEOUT;
  }
}
