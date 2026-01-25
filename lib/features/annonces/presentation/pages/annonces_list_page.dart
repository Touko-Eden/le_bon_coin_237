import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secondmain_237/core/constants/app_colors.dart';
import 'package:secondmain_237/core/constants/app_strings.dart';
import 'package:secondmain_237/features/annonces/presentation/widgets/annonce_card_grid.dart';
import 'package:secondmain_237/features/home/presentation/widgets/annonce_card_horizontal.dart';
import 'package:secondmain_237/features/annonces/presentation/widgets/filter_bottom_sheet.dart';

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

// Données factices (TODO: Remplacer par données du backend)
  final List<Map<String, dynamic>> _annonces = [
  {
  'id': '1',
  'title': 'iPhone 12 Pro Max 256 Go',
  'price': 350000,
  'location': AppStrings.douala,
  'image': 'https://via.placeholder.com/300x200/E91E63/FFFFFF?text=iPhone',
  'isFavorite': false,
  'category': AppStrings.electronics,
},
{
'id': '2',
'title': 'Canapé 3 places en cuir véritable',
'price': 120000,
'location': AppStrings.yaounde,
'image': 'https://via.placeholder.com/300x200/FBC02D/FFFFFF?text=Canapé',
'isFavorite': true,
'category': AppStrings.furniture,
},
{
'id': '3',
'title': 'MacBook Pro 2020 M1',
'price': 550000,
'location': AppStrings.douala,
'image': 'https://via.placeholder.com/300x200/03A9F4/FFFFFF?text=MacBook',
'isFavorite': false,
'category': AppStrings.electronics,
},
{
'id': '4',
'title': 'Toyota Corolla 2018',
'price': 8500000,
'location': AppStrings.yaounde,
'image': 'https://via.placeholder.com/300x200/FF6F00/FFFFFF?text=Toyota',
'isFavorite': false,
'category': AppStrings.automobile,
},
{
'id': '5',
'title': 'Lit bébé avec matelas',
'price': 45000,
'location': AppStrings.bafoussam,
'image': 'https://via.placeholder.com/300x200/00897B/FFFFFF?text=Lit+bébé',
'isFavorite': true,
'category': AppStrings.children,
},
{
'id': '6',
'title': 'Robe de soirée élégante',
'price': 25000,
'location': AppStrings.douala,
'image': 'https://via.placeholder.com/300x200/E91E63/FFFFFF?text=Robe',
'isFavorite': false,
'category': AppStrings.fashion,
},
];

List<Map<String, dynamic>> get _filteredAnnonces {
  List<Map<String, dynamic>> filtered = _annonces;

// Filtrer par catégorie
  if (_selectedCategory != 'Tous') {
  filtered = filtered.where((a) => a['category'] == _selectedCategory).toList();
  }

// Recherche
  if (_searchController.text.isNotEmpty) {
  filtered = filtered.where((a) =>
  a['title'].toLowerCase().contains(_searchController.text.toLowerCase())
  ).toList();
  }

// Tri
  if (_selectedSort == AppStrings.sortPriceLow) {
  filtered.sort((a, b) => a['price'].compareTo(b['price']));
  } else if (_selectedSort == AppStrings.sortPriceHigh) {
  filtered.sort((a, b) => b['price'].compareTo(a['price']));
  }

  return filtered;

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
          title: annonce['title'],
          price: annonce['price'],
          location: annonce['location'],
          imageUrl: annonce['image'],
          isFavorite: annonce['isFavorite'],
          onTap: () {
            context.push('/annonce/${annonce['id']}');
          },
          onFavoriteToggle: () {
            setState(() {
              annonce['isFavorite'] = !annonce['isFavorite'];
              });
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
            title: annonce['title'],
            price: annonce['price'],
            location: annonce['location'],
            imageUrl: annonce['image'],
            isFavorite: annonce['isFavorite'],
            onTap: () {
              context.push('/annonce/${annonce['id']}');
            },
            onFavoriteToggle: () {
              setState(() {
                annonce['isFavorite'] = !annonce['isFavorite'];
                });
            },
          ),
        );
      },
    );
  }
}

Widget _buildEmptyState() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Icon(
      Icons.search_off,
      size: 80,
      color: AppColors.textHint,
    ),
    const SizedBox(height: 16),
    Text(
      AppStrings.noResults,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: AppColors.textSecondary,
      ),
    ),
    const SizedBox(height: 8),
    Text(
    'Essayez de modifier vos filtres',
    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: AppColors.textHint,
    ),
  ),
  ],
  ),
  );
}
}