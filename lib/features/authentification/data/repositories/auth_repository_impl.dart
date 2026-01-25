import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, User>> register({
    required String fullName,
    required String phone,
    required String password,
    String? email,
    String? role,
  }) async {
    try {
      final authResponse = await remoteDataSource.register(
        fullName: fullName,
        phone: phone,
        password: password,
        email: email,
        role: role,
      );

      // Sauvegarder le token et l'utilisateur localement
      await localDataSource.saveAuthToken(authResponse.token);
      await localDataSource.saveUser(authResponse.user);

      return Right(authResponse.user);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final authResponse = await remoteDataSource.login(
        identifier: identifier,
        password: password,
      );

      // Sauvegarder le token et l'utilisateur localement
      await localDataSource.saveAuthToken(authResponse.token);
      await localDataSource.saveUser(authResponse.user);

      return Right(authResponse.user);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // D'abord essayer de récupérer depuis le cache local
      final cachedUser = await localDataSource.getUser();
      if (cachedUser != null) {
        return Right(cachedUser);
      }

      // Si pas en cache, récupérer depuis l'API
      final user = await remoteDataSource.getMe();
      await localDataSource.saveUser(user);

      return Right(user);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(CacheFailure('Erreur de récupération du profil: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? fullName,
    String? email,
    String? location,
  }) async {
    try {
      final user = await remoteDataSource.updateProfile(
        fullName: fullName,
        email: email,
        location: location,
      );

      // Mettre à jour le cache local
      await localDataSource.saveUser(user);

      return Right(user);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur de mise à jour: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyPhone(String code) async {
    try {
      await remoteDataSource.verifyPhone(code);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur de vérification: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> resendOtp() async {
    try {
      final otp = await remoteDataSource.resendOtp();
      return Right(otp);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur d\'envoi du code: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearAll();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Erreur de déconnexion: $e'));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await localDataSource.getAuthToken();
    return token != null;
  }

  // Méthode privée pour gérer les erreurs Dio
  Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Délai de connexion dépassé');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['message'] ?? 'Erreur serveur';

        if (statusCode == 400) {
          return ValidationFailure(message);
        } else if (statusCode == 401 || statusCode == 403) {
          return AuthFailure(message);
        } else if (statusCode == 404) {
          return NotFoundFailure(message);
        } else if (statusCode != null && statusCode >= 500) {
          return ServerFailure(message);
        }
        return ServerFailure(message);

      case DioExceptionType.cancel:
        return const NetworkFailure('Requête annulée');

      case DioExceptionType.unknown:
        if (error.error.toString().contains('SocketException')) {
          return const NetworkFailure('Pas de connexion Internet');
        }
        return ServerFailure('Erreur inconnue: ${error.message}');

      default:
        return ServerFailure('Erreur réseau: ${error.message}');
    }
  }
}