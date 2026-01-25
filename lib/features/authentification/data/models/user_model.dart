import 'package:secondmain_237/features/authentification/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.fullName,
    super.email,
    required super.phone,
    required super.role,
    super.isVerified,
    super.avatar,
    super.location,
    super.isActive,
    super.createdAt,
  });

  // Créer un UserModel depuis JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      fullName: json['fullName'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String,
      role: json['role'] as String,
      isVerified: json['isVerified'] as bool? ?? false,
      avatar: json['avatar'] as String?,
      location: json['location'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
    );
  }

  // Convertir UserModel en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'role': role,
      'isVerified': isVerified,
      'avatar': avatar,
      'location': location,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // Créer une copie avec des modifications
  UserModel copyWith({
    int? id,
    String? fullName,
    String? email,
    String? phone,
    String? role,
    bool? isVerified,
    String? avatar,
    String? location,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      avatar: avatar ?? this.avatar,
      location: location ?? this.location,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// Modèle de réponse d'authentification
class AuthResponse {
  final UserModel user;
  final String token;

  const AuthResponse({
    required this.user,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
    };
  }
}