import 'package:flutter/material.dart';
import 'package:secondmain_237/core/constants/app_colors.dart';
import 'package:secondmain_237/core/constants/app_strings.dart';
import 'package:secondmain_237/features/home/presentation/pages/home_page.dart';
import 'package:secondmain_237/features/annonces/presentation/pages/annonces_list_page.dart';
import 'package:secondmain_237/features/annonces/presentation/pages/create_annonce_page.dart';
import 'package:secondmain_237/features/profile/presentation/pages/profil_page.dart';
import 'package:secondmain_237/features/chat/presentation/pages/chat_list_page.dart';
import 'package:secondmain_237/core/network/socket_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondmain_237/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:secondmain_237/features/chat/presentation/bloc/chat_event.dart';
import 'package:secondmain_237/features/chat/presentation/bloc/chat_state.dart';
import 'package:secondmain_237/features/authentification/presentation/bloc/auth_bloc.dart';
import 'package:secondmain_237/features/authentification/presentation/bloc/auth_state.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({Key? key}) : super(key: key);

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const AnnoncesListPage(),
    // Placeholder pour l'index 2 (Vendre) qui ouvre une nouvelle page
    const SizedBox.shrink(),
    const ChatListPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    // Charger les conversations au démarrage pour avoir le badge
    context.read<ChatBloc>().add(LoadConversationsEvent());
    
    // Écouter les nouveaux messages globalement
    socketService.on('message:new', (data) {
      // Recharger les conversations pour mettre à jour le badge
      context.read<ChatBloc>().add(LoadConversationsEvent());
      
      // Afficher une notification in-app si on n'est pas sur l'onglet Messages
      if (_selectedIndex != 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Nouveau message reçu !'),
            action: SnackBarAction(
              label: 'Voir',
              onPressed: () {
                setState(() {
                  _selectedIndex = 3;
                });
              },
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.primary,
          ),
        );
      }
    });
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      // Si on clique sur "Vendre", on navigue vers la page de création
      //context.pushNamed(RouteNames.createAnnonce);
      // Utilisation du Navigator classique si GoRouter n'est pas dispo dans le contexte immédiat
      // ou context.push('/create-annonce');
      // Pour l'instant on suppose que GoRouter est configuré
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const CreateAnnoncePage())
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppColors.backgroundLight,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: AppStrings.home,
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view),
              label: AppStrings.annonces,
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              activeIcon: Icon(Icons.add_circle),
              label: 'Vendre',
            ),
            BottomNavigationBarItem(
              icon: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  int unreadCount = 0;
                  if (state is ConversationsLoaded) {
                    final authState = context.read<AuthBloc>().state;
                    final currentUserId = (authState is Authenticated) ? authState.user.id : -1;
                    
                    for (var c in state.conversations) {
                      if (c.user1Id == currentUserId) {
                        unreadCount += c.unreadForUser1;
                      } else {
                        unreadCount += c.unreadForUser2;
                      }
                    }
                  }
                  
                  return Stack(
                    children: [
                      const Icon(Icons.chat_bubble_outline),
                      if (unreadCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 14,
                              minHeight: 14,
                            ),
                            child: Text(
                              unreadCount > 99 ? '99+' : unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              activeIcon: const Icon(Icons.chat_bubble),
              label: 'Messages',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: AppStrings.profile,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            // Ouvrir la page de création en modal/stack
             Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CreateAnnoncePage())
            );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(
          Icons.add,
          color: AppColors.textWhite,
          size: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}