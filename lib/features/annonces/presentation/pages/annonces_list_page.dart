import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:secondmain_237/core/constants/app_colors.dart';
import 'package:secondmain_237/core/constants/app_strings.dart';
import 'package:secondmain_237/features/annonces/presentation/bloc/annonce_bloc.dart';
import 'package:secondmain_237/features/annonces/presentation/bloc/annonce_event.dart';
import 'package:secondmain_237/features/annonces/presentation/bloc/annonce_state.dart';
import 'package:secondmain_237/features/annonces/presentation/widgets/annonce_card_grid.dart';
import 'package:secondmain_237/features/home/presentation/widgets/annonce_card_horizontal.dart';
import 'package:secondmain_237/features/annonces/presentation/widgets/filter_bottom_sheet.dart';
import 'package:secondmain_237/features/annonces/domain/entities/annonce.dart';

class AnnoncesListPage extends StatefulWidget {
  const AnnoncesListPage({Key? key}) : super(key: key);

  @override
  State<AnnoncesListPage> createState() => _AnnoncesListPageState();
}

class _AnnoncesListPageState extends State<AnnoncesListPage> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'Tous';
  String _selectedSort = AppStrings.sortRecent;
  bool _isGridView = true;

  List<Annonce> get _filteredAnnonces {
    // Note: Filtering should ideally happen in the Bloc or Repository
    // But for now we can filter the loaded list locally
    final state = context.read<AnnonceBloc>().state;
    if (state is! AnnonceLoaded) return [];
    
    List<Annonce> filtered = state.annonces;

    // Filtrer par catégorie
    if (_selectedCategory != 'Tous') {
      filtered = filtered.where((a) => a.category == _selectedCategory).toList();
    }

    // Recherche
    if (_searchController.text.isNotEmpty) {
      filtered = filtered.where((a) =>
        a.title.toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    }

    // Tri
    if (_selectedSort == AppStrings.sortPriceLow) {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (_selectedSort == AppStrings.sortPriceHigh) {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    }

    return filtered;
  }

@override
  void initState() {
    super.initState();
    // Charger les annonces au démarrage
    context.read<AnnonceBloc>().add(LoadAnnoncesEvent());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

void _showFilterSheet() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => FilterBottomSheet(
      selectedCategory: _selectedCategory,
      selectedSort: _selectedSort,
      onApply: (category, sort) {
        setState(() {
          _selectedCategory = category;
          _selectedSort = sort;
        });
      },
    ),
  );
}

@override
Widget build(BuildContext context) {
  return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(AppStrings.annonces),
        actions: [
// Toggle vue grille/liste
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: Column(
          children: [
// Barre de recherche avec filtres
          _buildSearchAndFilterBar(),

      // Chips de catégories
      _buildCategoryChips(),

  // Liste des annonces
  Expanded(
  child: _filteredAnnonces.isEmpty
  ? _buildEmptyState()
      : _buildAnnoncesList(),
  ),
  ],
  ),
  );

}

Widget _buildSearchAndFilterBar() {
  return Container(
    padding: const EdgeInsets.all(16),
    color: AppColors.backgroundLight,
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: AppStrings.searchProducts,
              prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: (value) {
              setState(() {});
            },
          ),
        ),
        const SizedBox(width: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.tune, color: AppColors.textWhite),
            onPressed: _showFilterSheet,
          ),
        ),
      ],
    ),
  );
}

Widget _buildCategoryChips() {
  final categories = ['Tous', AppStrings.electronics, AppStrings.furniture,
  AppStrings.fashion, AppStrings.automobile];

  return Container(
  height: 50,
  padding: const EdgeInsets.symmetric(vertical: 8),
  child: ListView.builder(
  scrollDirection: Axis.horizontal,
  padding: const EdgeInsets.symmetric(horizontal: 16),
  itemCount: categories.length,
  itemBuilder: (context, index) {
  final category = categories[index];
  final isSelected = _selectedCategory == category;

  return Padding(
  padding: const EdgeInsets.only(right: 8),
  child: ChoiceChip(
  label: Text(category),
  selected: isSelected,
  onSelected: (selected) {
  setState(() {
  _selectedCategory = category;
  });
  },
  backgroundColor: AppColors.backgroundLight,
  selectedColor: AppColors.primary,
  labelStyle: TextStyle(
  color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
  ),
  ),
  );
  },
  ),
  );

}

  Widget _buildAnnoncesList() {
    return BlocBuilder<AnnonceBloc, AnnonceState>(
      builder: (context, state) {
        if (state is AnnonceLoading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        } else if (state is AnnonceError) {
          return Center(child: Text(state.message, style: const TextStyle(color: AppColors.error)));
        } else if (state is AnnonceLoaded) {
          if (_filteredAnnonces.isEmpty) {
            return _buildEmptyState();
          }

          if (_isGridView) {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: _filteredAnnonces.length,
              itemBuilder: (context, index) {
                final annonce = _filteredAnnonces[index];
                return AnnonceCardGrid(
                  title: annonce.title,
                  price: annonce.price.toInt(),
                  location: annonce.location,
                  imageUrl: annonce.images.isNotEmpty ? annonce.images.first : '',
                  isFavorite: annonce.isFavorite,
                  onTap: () {
                    context.go('/annonce/${annonce.id}');
                  },
                  onFavoriteToggle: () {
                    context.read<AnnonceBloc>().add(ToggleFavoriteEvent(annonce.id));
                  },
                );
              },
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _filteredAnnonces.length,
              itemBuilder: (context, index) {
                final annonce = _filteredAnnonces[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AnnonceCardHorizontal(
                    title: annonce.title,
                    price: annonce.price.toInt(),
                    location: annonce.location,
                    imageUrl: annonce.images.isNotEmpty ? annonce.images.first : '',
                    isFavorite: annonce.isFavorite,
                    onTap: () {
                      context.go('/annonce/${annonce.id}');
                    },
                    onFavoriteToggle: () {
                      context.read<AnnonceBloc>().add(ToggleFavoriteEvent(annonce.id));
                    },
                  ),
                );
              },
            );
          }
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            'Aucune annonce trouvée',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}