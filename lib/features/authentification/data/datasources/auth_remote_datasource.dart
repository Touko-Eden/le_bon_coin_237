import 'package:dio/dio.dart';
import 'package:secondmain_237/core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> register({
    required String fullName,
    required String phone,
    required String password,
    String? email,
    String? role,
  });

  Future<AuthResponse> login({
    required String identifier,
    required String password,
  });

  Future<UserModel> getMe();

  Future<UserModel> updateProfile({
    String? fullName,
    String? email,
    String? location,
  });

  Future<void> verifyPhone(String code);

  Future<String> resendOtp();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<AuthResponse> register({
    required String fullName,
    required String phone,
    required String password,
    String? email,
    String? role,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.register,
        data: {
          'fullName': fullName,
          'phone': phone,
          'password': password,
          if (email != null) 'email': email,
          if (role != null) 'role': role,
        },
      );

      if (response.data['success'] == true) {
        return AuthResponse.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Erreur d\'inscription',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<AuthResponse> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final response = await dioClient.post(
        ApiConstants.login,
        data: {
          'identifier': identifier,
          'password': password,
        },
      );

      if (response.data['success'] == true) {
        return AuthResponse.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Erreur de connexion',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<UserModel> getMe() async {
    try {
      final response = await dioClient.get(ApiConstants.getMe);

      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Erreur de récupération du profil',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<UserModel> updateProfile({
    String? fullName,
    String? email,
    String? location,
  }) async {
    try {
      final response = await dioClient.put(
        ApiConstants.updateProfile,
        data: {
          if (fullName != null) 'fullName': fullName,
          if (email != null) 'email': email,
          if (location != null) 'location': location,
        },
      );

      if (response.data['success'] == true) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Erreur de mise à jour du profil',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> verifyPhone(String code) async {
    try {
      final response = await dioClient.post(
        ApiConstants.verifyPhone,
        data: {'code': code},
      );

      if (response.data['success'] != true) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Erreur de vérification',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<String> resendOtp() async {
    try {
      final response = await dioClient.post(ApiConstants.resendOtp);

      if (response.data['success'] == true) {
        // En développement, le backend peut retourner l'OTP
        return response.data['otp']?.toString() ?? '';
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Erreur d\'envoi du code',
        );
      }
    } on DioException {
      rethrow;
    }
  }
}