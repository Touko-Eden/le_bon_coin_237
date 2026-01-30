/*import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text("Formulaire de création de compte"),
              const SizedBox(height: 20), // Utilise le vrai SizedBox de Flutter
              ElevatedButton(
                onPressed: () {
                  // Ta logique de validation ici
                },
                child: const Text("S'inscrire"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondmain_237/core/constants/app_colors.dart';
import 'package:secondmain_237/core/constants/app_strings.dart';
import 'package:secondmain_237/features/authentification/presentation/widgets/custom_text_field.dart';
import 'package:secondmain_237/features/authentification/presentation/widgets/custom_button.dart';
import 'package:secondmain_237/features/authentification/presentation/widgets/google_sign_in_button.dart';

import 'package:secondmain_237/features/authentification/presentation/bloc/auth_bloc.dart';
import 'package:secondmain_237/features/authentification/presentation/bloc/auth_event.dart';
import 'package:secondmain_237/features/authentification/presentation/bloc/auth_state.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        RegisterEvent(
          fullName: _fullNameController.text,
          phone: _phoneController.text,
          password: _passwordController.text,
          email: _emailController.text.isNotEmpty ? _emailController.text : null,
          role: 'vendeur',
        ),
      );
    }
  }

  void _handleGoogleSignIn() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connexion Google - Fonctionnalité à venir'),
        backgroundColor: AppColors.info,
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
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Inscription réussie ! Bienvenue 🎉'),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.of(context).pushReplacementNamed('/main');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SafeArea(
              child: Column(
                children: [
                  _buildProgressIndicator(),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 32),

                          Text(
                            AppStrings.connectOrCreate,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 32),

                          _buildRegistrationForm(isLoading),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
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
        widthFactor: 0.2,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildRegistrationForm(bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: _fullNameController,
            label: '${AppStrings.fullName} *',
            hint: 'Votre nom complet',
            prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
            keyboardType: TextInputType.name,
            enabled: !isLoading,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.nameRequired;
              }
              if (value.length < 2) {
                return 'Le nom doit contenir au moins 2 caractères';
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          CustomTextField(
            controller: _phoneController,
            label: '${AppStrings.phoneNumber} *',
            hint: '+237690000000',
            prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.primary),
            keyboardType: TextInputType.phone,
            enabled: !isLoading,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.phoneRequired;
              }
              if (!value.startsWith('+237')) {
                return 'Le numéro doit commencer par +237';
              }
              if (value.length < 13) {
                return AppStrings.phoneInvalid;
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          CustomTextField(
            controller: _emailController,
            label: AppStrings.email,
            hint: 'exemple@email.com (optionnel)',
            prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
            keyboardType: TextInputType.emailAddress,
            enabled: !isLoading,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return AppStrings.emailInvalid;
                }
              }
              return null;
            },
          ),

          const SizedBox(height: 16),

          CustomTextField(
            controller: _passwordController,
            label: '${AppStrings.password} *',
            hint: 'Au moins 6 caractères',
            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: AppColors.textHint,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            obscureText: _obscurePassword,
            enabled: !isLoading,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return AppStrings.passwordRequired;
              }
              if (value.length < 6) {
                return AppStrings.passwordTooShort;
              }
              return null;
            },
          ),

          const SizedBox(height: 24),

          CustomButton(
            text: AppStrings.continueText,
            onPressed: isLoading ? () {} : _handleContinue,
            backgroundColor: AppColors.secondary,
            isLoading: isLoading,
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  AppStrings.or,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),

          const SizedBox(height: 24),

          GoogleSignInButton(
            onPressed: isLoading ? () {} : _handleGoogleSignIn,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}


/*class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_formKey.currentState!.validate()) {
      // Déclencher l'événement d'inscription
      context.read<AuthBloc>().add(
        RegisterEvent(
          fullName: _fullNameController.text,
          phone: _phoneController.text,
          password: _passwordController.text,
          email: _emailController.text.isNotEmpty ? _emailController.text : null,
          role: 'vendeur',
        ),
      );
    }
  }

  void _handleGoogleSignIn() {
    // TODO: Implémenter la connexion Google
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connexion Google - Fonctionnalité à venir'),
        backgroundColor: AppColors.info,
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
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Inscription réussie, naviguer vers l'écran principal
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Inscription réussie ! Bienvenue 🎉'),
                backgroundColor: AppColors.success,
              ),
            );
            context.go('/main');
          } else if (state is AuthError) {
            // Afficher l'erreur
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;

            return SafeArea(
              child: Column(
                children: [
                  _buildProgressIndicator(),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          _buildIllustrationsGrid(),

                          const SizedBox(height: 32),

                          Text(
                            AppStrings.connectOrCreate,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 32),

                          _buildRegistrationForm(isLoading),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
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
        widthFactor: 0.2, // 20% de progression (étape 1/5)
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildIllustrationsGrid() {
    final illustrations = [
      _IllustrationCard(
        color: AppColors.illustrationBlue,
        icon: Icons.credit_card_outlined,
        position: 'topLeft',
      ),
      _IllustrationCard(
        color: AppColors.illustrationYellow,
        icon: Icons.chair_outlined,
        position: 'topRight',
        showFavorite: true,
      ),
      _IllustrationCard(
        color: AppColors.illustrationPeach,
        icon: Icons.toys_outlined,
        position: 'middleLeft',
        showFavorite: true,
      ),
      _IllustrationCard(
        color: AppColors.illustrationBlue,
        icon: Icons.work_outline,
        position: 'middleRight',
        showFavorite: true,
        showPause: true,
      ),
      _IllustrationCard(
        color: AppColors.illustrationPink,
        icon: Icons.directions_car_outlined,
        position: 'bottomLeft',
        showFavorite: true,
      ),
    ];

    return SizedBox(
      height: 300,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1,
        ),
        itemCount: 5,
        itemBuilder: (context, index) {
          return illustrations[index];
        },
      ),
    );
  }

  Widget _buildRegistrationForm(bool isLoading) {
    return Form(
        key: _formKey,
        child: Column(
        children: [
        // Champ Nom complet
        CustomTextField(
        controller: _fullNameController,
        label: '${AppStrings.fullName} *',
        hint: 'Votre nom complet',
        prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
    keyboardType: TextInputType.name,
    enabled: !isLoading,
    validator: (value) {
    if (value == null || value.isEmpty) {
    return AppStrings.nameRequired;
    }
    if (value.length < 2) {
    return 'Le nom doit contenir au moins 2 caractères';
    }
    return null;
    },
    ),

    const SizedBox(height: 16),

    // Champ Téléphone
    CustomTextField(
    controller: _phoneController,
    label: '${AppStrings.phoneNumber} *',
    hint: '+237690000000',
    prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.primary),
    keyboardType: TextInputType.phone,
    enabled: !isLoading,
    validator: (value) {
    if (value == null || value.isEmpty) {
    return AppStrings.phoneRequired;
    }
    if (!value.startsWith('+237')) {
    return 'Le numéro doit commencer par +237';
    }
    if (value.length < 13) {
    return AppStrings.phoneInvalid;
    }
    return null;
    },
    ),

    const SizedBox(height: 16),

    // Champ Email (optionnel)
    CustomTextField(
    controller: _emailController,
    label: AppStrings.email,
    hint: 'exemple@email.com (optionnel)',
    prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
    keyboardType: TextInputType.emailAddress,
    enabled: !isLoading,
    validator: (value) {
    if (value != null && value.isNotEmpty) {
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}
    }

    class _IllustrationCard extends StatelessWidget {
    final Color color;
    final IconData icon;
    final String position;
    final bool showFavorite;
    final bool showPause;

    const _IllustrationCard({
    required this.color,
    required this.icon,
    required this.position,
    this.showFavorite = false,
    this.showPause = false,
    });

    @override
    Widget build(BuildContext context) {
    return Container(
    decoration: BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(16),
    ),
    child: Stack(
    children: [
    // Icône principale
    Center(
    child: Icon(
    icon,
    size: 60,
    color: _getIconColor(),
    ),
    ),

    // Icône Favori
    if (showFavorite)
    Positioned(
    top: 12,
    right: 12,
    child: Container(
    padding: const EdgeInsets.all(6),
    decoration: const BoxDecoration(
    color: AppColors.white,
    shape: BoxShape.circle,
    ),
    child: const Icon(
    Icons.favorite_border,
    size: 16,
    color: AppColors.textSecondary,
    ),
    ),
    ),

    // Icône Pause
    if (showPause)
    Positioned(
    bottom: 12,
    right: 12,
    child: Container(
    padding: const EdgeInsets.all(8),
    decoration: const BoxDecoration(
    color: AppColors.white,
    shape: BoxShape.circle,
    ),
    child: const Icon(
    Icons.pause,
    size: 20,
    color: AppColors.textPrimary,
    ),
    ),
    ),
    ],
    ),
    );
    }

    Color _getIconColor() {
    if (color == AppColors.illustrationYellow) {
    return const Color(0xFFFBC02D);
    } else if (color == AppColors.illustrationPink) {
    return const Color(0xFFE91E63);
    } else if (color == AppColors.illustrationBlue) {
    return const Color(0xFF03A9F4);
    } else if (color == AppColors.illustrationPeach) {
    return const Color(0xFFFF6F00);
    }
    return AppColors.textPrimary;
    }
    }
    ).hasMatch(value)) {
    return AppStrings.emailInvalid;
    }
    }
    return null;
  },
  ),

  const SizedBox(height: 16),

  // Champ Mot de passe
  CustomTextField(
  controller: _passwordController,
  label: '${AppStrings.password} *',
  hint: 'Au moins 6 caractères',
  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
  suffixIcon: IconButton(
  icon: Icon(
  _obscurePassword
  ? Icons.visibility_off_outlined
      : Icons.visibility_outlined,
  color: AppColors.textHint,
  ),
  onPressed: () {
  setState(() {
  _obscurePassword = !_obscurePassword;
  });
  },
  ),
  obscureText: _obscurePassword,
  enabled: !isLoading,
  validator: (value) {
  if (value == null || value.isEmpty) {
  return AppStrings.passwordRequired;
  }
  if (value.length < 6) {
  return AppStrings.passwordTooShort;
  }
  return null;
  },
  ),

  const SizedBox(height: 24),

  // Bouton Continuer
  CustomButton(
  text: AppStrings.continueText,
  onPressed: isLoading ? () {} : _handleContinue,
  backgroundColor: AppColors.secondary,
  isLoading: isLoading,
  ),

  const SizedBox(height: 24),

  // Séparateur "Ou"
  Row(
  children: [
  const Expanded(child: Divider()),
  Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16),
  child: Text(
  AppStrings.or,
  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
  color: AppColors.textSecondary,
  ),
  ),
  ),
  const Expanded(child: Divider()),
  ],
  ),

  const SizedBox(height: 24),

  // Bouton Google Sign In
  GoogleSignInButton(
  onPressed: isLoading ? () {} : _handleGoogleSignIn,
  isLoading: isLoading,
  ),
  ],
  ),
  );
}
}

class _IllustrationCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String position;
  final bool showFavorite;
  final bool showPause;

  const _IllustrationCard({
    required this.color,
    required this.icon,
    required this.position,
    this.showFavorite = false,
    this.showPause = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Icône principale
          Center(
            child: Icon(
              icon,
              size: 60,
              color: _getIconColor(),
            ),
          ),

          // Icône Favori
          if (showFavorite)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_border,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            ),

          // Icône Pause
          if (showPause)
            Positioned(
              bottom: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.pause,
                  size: 20,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getIconColor() {
    if (color == AppColors.illustrationYellow) {
      return const Color(0xFFFBC02D);
    } else if (color == AppColors.illustrationPink) {
      return const Color(0xFFE91E63);
    } else if (color == AppColors.illustrationBlue) {
      return const Color(0xFF03A9F4);
    } else if (color == AppColors.illustrationPeach) {
      return const Color(0xFFFF6F00);
    }
    return AppColors.textPrimary;
  }
}*/