import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAuthToken(String token);
  Future<String?> getAuthToken();
  Future<void> deleteAuthToken();

  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> deleteUser();

  Future<void> clearAll();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage storage;

  static const String _authTokenKey = 'auth_token';
  static const String _userDataKey = 'user_data';

  AuthLocalDataSourceImpl({required this.storage});

  @override
  Future<void> saveAuthToken(String token) async {
    await storage.write(key: _authTokenKey, value: token);
  }

  @override
  Future<String?> getAuthToken() async {
    return await storage.read(key: _authTokenKey);
  }

  @override
  Future<void> deleteAuthToken() async {
    await storage.delete(key: _authTokenKey);
  }

  @override
  Future<void> saveUser(UserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await storage.write(key: _userDataKey, value: userJson);
  }

  @override
  Future<UserModel?> getUser() async {
    final userJson = await storage.read(key: _userDataKey);
    if (userJson != null) {
      try {
        final Map<String, dynamic> userMap = jsonDecode(userJson);
        return UserModel.fromJson(userMap);
      } catch (e) {
        print('Erreur lors de la lecture des données utilisateur: $e');
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> deleteUser() async {
    await storage.delete(key: _userDataKey);
  }

  @override
  Future<void> clearAll() async {
    await deleteAuthToken();
    await deleteUser();
  }
}