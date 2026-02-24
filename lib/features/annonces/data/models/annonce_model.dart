import '../../../authentification/data/models/user_model.dart';
import '../../../authentification/domain/entities/user.dart';
import '../../domain/entities/annonce.dart';

class AnnonceModel extends Annonce {
  const AnnonceModel({
    required int id,
    required String title,
    required String description,
    required double price,
    required String category,
    required String condition,
    required String location,
    required List<String> images,
    required int userId,
    User? seller,
    String status = 'active',
    int views = 0,
    bool isFeatured = false,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super(
          id: id,
          title: title,
          description: description,
          price: price,
          category: category,
          condition: condition,
          location: location,
          images: images,
          userId: userId,
          seller: seller,
          status: status,
          views: views,
          isFeatured: isFeatured,
          isFavorite: isFavorite ?? false,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory AnnonceModel.fromJson(Map<String, dynamic> json) {
    return AnnonceModel(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      price: double.parse(json['price'].toString()),
      category: json['category'] as String,
      condition: json['condition'] as String,
      location: json['location'] as String,
      images: List<String>.from(json['images'] as List),
      userId: json['userId'] as int,
      seller: json['seller'] != null
          ? UserModel.fromJson(json['seller'] as Map<String, dynamic>)
          : null,
      status: json['status'] as String? ?? 'active',
      views: json['views'] as int? ?? 0,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'condition': condition,
      'location': location,
      'images': images,
      'userId': userId,
      'status': status,
      'views': views,
      'isFeatured': isFeatured,
      'isFavorite': isFavorite,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  AnnonceModel copyWith({
    int? id,
    String? title,
    String? description,
    double? price,
    String? category,
    String? condition,
    String? location,
    List<String>? images,
    int? userId,
    User? seller,
    String? status,
    int? views,
    bool? isFeatured,
    bool? isFavorite,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AnnonceModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      location: location ?? this.location,
      images: images ?? this.images,
      userId: userId ?? this.userId,
      seller: seller ?? this.seller,
      status: status ?? this.status,
      views: views ?? this.views,
      isFeatured: isFeatured ?? this.isFeatured,
      isFavorite: isFavorite ?? this.isFavorite,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
