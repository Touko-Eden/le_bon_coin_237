import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(const AuthInitial()) {
    // Gérer l'événement d'inscription
    on<RegisterEvent>(_onRegister);

    // Gérer l'événement de connexion
    on<LoginEvent>(_onLogin);

    // Gérer l'événement de récupération de l'utilisateur actuel
    on<GetCurrentUserEvent>(_onGetCurrentUser);

    // Gérer l'événement de mise à jour du profil
    on<UpdateProfileEvent>(_onUpdateProfile);

    // Gérer l'événement de vérification du téléphone
    on<VerifyPhoneEvent>(_onVerifyPhone);

    // Gérer l'événement de renvoi du code OTP
    on<ResendOtpEvent>(_onResendOtp);

    // Gérer l'événement de déconnexion
    on<LogoutEvent>(_onLogout);

    // Gérer l'événement de vérification du statut d'authentification
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
  }

  // Handler: Inscription
  Future<void> _onRegister(
      RegisterEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await authRepository.register(
      fullName: event.fullName,
      phone: event.phone,
      password: event.password,
      email: event.email,
      role: event.role,
    );

    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (user) => emit(Authenticated(user)),
    );
  }

  // Handler: Connexion
  Future<void> _onLogin(
      LoginEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await authRepository.login(
      identifier: event.identifier,
      password: event.password,
    );

    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (user) => emit(Authenticated(user)),
    );
  }

  // Handler: Récupérer l'utilisateur actuel
  Future<void> _onGetCurrentUser(
      GetCurrentUserEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await authRepository.getCurrentUser();

    result.fold(
          (failure) => emit(const Unauthenticated()),
          (user) => emit(Authenticated(user)),
    );
  }

  // Handler: Mettre à jour le profil
  Future<void> _onUpdateProfile(
      UpdateProfileEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await authRepository.updateProfile(
      fullName: event.fullName,
      email: event.email,
      location: event.location,
    );

    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (user) => emit(ProfileUpdated(user)),
    );
  }

  // Handler: Vérifier le téléphone
  Future<void> _onVerifyPhone(
      VerifyPhoneEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await authRepository.verifyPhone(event.code);

    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (_) => emit(const PhoneVerified()),
    );
  }

  // Handler: Renvoyer le code OTP
  Future<void> _onResendOtp(
      ResendOtpEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await authRepository.resendOtp();

    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (otp) => emit(OtpResent(otp)),
    );
  }

  // Handler: Déconnexion
  Future<void> _onLogout(
      LogoutEvent event,
      Emitter<AuthState> emit,
      ) async {
    emit(const AuthLoading());

    final result = await authRepository.logout();

    result.fold(
          (failure) => emit(AuthError(failure.message)),
          (_) => emit(const Unauthenticated()),
    );
  }

  // Handler: Vérifier le statut d'authentification
  Future<void> _onCheckAuthStatus(
      CheckAuthStatusEvent event,
      Emitter<AuthState> emit,
      ) async {
    final isLoggedIn = await authRepository.isLoggedIn();

    if (isLoggedIn) {
      add(const GetCurrentUserEvent());
    } else {
      emit(const Unauthenticated());
    }
  }
}