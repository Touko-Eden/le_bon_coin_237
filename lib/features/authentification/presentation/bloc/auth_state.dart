import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

// État initial
class AuthInitial extends AuthState {
  const AuthInitial();
}

// État de chargement
class AuthLoading extends AuthState {
  const AuthLoading();
}

// État: Utilisateur authentifié
class Authenticated extends AuthState {
  final User user;

  const Authenticated(this.user);

  @override
  List<Object> get props => [user];
}

// État: Non authentifié
class Unauthenticated extends AuthState {
  const Unauthenticated();
}

// État: Erreur
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}

// État: Téléphone vérifié avec succès
class PhoneVerified extends AuthState {
  const PhoneVerified();
}

// État: OTP renvoyé avec succès
class OtpResent extends AuthState {
  final String otp; // En dev seulement

  const OtpResent(this.otp);

  @override
  List<Object> get props => [otp];
}

// État: Profil mis à jour avec succès
class ProfileUpdated extends AuthState {
  final User user;

  const ProfileUpdated(this.user);

  @override
  List<Object> get props => [user];
}