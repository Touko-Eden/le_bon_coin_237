import 'package:flutter/material.dart';
import 'package:secondmain_237/core/constants/app_colors.dart';
import 'package:secondmain_237/core/constants/app_strings.dart';
import 'package:secondmain_237/features/authentification/presentation/widgets/custom_button.dart';

class FilterBottomSheet extends StatefulWidget {
  final String selectedCategory;
  final String selectedSort;
  final Function(String category, String sort) onApply;

  const FilterBottomSheet({
    Key? key,
    required this.selectedCategory,
    required this.selectedSort,
    required this.onApply,
  }) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _tempCategory;
  late String _tempSort;
  RangeValues _priceRange = const RangeValues(0, 1000000);
  String _selectedLocation = 'Tous';

  final List<String> _categories = [
  'Tous',
  AppStrings.electronics,
  AppStrings.furniture,
  AppStrings.fashion,
  AppStrings.automobile,
  AppStrings.children,
  AppStrings.house,
  AppStrings.sports,
  AppStrings.other,
  ];

  final List<String> _sortOptions = [
    AppStrings.sortRecent,
    AppStrings.sortPriceLow,
    AppStrings.sortPriceHigh,
  ];

  final List<String> _locations = [
  'Tous',
  AppStrings.douala,
  AppStrings.yaounde,
  AppStrings.bafoussam,
  AppStrings.garoua,
  AppStrings.bamenda,
  ];

  @override
  void initState() {
    super.initState();
    _tempCategory = widget.selectedCategory;
    _tempSort = widget.selectedSort;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
// Handle bar
          Container(
          margin: const EdgeInsets.symmetric(vertical: 12),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.greyLight,
            borderRadius: BorderRadius.circular(2),
          ),
        ),

    // Header
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text(
    AppStrings.filters,
    style: Theme.of(context).textTheme.titleLarge?.copyWith(
    fontWeight: FontWeight.bold,
    ),
    ),
    TextButton(
    onPressed: () {
    setState(() {
    _tempCategory = 'Tous';
    _tempSort = AppStrings.sortRecent;
    _priceRange = const RangeValues(0, 1000000);
    _selectedLocation = 'Tous';
    });
    },
    child: const Text(AppStrings.resetFilters),
    ),
    ],
    ),
    ),

    const Divider(),

    // Filtres
    Flexible(
    child: SingleChildScrollView(
    padding: const EdgeInsets.all(24),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // Catégorie
    _buildSectionTitle(AppStrings.category),
    const SizedBox(height: 12),
    _buildCategoryGrid(),

    const SizedBox(height: 24),

    // Fourchette de prix
    _buildSectionTitle(AppStrings.priceRange),
    const SizedBox(height: 12),
    _buildPriceRange(),

    const SizedBox(height: 24),

    // Localisation
    _buildSectionTitle(AppStrings.location),
    const SizedBox(height: 12),
    _buildLocationDropdown(),

    const SizedBox(height: 24),

    // Tri
    _buildSectionTitle(AppStrings.sortBy),
    const SizedBox(height: 12),
    _buildSortOptions(),
    ],
    ),
    ),
    ),

    // Boutons d'action
    Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
    color: AppColors.backgroundLight,
    boxShadow: [
    BoxShadow(
    color: AppColors.shadow,
    blurRadius: 10,
    offset: const Offset(0, -5),
    ),
    ],
    ),
    child: CustomButton(
    text: AppStrings.applyFilters,
    onPressed: () {
    widget.onApply(_tempCategory, _tempSort);
    Navigator.pop(context);
    },
    ),
    ),
    ],
    ),
    ),
    );

  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _categories.map((category) {
        final isSelected = _tempCategory == category;
        return GestureDetector(
          onTap: () {
            setState(() {
              _tempCategory = category;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.greyLight,
              ),
            ),
            child: Text(
              category,
              style: TextStyle(
                color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPriceRange() {
    return Column(
      children: [
      RangeSlider(
      values: _priceRange,
      min: 0,
      max: 10000000,
      divisions: 100,
      activeColor: AppColors.primary,
      labels: RangeLabels(
      '${_priceRange.start.toInt()} FCFA',
      '${_priceRange.end.toInt()} FCFA',
      ),
      onChanged: (RangeValues values) {
        setState(() {
          _priceRange = values;
        });
      },
    ),
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
    Text(
    '${_priceRange.start.toInt()} FCFA',
    style: Theme.of(context).textTheme.bodySmall?.copyWith(
    color: AppColors.textSecondary,
    ),
    ),
     Text(
    '${_priceRange.end.toInt()} FCFA',
    style: Theme.of(context).textTheme.bodySmall?.copyWith(
    color: AppColors.textSecondary,
    ),
    ),
    ],
    ),
    ],
    );
  }

  Widget _buildLocationDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyLight),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLocation,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: _locations.map((String location) {
            return DropdownMenuItem<String>(
              value: location,
              child: Text(location),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedLocation = newValue!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildSortOptions() {
    return Column(
      children: _sortOptions.map((option) {
        final isSelected = _tempSort == option;
        return RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: _tempSort,
          activeColor: AppColors.primary,
          onChanged: (value) {
            setState(() {
              _tempSort = value!;
            });
          },
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }
}