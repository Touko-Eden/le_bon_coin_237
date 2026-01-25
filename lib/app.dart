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

class SecondMainApp extends StatelessWidget {
  const SecondMainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialiser les dépendances
    final dioClient = DioClient();
    final storage = const FlutterSecureStorage();

    final authLocalDataSource = AuthLocalDataSourceImpl(storage: storage);
    final authRemoteDataSource = AuthRemoteDataSourceImpl(dioClient: dioClient);

    final authRepository = AuthRepositoryImpl(
      remoteDataSource: authRemoteDataSource,
      localDataSource: authLocalDataSource,
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(authRepository: authRepository)
            ..add(const CheckAuthStatusEvent()),
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