import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:secondmain_237/core/constants/app_colors.dart';
import 'package:secondmain_237/core/constants/app_strings.dart';
import 'package:secondmain_237/features/authentification/presentation/bloc/auth_bloc.dart';
import 'package:secondmain_237/features/authentification/presentation/bloc/auth_event.dart';
import 'package:secondmain_237/features/authentification/presentation/bloc/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profile),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          String fullName = 'Utilisateur';
          String email = 'utilisateur@email.com';

          if (state is Authenticated) {
            fullName = state.user.fullName;
            email = state.user.email ?? state.user.phone;
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primary,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                fullName,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                email,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ListTile(
                leading: const Icon(Icons.list_alt, color: AppColors.primary),
                title: const Text(AppStrings.myAnnonces),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.push('/my-annonces');
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.favorite, color: AppColors.primary),
                title: const Text(AppStrings.favorites),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.push('/favorites');
                },
              ),
              const Divider(),
              ListTile(
                leading:
                    const Icon(Icons.receipt_long, color: AppColors.primary),
                title: const Text('Mes commandes'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  context.push('/my-orders');
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings, color: AppColors.primary),
                title: const Text(AppStrings.settings),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {},
              ),
              const Divider(),
              const SizedBox(height: 32),
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.error),
                title: const Text(
                  AppStrings.logout,
                  style: TextStyle(color: AppColors.error),
                ),
                onTap: () {
                  context.read<AuthBloc>().add(LogoutEvent());
                  context.go('/login');
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
