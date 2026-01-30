
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/dio_client.dart';
import '../models/annonce_model.dart';

abstract class AnnonceRemoteDataSource {
  Future<List<AnnonceModel>> getAnnonces();
  Future<AnnonceModel> getAnnonceById(int id);
  Future<AnnonceModel> createAnnonce({
    required String title,
    required String description,
    required double price,
    required String category,
    required String condition,
    required String location,
    required List<XFile> images,
  });
}

class AnnonceRemoteDataSourceImpl implements AnnonceRemoteDataSource {
  final DioClient dioClient;

  AnnonceRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<AnnonceModel>> getAnnonces() async {
    try {
      final response = await dioClient.get(ApiConstants.annonces);
      
      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((e) => AnnonceModel.fromJson(e)).toList();
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Erreur de chargement',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<AnnonceModel> getAnnonceById(int id) async {
    try {
      final response = await dioClient.get(ApiConstants.annonceById(id));

      if (response.data['success'] == true) {
        return AnnonceModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Annonce introuvable',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<AnnonceModel> createAnnonce({
    required String title,
    required String description,
    required double price,
    required String category,
    required String condition,
    required String location,
    required List<XFile> images,
  }) async {
    try {
      final formData = FormData.fromMap({
        'title': title,
        'description': description,
        'price': price,
        'category': category,
        'condition': condition,
        'location': location,
      });

      // Ajouter les images
      for (var image in images) {
        formData.files.add(MapEntry(
          'images',
          await MultipartFile.fromFile(
            image.path,
            filename: image.name,
          ),
        ));
      }

      final response = await dioClient.post(
        ApiConstants.annonces,
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        ),
      );

      if (response.data['success'] == true) {
        return AnnonceModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Erreur de publication',
        );
      }
    } on DioException {
      rethrow;
    }
  }
}
