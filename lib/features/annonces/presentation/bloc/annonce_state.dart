
import 'package:equatable/equatable.dart';
import '../../domain/entities/annonce.dart';

abstract class AnnonceState extends Equatable {
  const AnnonceState();

  @override
  List<Object> get props => [];
}

class AnnonceInitial extends AnnonceState {}

class AnnonceLoading extends AnnonceState {}

class AnnonceLoaded extends AnnonceState {
  final List<Annonce> annonces;

  const AnnonceLoaded(this.annonces);

  @override
  List<Object> get props => [annonces];
}

class AnnonceDetailLoaded extends AnnonceState {
  final Annonce annonce;

  const AnnonceDetailLoaded(this.annonce);

  @override
  List<Object> get props => [annonce];
}

class AnnonceCreated extends AnnonceState {
  final Annonce annonce;

  const AnnonceCreated(this.annonce);

  @override
  List<Object> get props => [annonce];
}

class AnnonceUpdated extends AnnonceState {
  final Annonce annonce;

  const AnnonceUpdated(this.annonce);

  @override
  List<Object> get props => [annonce];
}

class AnnonceDeleted extends AnnonceState {
  const AnnonceDeleted();
}

class MyAnnoncesLoaded extends AnnonceState {
  final List<Annonce> annonces;

  const MyAnnoncesLoaded(this.annonces);

  @override
  List<Object> get props => [annonces];
}

class FavoritesLoaded extends AnnonceState {
  final List<Annonce> annonces;

  const FavoritesLoaded(this.annonces);

  @override
  List<Object> get props => [annonces];
}

class AnnonceError extends AnnonceState {
  final String message;

  const AnnonceError(this.message);

  @override
  List<Object> get props => [message];
}
