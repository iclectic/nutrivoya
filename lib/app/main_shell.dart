import 'package:flutter/material.dart';

import '../../shared/extensions/app_localizations_x.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/diary/diary_screen.dart';
import '../../features/food_search/food_search_screen.dart';
import '../../features/settings/settings_screen.dart';

/// Root scaffold with bottom navigation hosting the four main tabs.
class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index = widget.currentIndex.clamp(0, 3);

  static const _screens = <Widget>[
    DashboardScreen(),
    DiaryScreen(),
    FoodSearchScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.today_outlined),
            selectedIcon: const Icon(Icons.today),
            label: l10n.navDashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book),
            label: l10n.navDiary,
          ),
          NavigationDestination(
            icon: const Icon(Icons.search),
            selectedIcon: const Icon(Icons.search),
            label: l10n.navSearch,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l10n.navSettings,
          ),
        ],
      ),
    );
  }
}
