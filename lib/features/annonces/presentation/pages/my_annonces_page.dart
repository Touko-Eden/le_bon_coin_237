import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondmain_237/core/constants/app_colors.dart';
import 'package:secondmain_237/features/annonces/presentation/bloc/annonce_bloc.dart';
import 'package:secondmain_237/features/annonces/presentation/bloc/annonce_event.dart';
import 'package:secondmain_237/features/annonces/presentation/bloc/annonce_state.dart';
import 'package:secondmain_237/features/home/presentation/widgets/annonce_card_horizontal.dart';

class MyAnnoncesPage extends StatefulWidget {
  const MyAnnoncesPage({Key? key}) : super(key: key);

  @override
  State<MyAnnoncesPage> createState() => _MyAnnoncesPageState();
}

class _MyAnnoncesPageState extends State<MyAnnoncesPage> {
  @override
  void initState() {
    super.initState();
    context.read<AnnonceBloc>().add(LoadMyAnnoncesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Annonces'),
        backgroundColor: AppColors.primary,
      ),
      body: BlocBuilder<AnnonceBloc, AnnonceState>(
        builder: (context, state) {
          if (state is AnnonceLoading) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primary));
          } else if (state is AnnonceError) {
            return Center(child: Text(state.message));
          } else if (state is MyAnnoncesLoaded) {
            if (state.annonces.isEmpty) {
              return const Center(child: Text('Vous n\'avez publié aucune annonce.'));
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
                    // Action à définir pour le favori (inutile ici)
                  },
                );
                void _showDeleteDialog(BuildContext context, int annonceId) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Supprimer l\'annonce'),
                        content: const Text('Êtes-vous sûr de vouloir supprimer cette annonce ?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Annuler'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Supprimer'),
                            onPressed: () {
                              context.read<AnnonceBloc>().add(DeleteAnnonceEvent(annonceId));
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            );
          }
          return const Center(child: Text('Chargement de vos annonces...'));
        },
      ),
    );
  }
}
