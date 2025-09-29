import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'constants/app_colors.dart';

class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AInchor News'),
        backgroundColor: AppColors.appBarBackground,
      ),
      backgroundColor: AppColors.scaffoldBackground,
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.bottomNavBackground,
        indicatorColor: AppColors.primary,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (i) => navigationShell.goBranch(i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            label: '뉴스',
          ),
          NavigationDestination(
            icon: Icon(Icons.face_6_outlined),
            label: '아바타',
          ),
        ],
      ),
    );
  }
}
