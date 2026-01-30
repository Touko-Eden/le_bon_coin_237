import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:secondmain_237/core/constants/app_colors.dart';
import 'package:secondmain_237/core/constants/app_strings.dart';
import 'package:secondmain_237/features/authentification/presentation/widgets/custom_button.dart';

import 'package:secondmain_237/features/authentification/presentation/bloc/auth_bloc.dart';
import 'package:secondmain_237/features/authentification/presentation/bloc/auth_event.dart';
import 'package:secondmain_237/features/authentification/presentation/bloc/auth_state.dart';
import 'dart:async';



class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationPage({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<OtpVerificationPage> createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _canResend = false;
  int _resendTimer = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendTimer = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  void _handleVerify() async {
    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer un code valide à 6 chiffres'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

// TODO: Implémenter la vérification OTP avec BLoC
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

// TODO: Navigation vers l'écran suivant après succès
    print('Code OTP vérifié: ${_otpController.text}');

  }

  void _handleResendCode() {
    if (!_canResend) return;

// TODO: Implémenter le renvoi du code OTP
    print('Renvoi du code OTP');
    _startResendTimer();

    ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
    content: Text('Un nouveau code a été envoyé'),
    backgroundColor: AppColors.success,
    ),
    );

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
          children: [
            const SizedBox(height: 32),

            // Icône
            _buildIcon(),

            const SizedBox(height: 32),

            // Titre
            Text(
              AppStrings.verifyPhone,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            // Sous-titre avec numéro de téléphone
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                children: [
                  const TextSpan(text: '${AppStrings.otpSent}\n'),
                  TextSpan(
                    text: widget.phoneNumber,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Champs OTP
            _buildOtpFields(),

            const SizedBox(height: 32),

            // Bouton Vérifier
            CustomButton(
              text: AppStrings.verify,
              onPressed: _handleVerify,
              isLoading: _isLoading,
            ),

            const SizedBox(height: 24),

            // Renvoyer le code
            _buildResendSection(),
          ],
        ),
      ),
    ),
    ),
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
        widthFactor: 0.6, // 60% de progression (étape 3/5)
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          Icons.phone_android,
          size: 50,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildOtpFields() {
    return PinCodeTextField(
      appContext: context,
      length: 6,
      controller: _otpController,
      keyboardType: TextInputType.number,
      animationType: AnimationType.fade,
      pinTheme: PinTheme(
        shape: PinCodeFieldShape.box,
        borderRadius: BorderRadius.circular(12),
        fieldHeight: 56,
        fieldWidth: 48,
        activeFillColor: AppColors.backgroundLight,
        selectedFillColor: AppColors.backgroundLight,
        inactiveFillColor: AppColors.backgroundLight,
        activeColor: AppColors.primary,
        selectedColor: AppColors.primary,
        inactiveColor: AppColors.inputBorder,
      ),
      cursorColor: AppColors.primary,
      animationDuration: const Duration(milliseconds: 300),
      enableActiveFill: true,
      onCompleted: (code) {
// Vérifier automatiquement quand tous les chiffres sont entrés
        _handleVerify();
      },
      onChanged: (value) {},
    );
  }

  Widget _buildResendSection() {
    return Column(
        children: [
    Text(
    'Vous n‘avez pas reçu le code ?',
    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: AppColors.textSecondary,
    ),
    ),
    const SizedBox(height: 8),
    TextButton(
    onPressed: _canResend ? _handleResendCode : null,
    child: Text(
    _canResend
    ? AppStrings.resendCode
        : 'Renvoyer dans ${_resendTimer}s',
    style: TextStyle(
    color: _canResend ? AppColors.primary : AppColors.textHint,
    fontWeight: FontWeight.w600,
    ),
    ),
    ),
    ],
    );
  }
}