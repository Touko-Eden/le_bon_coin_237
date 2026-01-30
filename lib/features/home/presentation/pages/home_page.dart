import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:secondmain_237/core/constants/app_colors.dart';
import 'package:secondmain_237/core/constants/app_strings.dart';
import '../widgets/category_chip.dart';
import '../widgets/annonce_card_horizontal.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

// Catégories principales
  final List<Map<String, dynamic>> _categories = [
  {'icon': Icons.phone_android, 'name': AppStrings.electronics, 'color': AppColors.illustrationPeach},
{'icon': Icons.chair_outlined, 'name': AppStrings.furniture, 'color': AppColors.illustrationYellow},
{'icon': Icons.checkroom, 'name': AppStrings.fashion, 'color': AppColors.illustrationPink},
{'icon': Icons.directions_car, 'name': AppStrings.automobile, 'color': AppColors.illustrationBlue},
{'icon': Icons.toys_outlined, 'name': AppStrings.children, 'color': AppColors.illustrationMint},
{'icon': Icons.home_outlined, 'name': AppStrings.house, 'color': AppColors.illustrationPeach},
{'icon': Icons.sports_soccer, 'name': AppStrings.sports, 'color': AppColors.illustrationBlue},
{'icon': Icons.more_horiz, 'name': AppStrings.other, 'color': AppColors.greyLight},
];

// Annonces factices pour la démo (TODO: Remplacer par des données réelles du backend)
final List<Map<String, dynamic>> _recentAnnonces = [
{
'id': '1',
'title': 'iPhone 12 Pro Max 256 Go',
'price': 350000,
'location': AppStrings.douala,
'image': 'https://images.unsplash.com/photo-1592286927505-cda0181d1ac8?w=400',
'isFavorite': false,
'category': AppStrings.electronics,
},
{
'id': '2',
'title': 'Canapé 3 places en cuir',
'price': 120000,
'location': AppStrings.yaounde,
'image': 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=400',
'isFavorite': true,
'category': AppStrings.furniture,
},
{
'id': '3',
'title': 'MacBook Pro 2020',
'price': 550000,
'location': AppStrings.douala,
'image': 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400&h=300&fit=crop',
'isFavorite': false,
'category': AppStrings.electronics,
},
];

@override
void dispose() {
  _searchController.dispose();
  super.dispose();
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(
        child: CustomScrollView(
            slivers: [
// App Bar avec recherche
            _buildAppBar(),

        // Barre de recherche
        _buildSearchBar(),

    // Section Catégories
    _buildCategoriesSection(),

    // Section Annonces Récentes
    _buildRecentAnnoncesSection(),
    ],
  ),
  ),
  );

}

Widget _buildAppBar() {
  return SliverAppBar(
    floating: true,
    backgroundColor: AppColors.backgroundLight,
    elevation: 0,
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text(
      'Bonjour 👋',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: AppColors.textSecondary,
      ),
    ),
    Text(
      AppStrings.appName,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.primary,
      ),
    ),
    ],
  ),
  actions: [
  IconButton(
  icon: const Icon(Icons.notifications_outlined),
  color: AppColors.textPrimary,
  onPressed: () {
// TODO: Navigation vers les notifications
  },
  ),
  ],
  );
}

Widget _buildSearchBar() {
  return SliverToBoxAdapter(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: AppStrings.searchProducts,
            prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
            suffixIcon: IconButton(
              icon: const Icon(Icons.tune, color: AppColors.primary),
              onPressed: () {
// TODO: Ouvrir les filtres
              },
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: AppColors.backgroundLight,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onTap: () {
// TODO: Navigation vers la page de recherche
          },
        ),
      ),
    ),
  );
}

Widget _buildCategoriesSection() {
  return SliverToBoxAdapter(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.categories,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
// TODO: Voir toutes les catégories
                },
                child: Text(
                  AppStrings.seeAll,
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CategoryChip(
                  icon: category['icon'],
                  name: category['name'],
                  color: category['color'],
                  onTap: () {
// TODO: Navigation vers la liste filtrée par catégorie
                  },
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

Widget _buildRecentAnnoncesSection() {
  return SliverToBoxAdapter(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.recentAnnonces,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  context.push('/annonces');
                },
                child: Text(
                  AppStrings.seeAll,
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _recentAnnonces.length,
          itemBuilder: (context, index) {
            final annonce = _recentAnnonces[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
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
        ),
        const SizedBox(height: 80), // Espace pour le FAB
      ],
    ),
  );
}
}