import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Événement: Inscription
class RegisterEvent extends AuthEvent {
  final String fullName;
  final String phone;
  final String password;
  final String? email;
  final String? role;

  const RegisterEvent({
    required this.fullName,
    required this.phone,
    required this.password,
    this.email,
    this.role,
  });

  @override
  List<Object?> get props => [fullName, phone, password, email, role];
}

// Événement: Connexion
class LoginEvent extends AuthEvent {
  final String identifier;
  final String password;

  const LoginEvent({
    required this.identifier,
    required this.password,
  });

  @override
  List<Object> get props => [identifier, password];
}

// Événement: Récupérer l'utilisateur actuel
class GetCurrentUserEvent extends AuthEvent {
  const GetCurrentUserEvent();
}

// Événement: Mettre à jour le profil
class UpdateProfileEvent extends AuthEvent {
  final String? fullName;
  final String? email;
  final String? location;

  const UpdateProfileEvent({
    this.fullName,
    this.email,
    this.location,
  });

  @override
  List<Object?> get props => [fullName, email, location];
}

// Événement: Vérifier le téléphone
class VerifyPhoneEvent extends AuthEvent {
  final String code;

  const VerifyPhoneEvent(this.code);

  @override
  List<Object> get props => [code];
}

// Événement: Renvoyer le code OTP
class ResendOtpEvent extends AuthEvent {
  const ResendOtpEvent();
}

// Événement: Déconnexion
class LogoutEvent extends AuthEvent {
  const LogoutEvent();
}

// Événement: Vérifier si l'utilisateur est connecté
class CheckAuthStatusEvent extends AuthEvent {
  const CheckAuthStatusEvent();
}