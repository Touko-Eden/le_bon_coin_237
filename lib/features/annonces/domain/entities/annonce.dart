import 'package:equatable/equatable.dart';
import '../../../authentification/domain/entities/user.dart';

class Annonce extends Equatable {
  final int id;
  final String title;
  final String description;
  final double price;
  final String category;
  final String condition;
  final String location;
  final List<String> images;
  final int userId;
  final User? seller;
  final String status;
  final int views;
  final bool isFeatured;
  final bool isFavorite;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Annonce({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.condition,
    required this.location,
    required this.images,
    required this.userId,
    this.seller,
    this.status = 'active',
    this.views = 0,
    this.isFeatured = false,
    this.isFavorite = false,
    this.createdAt,
    this.updatedAt,
  });

  Annonce copyWith({
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
    return Annonce(
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

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    price,
    category,
    condition,
    location,
    images,
    userId,
    seller,
    status,
    views,
    isFeatured,
    isFavorite,
    createdAt,
    updatedAt,
  ];
}