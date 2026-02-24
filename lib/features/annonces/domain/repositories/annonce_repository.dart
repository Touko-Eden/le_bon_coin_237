
import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/annonce.dart';

abstract class AnnonceRepository {
  Future<Either<Failure, List<Annonce>>> getAnnonces();
  Future<Either<Failure, Annonce>> getAnnonceById(int id);
  Future<Either<Failure, Annonce>> createAnnonce({
    required String title,
    required String description,
    required double price,
    required String category,
    required String condition,
    required String location,
    required List<XFile> images,
  });
  Future<Either<Failure, Annonce>> updateAnnonce({
    required int id,
    String? title,
    String? description,
    double? price,
    String? category,
    String? condition,
    String? location,
    List<XFile>? images,
  });
  Future<Either<Failure, void>> deleteAnnonce(int id);
  Future<Either<Failure, List<Annonce>>> getMyAnnonces();
  Future<Either<Failure, List<Annonce>>> getFavorites();
  Future<Either<Failure, bool>> toggleFavorite(int annonceId);
}
