
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class AnnonceEvent extends Equatable {
  const AnnonceEvent();

  @override
  List<Object> get props => [];
}

class LoadAnnoncesEvent extends AnnonceEvent {}

class LoadMyAnnoncesEvent extends AnnonceEvent {}

class LoadFavoritesEvent extends AnnonceEvent {}

class ToggleFavoriteEvent extends AnnonceEvent {
  final int annonceId;

  const ToggleFavoriteEvent(this.annonceId);

  @override
  List<Object> get props => [annonceId];
}

class DeleteAnnonceEvent extends AnnonceEvent {
  final int annonceId;

  const DeleteAnnonceEvent(this.annonceId);

  @override
  List<Object> get props => [annonceId];
}

class UpdateAnnonceEvent extends AnnonceEvent {
  final int id;
  final String? title;
  final String? description;
  final double? price;
  final String? category;
  final String? condition;
  final String? location;
  final List<XFile>? images;

  const UpdateAnnonceEvent({
    required this.id,
    this.title,
    this.description,
    this.price,
    this.category,
    this.condition,
    this.location,
    this.images,
  });

  @override
  List<Object> get props => [id];
}

class GetAnnonceByIdEvent extends AnnonceEvent {
  final int id;

  const GetAnnonceByIdEvent(this.id);

  @override
  List<Object> get props => [id];
}

class CreateAnnonceEvent extends AnnonceEvent {
  final String title;
  final String description;
  final double price;
  final String category;
  final String condition;
  final String location;
  final List<XFile> images;

  const CreateAnnonceEvent({
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.condition,
    required this.location,
    required this.images,
  });

  @override
  List<Object> get props => [title, description, price, category, condition, location, images];
}
