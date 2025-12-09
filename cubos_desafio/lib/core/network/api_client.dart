import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Authorization': 'Bearer ${ApiConstants.bearerToken}',
          'accept': 'application/json',
        },
        queryParameters: {'language': ApiConstants.language},
      ),
    );

    // LogInterceptor APENAS em debug mode (performance)
    if (kDebugMode) {
      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          logPrint: (obj) => print(obj),
        ),
      );
    }
  }

  Dio get dio => _dio;
}
