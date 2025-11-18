import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../widgets/ainchor_list_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AinchorListTile(title: Text("뉴스 길이"), subtitle: Text("1줄")),
        Divider(color: AppColors.divider),
        AinchorListTile(title: Text("뉴스 길이"), subtitle: Text("2줄")),
        Divider(color: AppColors.divider),
        AinchorListTile(title: Text("뉴스 길이"), subtitle: Text("3줄")),
        Divider(color: AppColors.divider),
        AinchorListTile(title: Text("뉴스 길이"), subtitle: Text("4줄")),
        Divider(color: AppColors.divider),
        AinchorListTile(title: Text("뉴스 길이"), subtitle: Text("5줄")),
      ],
    );
  }
}
