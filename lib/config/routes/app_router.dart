import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/authentification/presentation/pages/login_page.dart';
import '../../features/authentification/presentation/pages/register_page.dart';
import '../../features/authentification/presentation/pages/phone_verification_page.dart';
import '../../features/authentification/presentation/pages/otp_verification_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/home/presentation/pages/main_navigation_page.dart';
import '../../features/annonces/presentation/pages/annonces_list_page.dart';
import '../../features/annonces/presentation/pages/annonce_detail_page.dart';
import '../../features/annonces/presentation/pages/create_annonce_page.dart';
import '../../features/profile/presentation/pages/profil_page.dart';

class RouteNames {
  static const String login = 'login';
  static const String register = 'register';
  static const String phoneVerification = 'phone-verification';
  static const String otpVerification = 'otp-verification';
  static const String home = 'home';
  static const String mainNavigation = 'main-navigation';
  static const String annoncesList = 'annonces-list';
  static const String annonceDetail = 'annonce-detail';
  static const String createAnnonce = 'create-annonce';
  static const String profile = 'profile';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
// Authentication Routes
    GoRoute(
    path: '/login',
    name: RouteNames.login,
    builder: (context, state) => const LoginPage(),
  ),

  GoRoute(
  path: '/register',
  name: RouteNames.register,
  builder: (context, state) => const RegisterPage(),
  ),

  GoRoute(
  path: '/phone-verification',
  name: RouteNames.phoneVerification,
  builder: (context, state) => const PhoneVerificationPage(),
  ),

  GoRoute(
    path: '/otp-verification',
    name: RouteNames.otpVerification,
    builder: (context, state) {
      final phoneNumber = state.extra as String? ?? '';
      return OtpVerificationPage(phoneNumber: phoneNumber);
    },
  ),

  // Main Navigation avec Bottom Navigation Bar
  GoRoute(
  path: '/main',
  name: RouteNames.mainNavigation,
  builder: (context, state) => const MainNavigationPage(),
  ),

  // Home Routes
  GoRoute(
  path: '/home',
  name: RouteNames.home,
  builder: (context, state) => const HomePage(),
  ),

  // Annonces Routes
  GoRoute(
  path: '/annonces',
  name: RouteNames.annoncesList,
  builder: (context, state) => const AnnoncesListPage(),
  ),

  GoRoute(
  path: '/annonce/:id',
  name: RouteNames.annonceDetail,
  builder: (context, state) {
  final annonceId = state.pathParameters['id'] ?? '';
  return AnnonceDetailPage(annonceId: annonceId);
  },
  ),

  GoRoute(
  path: '/create-annonce',
  name: RouteNames.createAnnonce,
  builder: (context, state) => const CreateAnnoncePage(),
  ),

  // Profile Routes
  GoRoute(
  path: '/profile',
  name: RouteNames.profile,
  builder: (context, state) => const ProfilePage(),
  ),
  ],

// Configuration de la redirection si nécessaire
  redirect: (context, state) {
  // TODO: Implémenter la logique de redirection basée sur l'authentification
  // final isAuthenticated = ... récupérer depuis AuthBloc
  // if (!isAuthenticated && state.location != '/login' && state.location != '/register') {
  //   return '/login';
  // }
  return null;
  },

// Gestion des erreurs de navigation
  errorBuilder: (context, state) => Scaffold(
  body: Center(
  child: Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
  const Icon(
  Icons.error_outline,
  size: 80,
  color: Colors.red,
  ),
  const SizedBox(height: 16),
  Text(
  'Page non trouvée',
  style: Theme.of(context).textTheme.headlineMedium,
  ),
  const SizedBox(height: 16),
  ElevatedButton(
  onPressed: () => context.go('/login'),
  child: const Text('Retour à l\'accueil'),
  ),
  ],
  ),
  ),
  ),

  );
}