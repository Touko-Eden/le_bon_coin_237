
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
  Future<AnnonceModel> updateAnnonce({
    required int id,
    String? title,
    String? description,
    double? price,
    String? category,
    String? condition,
    String? location,
    List<XFile>? images,
  });
  Future<void> deleteAnnonce(int id);
  Future<List<AnnonceModel>> getMyAnnonces();
  Future<List<AnnonceModel>> getFavorites();
  Future<bool> toggleFavorite(int annonceId);
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
      );

      if (response.data['success'] == true) {
        return AnnonceModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Erreur lors de la création',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<AnnonceModel> updateAnnonce({
    required int id,
    String? title,
    String? description,
    double? price,
    String? category,
    String? condition,
    String? location,
    List<XFile>? images,
  }) async {
    try {
      final formData = FormData.fromMap({});
      if (title != null) formData.fields.add(MapEntry('title', title));
      if (description != null) formData.fields.add(MapEntry('description', description));
      if (price != null) formData.fields.add(MapEntry('price', price.toString()));
      if (category != null) formData.fields.add(MapEntry('category', category));
      if (condition != null) formData.fields.add(MapEntry('condition', condition));
      if (location != null) formData.fields.add(MapEntry('location', location));

      if (images != null) {
        for (var image in images) {
          formData.files.add(MapEntry(
            'images',
            await MultipartFile.fromFile(
              image.path,
              filename: image.name,
            ),
          ));
        }
      }

      final response = await dioClient.put(
        ApiConstants.annonceById(id),
        data: formData,
      );

      if (response.data['success'] == true) {
        return AnnonceModel.fromJson(response.data['data']);
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Erreur de mise à jour',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<void> deleteAnnonce(int id) async {
    try {
      final response = await dioClient.delete(ApiConstants.annonceById(id));

      if (response.data['success'] != true) {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Erreur de suppression',
        );
      }
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<AnnonceModel>> getMyAnnonces() async {
    try {
      final response = await dioClient.get(ApiConstants.myAnnonces);

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
  Future<List<AnnonceModel>> getFavorites() async {
    try {
      final response = await dioClient.get(ApiConstants.favorites);

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
  Future<bool> toggleFavorite(int annonceId) async {
    try {
      final response = await dioClient.post(
        ApiConstants.toggleFavorite,
        data: {'annonceId': annonceId},
      );

      if (response.data['success'] == true) {
        return response.data['isFavorite'] as bool;
      } else {
        throw DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Erreur',
        );
      }
    } on DioException {
      rethrow;
    }
  }
}
