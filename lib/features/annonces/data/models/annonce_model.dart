import '../../../authentification/data/models/user_model.dart';
import '../../domain/entities/annonce.dart';

class AnnonceModel extends Annonce {
  const AnnonceModel({
    required super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.category,
    required super.condition,
    required super.location,
    required super.images,
    required super.userId,
    super.seller,
    super.status,
    super.views,
    super.isFeatured,
    super.createdAt,
    super.updatedAt,
  });

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
    UserModel? seller,
    String? status,
    int? views,
    bool? isFeatured,
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
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}