
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/annonce_repository.dart';
import 'annonce_event.dart';
import 'annonce_state.dart';

class AnnonceBloc extends Bloc<AnnonceEvent, AnnonceState> {
  final AnnonceRepository annonceRepository;

  AnnonceBloc({required this.annonceRepository}) : super(AnnonceInitial()) {
    on<LoadAnnoncesEvent>(_onLoadAnnonces);
    on<LoadMyAnnoncesEvent>(_onLoadMyAnnonces);
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<UpdateAnnonceEvent>(_onUpdateAnnonce);
    on<DeleteAnnonceEvent>(_onDeleteAnnonce);
    on<GetAnnonceByIdEvent>(_onGetAnnonceById);
    on<CreateAnnonceEvent>(_onCreateAnnonce);
  }

  Future<void> _onLoadAnnonces(
    LoadAnnoncesEvent event,
    Emitter<AnnonceState> emit,
  ) async {
    emit(AnnonceLoading());
    final result = await annonceRepository.getAnnonces();
    result.fold(
      (failure) => emit(AnnonceError(failure.message)),
      (annonces) => emit(AnnonceLoaded(annonces)),
    );
  }

  Future<void> _onLoadMyAnnonces(
    LoadMyAnnoncesEvent event,
    Emitter<AnnonceState> emit,
  ) async {
    emit(AnnonceLoading());
    final result = await annonceRepository.getMyAnnonces();
    result.fold(
      (failure) => emit(AnnonceError(failure.message)),
      (annonces) => emit(MyAnnoncesLoaded(annonces)),
    );
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<AnnonceState> emit,
  ) async {
    emit(AnnonceLoading());
    final result = await annonceRepository.getFavorites();
    result.fold(
      (failure) => emit(AnnonceError(failure.message)),
      (annonces) => emit(FavoritesLoaded(annonces)),
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<AnnonceState> emit,
  ) async {
    final result = await annonceRepository.toggleFavorite(event.annonceId);
    
    result.fold(
      (failure) => emit(AnnonceError(failure.message)),
      (isFavorite) {
        if (state is AnnonceLoaded) {
          final currentAnnonces = (state as AnnonceLoaded).annonces;
          final updatedAnnonces = currentAnnonces.map((a) {
            if (a.id == event.annonceId) {
              return a.copyWith(isFavorite: isFavorite);
            }
            return a;
          }).toList();
          // If we are in Favorites list and we untoggle, maybe we should remove it?
          // But determining if we are in Favorites list is implicit.
          // For now, just update the isFavorite flag. The user can refresh to remove it.
          // Or we can check if the list was loaded via LoadFavoritesEvent (not possible here easily).
          emit(AnnonceLoaded(updatedAnnonces));
        } else if (state is AnnonceDetailLoaded) {
           final a = (state as AnnonceDetailLoaded).annonce;
           if (a.id == event.annonceId) {
             emit(AnnonceDetailLoaded(a.copyWith(isFavorite: isFavorite)));
           }
        }
      },
    );
  }

  Future<void> _onUpdateAnnonce(
    UpdateAnnonceEvent event,
    Emitter<AnnonceState> emit,
  ) async {
    emit(AnnonceLoading());
    final result = await annonceRepository.updateAnnonce(
      id: event.id,
      title: event.title,
      description: event.description,
      price: event.price,
      category: event.category,
      condition: event.condition,
      location: event.location,
      images: event.images,
    );
    result.fold(
      (failure) => emit(AnnonceError(failure.message)),
      (annonce) => emit(AnnonceUpdated(annonce)),
    );
  }

  Future<void> _onDeleteAnnonce(
    DeleteAnnonceEvent event,
    Emitter<AnnonceState> emit,
  ) async {
    final result = await annonceRepository.deleteAnnonce(event.annonceId);
    result.fold(
      (failure) => emit(AnnonceError(failure.message)),
      (_) {
        if (state is AnnonceLoaded) {
           final currentAnnonces = (state as AnnonceLoaded).annonces;
           final updatedAnnonces = currentAnnonces.where((a) => a.id != event.annonceId).toList();
           emit(AnnonceLoaded(updatedAnnonces));
        } else {
           emit(const AnnonceDeleted());
        }
      },
    );
  }

  Future<void> _onGetAnnonceById(
    GetAnnonceByIdEvent event,
    Emitter<AnnonceState> emit,
  ) async {
    emit(AnnonceLoading());
    final result = await annonceRepository.getAnnonceById(event.id);
    result.fold(
      (failure) => emit(AnnonceError(failure.message)),
      (annonce) => emit(AnnonceDetailLoaded(annonce)),
    );
  }

  Future<void> _onCreateAnnonce(
    CreateAnnonceEvent event,
    Emitter<AnnonceState> emit,
  ) async {
    emit(AnnonceLoading());
    final result = await annonceRepository.createAnnonce(
      title: event.title,
      description: event.description,
      price: event.price,
      category: event.category,
      condition: event.condition,
      location: event.location,
      images: event.images,
    );
    result.fold(
      (failure) => emit(AnnonceError(failure.message)),
      (annonce) => emit(AnnonceCreated(annonce)),
    );
  }
}
