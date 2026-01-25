import 'package:flutter/material.dart';
//import 'package:secondmain_237/core/constants/app_colors.dart';
//import 'package:secondmain_237/features/profile/presentation/pages/profil_page.dart';

class AnnonceDetailPage extends StatelessWidget {
  final String annonceId;

  const AnnonceDetailPage({
    Key? key,
    required this.annonceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de l\'annonce'),
      ),
      body: Center(
        child: Text(
          'Page de détails pour l\'annonce: $annonceId',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}