
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secondmain_237/core/constants/app_colors.dart';
import 'package:secondmain_237/features/annonces/presentation/bloc/annonce_bloc.dart';
import 'package:secondmain_237/features/annonces/presentation/bloc/annonce_event.dart';
import 'package:secondmain_237/features/annonces/presentation/bloc/annonce_state.dart';
import 'package:secondmain_237/features/authentification/presentation/widgets/custom_button.dart';
import 'package:secondmain_237/features/authentification/presentation/widgets/custom_text_field.dart';

class CreateAnnoncePage extends StatefulWidget {
  const CreateAnnoncePage({Key? key}) : super(key: key);

  @override
  State<CreateAnnoncePage> createState() => _CreateAnnoncePageState();
}

class _CreateAnnoncePageState extends State<CreateAnnoncePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedCategory = 'Véhicules';
  String _selectedCondition = 'Bon état';
  List<XFile> _selectedImages = [];

  final ImagePicker _picker = ImagePicker();

  final List<String> _categories = [
    'Véhicules',
    'Immobilier',
    'Multimédia',
    'Maison',
    'Mode',
    'Loisirs',
    'Autres'
  ];

  final List<String> _conditions = [
    'Neuf',
    'Très bon état',
    'Bon état',
    'État correct',
    'Pour pièces'
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(images);
        // Limiter à 3 images pour l'exemple
        if (_selectedImages.length > 3) {
          _selectedImages = _selectedImages.sublist(0, 3);
        }
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedImages.length < 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez ajouter au moins 3 photos'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
      
      context.read<AnnonceBloc>().add(
        CreateAnnonceEvent(
          title: _titleController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text.replaceAll(' ', '')),
          category: _selectedCategory,
          condition: _selectedCondition,
          location: _locationController.text,
          images: _selectedImages,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Déposer une annonce'),
        elevation: 0,
      ),
      body: BlocListener<AnnonceBloc, AnnonceState>(
        listener: (context, state) {
          if (state is AnnonceCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Annonce publiée avec succès ! 🚀'),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context);
          } else if (state is AnnonceError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: BlocBuilder<AnnonceBloc, AnnonceState>(
          builder: (context, state) {
            final isLoading = state is AnnonceLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section Photos
                    Text(
                      'Photos (Min 3)',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _selectedImages.length < 3 ? AppColors.error : null,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildImagePicker(),
                    if (_selectedImages.length < 3)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          'Veuillez ajouter au moins 3 photos pour que les acheteurs voient bien le produit.',
                          style: TextStyle(color: AppColors.error, fontSize: 12),
                        ),
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Titre
                    CustomTextField(
                      controller: _titleController,
                      label: 'Titre de l\'annonce *',
                      hint: 'Ex: iPhone 12 Pro Max 256Go',
                      enabled: !isLoading,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'Le titre est requis' : null,
                    ),

                    const SizedBox(height: 16),

                    // Catégorie
                    _buildDropdown(
                      label: 'Catégorie *',
                      value: _selectedCategory,
                      items: _categories,
                      onChanged: (val) => setState(() => _selectedCategory = val!),
                    ),

                    const SizedBox(height: 16),

                    // État
                    _buildDropdown(
                      label: 'État *',
                      value: _selectedCondition,
                      items: _conditions,
                      onChanged: (val) => setState(() => _selectedCondition = val!),
                    ),

                    const SizedBox(height: 16),

                    // Prix
                    CustomTextField(
                      controller: _priceController,
                      label: 'Prix (FCFA) *',
                      hint: 'Ex: 150000',
                      keyboardType: TextInputType.number,
                      enabled: !isLoading,
                      validator: (value) {
                         if (value == null || value.isEmpty) return 'Le prix est requis';
                         final cleanValue = value.replaceAll(' ', '');
                         if (double.tryParse(cleanValue) == null) return 'Prix invalide';
                         return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Description
                    CustomTextField(
                      controller: _descriptionController,
                      label: 'Description *',
                      hint: 'Décrivez votre article en détail (min 20 caractères)...',
                      maxLines: 5,
                      enabled: !isLoading,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'La description est requise';
                        if (value.length < 20) return 'La description doit contenir au moins 20 caractères';
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Localisation
                    CustomTextField(
                      controller: _locationController,
                      label: 'Ville / Quartier *',
                      hint: 'Ex: Douala, Akwa',
                      prefixIcon: const Icon(Icons.location_on_outlined),
                      enabled: !isLoading,
                      validator: (value) =>
                          value?.isEmpty ?? true ? 'La localisation est requise' : null,
                    ),

                    const SizedBox(height: 32),

                    // Bouton Valider
                    CustomButton(
                      text: 'Publier l\'annonce',
                      onPressed: isLoading ? () {} : _submitForm,
                      isLoading: isLoading,
                      backgroundColor: AppColors.primary,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _selectedImages.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == _selectedImages.length) {
            // Bouton Ajouter
            if (_selectedImages.length >= 3) return const SizedBox.shrink();
            return GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt_outlined, color: Colors.grey),
                    SizedBox(height: 4),
                    Text('Ajouter', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),
            );
          }

          // Image Preview
          return Stack(
            children: [
              Container(
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: FileImage(File(_selectedImages[index].path)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => _removeImage(index),
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.inputBorder),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}