/// Constantes pour les appels API
import 'dart:io';

class ApiConstants {
  ApiConstants._();

  // URL de base de l'API
  // Pour Android Emulator: utilisez 10.0.2.2 au lieu de localhost
  // Pour appareil physique: utilisez l'IP de votre PC (ex: 192.168.1.X)
  // Pour Web/Chrome: utilisez localhost
  // URL de base de l'API
  // Pour production/physique: utilisez l'IP publique
  static const String baseUrl = 'http://31.97.159.174:4010/api';

  /*
  // Pour appareil physique (remplacez par votre IP locale)
  static const String baseUrl = 'http://192.168.1.X:3000/api';
  */

  // Alternative pour tester depuis un appareil physique
  // static const String baseUrl = 'http://192.168.1.X:3000/api';

  // Timeout des requêtes
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Endpoints Authentication
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String getMe = '/auth/me';
  static const String updateProfile = '/auth/profile';
  static const String verifyPhone = '/auth/verify-phone';
  static const String resendOtp = '/auth/resend-otp';

  // Endpoints Annonces
  static const String annonces = '/annonces';
  static String annonceById(int id) => '/annonces/$id';
  static String userAnnonces(int userId) => '/annonces/user/$userId';
  static const String myAnnonces = '/annonces/my/annonces';

  // Endpoints Favorites
  static const String favorites = '/favorites';
  static const String toggleFavorite = '/favorites/toggle';
  static String checkFavorite(int annonceId) => '/favorites/$annonceId/check';

  // Endpoints Chat
  static const String chatConversations = '/chat/conversations';
  static String chatMessages(int conversationId) =>
      '/chat/conversations/$conversationId/messages';
  static String chatMarkRead(int conversationId) =>
      '/chat/conversations/$conversationId/read';

  // Endpoints Orders & Payments
  static const String orders = '/orders';
  static const String myOrders = '/orders/my';
  static String orderById(int id) => '/orders/$id';
  static String orderCancel(int id) => '/orders/$id/cancel';
  static String initiatePay(int id) => '/payments/$id/initiate';
  static String orderStatus(int id) => '/payments/$id/status';

  // Socket base (même hôte que l'API sans /api)
  static const String socketBase = 'http://31.97.159.174:4010';

  // Headers
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
}
