import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// Erreur serveur (500, etc.)
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

// Erreur réseau (pas de connexion)
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

// Erreur de cache/stockage local
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

// Erreur de validation (400, etc.)
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

// Erreur d'authentification (401, 403)
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

// Erreur non trouvée (404)
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}