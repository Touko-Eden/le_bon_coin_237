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
    this.createdAt,
    this.updatedAt,
  });

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
    createdAt,
    updatedAt,
  ];
}