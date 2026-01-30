
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/annonce_repository.dart';
import 'annonce_event.dart';
import 'annonce_state.dart';

class AnnonceBloc extends Bloc<AnnonceEvent, AnnonceState> {
  final AnnonceRepository annonceRepository;

  AnnonceBloc({required this.annonceRepository}) : super(AnnonceInitial()) {
    on<LoadAnnoncesEvent>(_onLoadAnnonces);
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
