
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/annonce.dart';
import '../../domain/repositories/annonce_repository.dart';
import '../datasources/annonce_remote_datasource.dart';

class AnnonceRepositoryImpl implements AnnonceRepository {
  final AnnonceRemoteDataSource remoteDataSource;

  AnnonceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Annonce>>> getAnnonces() async {
    try {
      final annonces = await remoteDataSource.getAnnonces();
      return Right(annonces);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, Annonce>> getAnnonceById(int id) async {
    try {
      final annonce = await remoteDataSource.getAnnonceById(id);
      return Right(annonce);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: $e'));
    }
  }

  @override
  Future<Either<Failure, Annonce>> createAnnonce({
    required String title,
    required String description,
    required double price,
    required String category,
    required String condition,
    required String location,
    required List<XFile> images,
  }) async {
    try {
      final annonce = await remoteDataSource.createAnnonce(
        title: title,
        description: description,
        price: price,
        category: category,
        condition: condition,
        location: location,
        images: images,
      );
      return Right(annonce);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure('Erreur inattendue: $e'));
    }
  }

  Failure _handleDioError(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const NetworkFailure('Délai de connexion dépassé');
    }

    final message = error.response?.data['message'] ?? 'Erreur serveur';
    return ServerFailure(message);
  }
}
