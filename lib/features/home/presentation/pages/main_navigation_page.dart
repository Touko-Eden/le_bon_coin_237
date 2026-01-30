import 'package:flutter/material.dart';
import 'package:secondmain_237/core/constants/app_colors.dart';
import 'package:secondmain_237/core/constants/app_strings.dart';
import 'package:secondmain_237/features/home/presentation/pages/home_page.dart';
import 'package:secondmain_237/features/annonces/presentation/pages/annonces_list_page.dart';
import 'package:secondmain_237/features/annonces/presentation/pages/create_annonce_page.dart';
import 'package:secondmain_237/features/profile/presentation/pages/profil_page.dart';

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
    const ProfilePage(),
  ];

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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: AppStrings.home,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view),
              label: AppStrings.annonces,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              activeIcon: Icon(Icons.add_circle),
              label: 'Vendre',
            ),
            BottomNavigationBarItem(
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