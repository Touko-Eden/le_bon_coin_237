
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
}
