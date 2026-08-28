import 'package:flutter/material.dart';

import '../features/dashboard/screen/dashboard_screen.dart';
import '../features/exams/screen/exams_screen.dart';
import '../features/notes/screen/notes_screen.dart';
import '../features/profile/screen/profile_screen.dart';
import '../features/sgpa/screen/sgpa_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key});

  @override
  State<BottomNavScreen> createState() =>
      _BottomNavScreenState();
}

class _BottomNavScreenState
    extends State<BottomNavScreen> {
  int selectedIndex = 0;

  void changeTab(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme =
        Theme.of(context).colorScheme;

    final screens = [
      DashboardScreen(
        onNavigate: changeTab,
      ),
      const SgpaScreen(),
      const ExamsScreen(),
      const NotesScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[selectedIndex],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context)
              .cardTheme
              .color,
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, -4),
              color: colorScheme.onSurface
                  .withOpacity(0.06),
            ),
          ],
        ),

        child: NavigationBar(
          selectedIndex: selectedIndex,
          backgroundColor:
          Theme.of(context).cardTheme.color,
          indicatorColor:
          colorScheme.primary.withOpacity(0.16),
          labelBehavior:
          NavigationDestinationLabelBehavior
              .alwaysShow,

          onDestinationSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
          },

          destinations: const [
            NavigationDestination(
              selectedIcon: Icon(Icons.home),
              icon: Icon(Icons.home_outlined),
              label: 'Home',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.calculate),
              icon: Icon(Icons.calculate_outlined),
              label: 'SGPA',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.calendar_month),
              icon: Icon(Icons.calendar_month_outlined),
              label: 'Exams',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.menu_book),
              icon: Icon(Icons.menu_book_outlined),
              label: 'Notes',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.person),
              icon: Icon(Icons.person_outline),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}