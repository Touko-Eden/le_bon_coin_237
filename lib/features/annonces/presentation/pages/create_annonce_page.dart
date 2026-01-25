import 'package:flutter/material.dart';
//import 'package:secondmain_237/core/constants/app_colors.dart';

class CreateAnnoncePage extends StatelessWidget {
  const CreateAnnoncePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Créer une annonce'),
      ),
      body: const Center(
        child: Text('Formulaire de création d\'annonce'),
      ),
    );
  }
}