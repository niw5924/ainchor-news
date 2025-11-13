import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'constants/app_colors.dart';
import 'utils/anchor_preloader.dart';
import 'utils/app_audio_player.dart';

class MainScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainScreen({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(switch (navigationShell.currentIndex) {
          0 => '뉴스 피드',
          1 => '카드를 눌러 앵커를 선택할 수 있어요',
          _ => 'AInchor News',
        }, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
        centerTitle: true,
        backgroundColor: AppColors.appBarBackground,
      ),
      backgroundColor: AppColors.scaffoldBackground,
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColors.bottomNavBackground,
        indicatorColor: AppColors.primary,
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (i) async {
          for (final input in AnchorPreloader.instance.talkingInputs.values) {
            input.value = false;
          }
          await AppAudioPlayer.instance.pause();
          navigationShell.goBranch(i);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            label: '뉴스',
          ),
          NavigationDestination(
            icon: Icon(Icons.record_voice_over_outlined),
            label: '앵커',
          ),
        ],
      ),
    );
  }
}
