import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secondmain_237/core/constants/app_colors.dart';
import 'package:secondmain_237/features/annonces/domain/entities/annonce.dart';
import 'package:secondmain_237/features/annonces/presentation/bloc/annonce_bloc.dart';
import 'package:secondmain_237/features/annonces/presentation/bloc/annonce_event.dart';
import 'package:secondmain_237/features/annonces/presentation/bloc/annonce_state.dart';
// import 'package:secondmain_237/features/annonces/presentation/widgets/image_picker_widget.dart';

class EditAnnoncePage extends StatefulWidget {
  final Annonce annonce;
  const EditAnnoncePage({Key? key, required this.annonce}) : super(key: key);

  @override
  State<EditAnnoncePage> createState() => _EditAnnoncePageState();
}

class _EditAnnoncePageState extends State<EditAnnoncePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _locationController;
  String _category = 'Immobilier';
  String _condition = 'Neuf';
  List<XFile> _images = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.annonce.title);
    _descriptionController = TextEditingController(text: widget.annonce.description);
    _priceController = TextEditingController(text: widget.annonce.price.toString());
    _locationController = TextEditingController(text: widget.annonce.location);
    _category = widget.annonce.category;
    _condition = widget.annonce.condition;
    // On ne peut pas recharger les images existantes, l'utilisateur doit en sélectionner de nouvelles s'il veut les changer.
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier l\'annonce'),
        backgroundColor: AppColors.primary,
      ),
      body: BlocListener<AnnonceBloc, AnnonceState>(
        listener: (context, state) {
          if (state is AnnonceUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Annonce mise à jour avec succès!')),
            );
            Navigator.of(context).pop();
          } else if (state is AnnonceError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Titre'),
                  validator: (value) => value!.isEmpty ? 'Veuillez entrer un titre' : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 5,
                  validator: (value) => value!.isEmpty ? 'Veuillez entrer une description' : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Prix'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Veuillez entrer un prix' : null,
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Localisation'),
                  validator: (value) => value!.isEmpty ? 'Veuillez entrer une localisation' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _category,
                  onChanged: (value) => setState(() => _category = value!),
                  items: ['Immobilier', 'Véhicules', 'Électronique', 'Maison', 'Mode', 'Loisirs']
                      .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                      .toList(),
                  decoration: const InputDecoration(labelText: 'Catégorie'),
                ),
                DropdownButtonFormField<String>(
                  value: _condition,
                  onChanged: (value) => setState(() => _condition = value!),
                  items: ['Neuf', 'Très bon état', 'Bon état', 'Satisfaisant']
                      .map((label) => DropdownMenuItem(value: label, child: Text(label)))
                      .toList(),
                  decoration: const InputDecoration(labelText: 'État'),
                ),
                const SizedBox(height: 20),
                // ImagePickerWidget(onImagesSelected: (images) => _images = images), // Widget manquant
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<AnnonceBloc>().add(
                            UpdateAnnonceEvent(
                              id: widget.annonce.id,
                              title: _titleController.text,
                              description: _descriptionController.text,
                              price: double.parse(_priceController.text),
                              category: _category,
                              condition: _condition,
                              location: _locationController.text,
                              images: _images,
                            ),
                          );
                    }
                  },
                  child: const Text('Mettre à jour'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
