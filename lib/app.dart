import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:secondmain_237/core/theme/app_theme.dart';
import 'package:secondmain_237/core/network/dio_client.dart';
import 'package:secondmain_237/config/routes/app_router.dart';
import 'package:secondmain_237/features/authentification/data/datasources/auth_local_datasource.dart';
import 'package:secondmain_237/features/authentification/data/datasources/auth_remote_datasource.dart';
import 'package:secondmain_237/features/authentification/data/repositories/auth_repository_impl.dart';
import 'package:secondmain_237/features/authentification/presentation/bloc/auth_bloc.dart';
import 'package:secondmain_237/features/authentification/presentation/bloc/auth_event.dart';
import 'package:secondmain_237/features/annonces/data/datasources/annonce_remote_datasource.dart';
import 'package:secondmain_237/features/annonces/data/repositories/annonce_repository_impl.dart';
import 'package:secondmain_237/features/annonces/presentation/bloc/annonce_bloc.dart';


class SecondMainApp extends StatelessWidget {
  const SecondMainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialiser les dépendances
    final dioClient = DioClient();
    const storage = FlutterSecureStorage();

    final authLocalDataSource = AuthLocalDataSourceImpl(storage: storage);
    final authRemoteDataSource = AuthRemoteDataSourceImpl(dioClient: dioClient);

    final authRepository = AuthRepositoryImpl(
      remoteDataSource: authRemoteDataSource,
      localDataSource: authLocalDataSource,
    );

    // Initialiser les dépendances Annonces
    final annonceRemoteDataSource = AnnonceRemoteDataSourceImpl(dioClient: dioClient);
    final annonceRepository = AnnonceRepositoryImpl(remoteDataSource: annonceRemoteDataSource);

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: authRepository)
            ..add(const CheckAuthStatusEvent()),
        ),
        BlocProvider<AnnonceBloc>(
          create: (context) => AnnonceBloc(annonceRepository: annonceRepository),
        ),
      ],
      child: MaterialApp.router(
        title: 'SecondMain 237',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}