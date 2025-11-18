import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'constants/app_colors.dart';

/// 현재 탭 인덱스 브로드캐스트(탭 변경 알림)
/// 이유: IndexedStack이 dispose를 안 해서 비활성 탭에서도 재생이 계속됨 → 탭 전환 신호로 즉시 pause하기 위함
final ValueNotifier<int> shellIndex = ValueNotifier<int>(0);

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
          2 => '설정',
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
        onDestinationSelected: (i) {
          shellIndex.value = i;
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
          NavigationDestination(icon: Icon(Icons.settings), label: '설정'),
        ],
      ),
    );
  }
}
