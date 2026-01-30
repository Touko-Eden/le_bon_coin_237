/// Constantes pour les appels API
import 'dart:io';
class ApiConstants {
  ApiConstants._();

  // URL de base de l'API
  // Pour Android Emulator: utilisez 10.0.2.2 au lieu de localhost
  // Pour appareil physique: utilisez l'IP de votre PC (ex: 192.168.1.X)
  // Pour Web/Chrome: utilisez localhost
  static String get baseUrl {
    if (Platform.isAndroid) {
      // Si tu branches ton tel, mets l'IP. Si c'est l'émeu, mets 10.0.2.2
      return 'http://192.168.100.134:3000/api';
    }
    return 'http://10.0.2.2:3000/api';
  }

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

  // Headers
  static const String contentType = 'application/json';
  static const String authorization = 'Authorization';
  static const String bearer = 'Bearer';
}