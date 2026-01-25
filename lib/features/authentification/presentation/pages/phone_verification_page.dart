import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:secondmain_237/core/constants/app_colors.dart';
import 'package:secondmain_237/core/constants/app_strings.dart';
import 'package:secondmain_237/features/authentification/presentation/widgets/custom_button.dart';

class PhoneVerificationPage extends StatefulWidget {
  const PhoneVerificationPage({Key? key}) : super(key: key);

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _selectedCountryCode = '+237'; // Code du Cameroun par défaut
  bool _showMoreInfo = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
// TODO: Envoyer le code OTP et naviguer vers la page de vérification OTP
      print('Téléphone: $_selectedCountryCode${_phoneController.text}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
// Retour à l’écran d’accueil ou de connexion
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: SafeArea(
          child: Column(
              children: [
// Barre de progression
              _buildProgressIndicator(),

      Expanded(
      child: SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Titre
            Text(
              AppStrings.secureAccount,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // Sous-titre / Description
            Text(
              AppStrings.phoneVerificationSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 32),

            // Champ Téléphone avec sélecteur de pays
            _buildPhoneField(),

            const SizedBox(height: 24),

            // Lien "En savoir plus"
            _buildLearnMoreButton(),

            // Section dépliable "En savoir plus"
            if (_showMoreInfo) _buildMoreInfoSection(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    ),
    ),

    // Bouton Continuer fixé en bas
    _buildBottomSection(),
    ],
    ),
    ),
    );

  }

  Widget _buildProgressIndicator() {
    return Container(
      height: 4,
      decoration: const BoxDecoration(
        color: AppColors.greyLight,
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: 0.4, // 40% de progression (étape 2/5)
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return IntlPhoneField(
      controller: _phoneController,
      decoration: InputDecoration(
        labelText: AppStrings.phoneNumber,
        filled: true,
        fillColor: AppColors.backgroundLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.inputBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.inputBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.inputBorderFocused,
            width: 2,
          ),
        ),
      ),
      initialCountryCode: 'CM', // Cameroun
      onChanged: (phone) {
        _selectedCountryCode = phone.countryCode;
      },
      validator: (phone) {
        if (phone == null || phone.number.isEmpty) {
          return AppStrings.phoneRequired;
        }
        if (phone.number.length < 9) {
          return AppStrings.phoneInvalid;
        }
        return null;
      },
    );
  }

  Widget _buildLearnMoreButton() {
    return InkWell(
      onTap: () {
        setState(() {
          _showMoreInfo = !_showMoreInfo;
        });
      },
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Text(
            AppStrings.learnMore,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreInfoSection() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.greyLight,
        ),
      ),
      child: Text(
        AppStrings.dataProcessingInfo,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomButton(
            text: AppStrings.continueText,
            onPressed: _handleContinue,
            backgroundColor: AppColors.secondary,
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.dataProcessingInfo,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}