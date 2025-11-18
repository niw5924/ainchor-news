import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../widgets/ainchor_list_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const AinchorListTile(title: Text("뉴스 길이"), subtitle: Text("1줄")),
          const Divider(color: AppColors.divider),
          const AinchorListTile(title: Text("뉴스 길이"), subtitle: Text("2줄")),
          const Divider(color: AppColors.divider),
          const AinchorListTile(title: Text("뉴스 길이"), subtitle: Text("3줄")),
          const Divider(color: AppColors.divider),
          const AinchorListTile(title: Text("뉴스 길이"), subtitle: Text("4줄")),
          const Divider(color: AppColors.divider),
          const AinchorListTile(
            title: Text("뉴스 길이"),
            subtitle: Text("5줄"),
            showTrailing: false,
          ),
          const Divider(color: AppColors.divider),
          const AinchorListTile(title: Text("뉴스 길이"), subtitle: Text("6줄")),
          const Divider(color: AppColors.divider),
          const AinchorListTile(title: Text("뉴스 길이"), subtitle: Text("7줄")),
          const Divider(color: AppColors.divider),
          const AinchorListTile(title: Text("뉴스 길이"), subtitle: Text("8줄")),
          const Divider(color: AppColors.divider),
          const AinchorListTile(title: Text("뉴스 길이"), subtitle: Text("9줄")),
          const Divider(color: AppColors.divider),
          AinchorListTile(
            title: const Text("오픈소스 라이선스"),
            onTap: () {
              showLicensePage(context: context, useRootNavigator: true);
            },
          ),
        ],
      ),
    );
  }
}
