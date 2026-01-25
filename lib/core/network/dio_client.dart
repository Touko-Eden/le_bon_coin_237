import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:secondmain_237/core/constants/api_constants.dart';

class DioClient {
  late final Dio _dio;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': ApiConstants.contentType,
          'Accept': ApiConstants.contentType,
        },
      ),
    );

    // Ajouter les intercepteurs
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Ajouter le token d'authentification si disponible
          final token = await _storage.read(key: 'auth_token');
          if (token != null) {
            options.headers[ApiConstants.authorization] =
            '${ApiConstants.bearer} $token';
          }

          // Log pour le debug
          print('🚀 REQUEST[${options.method}] => ${options.uri}');
          print('Headers: ${options.headers}');
          print('Data: ${options.data}');

          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log pour le debug
          print('✅ RESPONSE[${response.statusCode}] => ${response.requestOptions.uri}');
          print('Data: ${response.data}');

          return handler.next(response);
        },
        onError: (error, handler) async {
          // Log pour le debug
          print('❌ ERROR[${error.response?.statusCode}] => ${error.requestOptions.uri}');
          print('Error: ${error.message}');
          print('Response: ${error.response?.data}');

          // Gérer le token expiré
          if (error.response?.statusCode == 401) {
            await _storage.delete(key: 'auth_token');
            await _storage.delete(key: 'user_data');
          }

          return handler.next(error);
        },
      ),
    );
  }

  // Getter pour accéder au Dio instance
  Dio get dio => _dio;

  // Méthode GET
  Future<Response> get(
      String path, {
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  // Méthode POST
  Future<Response> post(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  // Méthode PUT
  Future<Response> put(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }

  // Méthode DELETE
  Future<Response> delete(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
      }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException {
      rethrow;
    }
  }
}