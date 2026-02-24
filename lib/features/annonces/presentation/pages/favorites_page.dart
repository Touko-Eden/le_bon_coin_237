import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondmain_237/core/constants/app_colors.dart';
import 'package:secondmain_237/features/annonces/presentation/bloc/annonce_bloc.dart';
import 'package:secondmain_237/features/annonces/presentation/bloc/annonce_event.dart';
import 'package:secondmain_237/features/annonces/presentation/bloc/annonce_state.dart';
import 'package:secondmain_237/features/home/presentation/widgets/annonce_card_horizontal.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    context.read<AnnonceBloc>().add(LoadFavoritesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Favoris'),
        backgroundColor: AppColors.primary,
      ),
      body: BlocBuilder<AnnonceBloc, AnnonceState>(
        builder: (context, state) {
          if (state is AnnonceLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (state is AnnonceError) {
            return Center(child: Text(state.message));
          } else if (state is FavoritesLoaded) { 
            if (state.annonces.isEmpty) {
              return const Center(child: Text('Vous n\'avez aucun favori.'));
            }
            return ListView.builder(
              itemCount: state.annonces.length,
              itemBuilder: (context, index) {
                final annonce = state.annonces[index];
                return AnnonceCardHorizontal(
                  title: annonce.title,
                  price: annonce.price.toInt(),
                  location: annonce.location,
                  imageUrl: annonce.images.isNotEmpty ? annonce.images.first : '',
                  isFavorite: annonce.isFavorite,
                  onTap: () {
                    // Action à définir lors du clic sur la carte
                  },
                  onFavoriteToggle: () {
                    context.read<AnnonceBloc>().add(ToggleFavoriteEvent(annonce.id));
                  },
                );
              },
            );
          }
          return const Center(child: Text('Chargement de vos favoris...'));
        },
      ),
    );
  }
}
