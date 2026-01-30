
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class AnnonceEvent extends Equatable {
  const AnnonceEvent();

  @override
  List<Object> get props => [];
}

class LoadAnnoncesEvent extends AnnonceEvent {}

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
