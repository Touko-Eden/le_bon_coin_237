import 'package:dartz/dartz.dart';
import 'package:secondmain_237/core/errors/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> register({
    required String fullName,
    required String phone,
    required String password,
    String? email,
    String? role,
  });

  Future<Either<Failure, User>> login({
    required String identifier,
    required String password,
  });

  Future<Either<Failure, User>> getCurrentUser();

  Future<Either<Failure, User>> updateProfile({
    String? fullName,
    String? email,
    String? location,
  });

  Future<Either<Failure, void>> verifyPhone(String code);

  Future<Either<Failure, String>> resendOtp();

  Future<Either<Failure, void>> logout();

  Future<bool> isLoggedIn();
}