import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AInchor News')),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
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
