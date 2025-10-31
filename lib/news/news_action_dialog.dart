import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/news_action_enums.dart';
import '../utils/app_prefs.dart';

class NewsActionDialog extends StatelessWidget {
  const NewsActionDialog({super.key, required this.title, required this.host});

  final String title;
  final String host;

  @override
  Widget build(BuildContext context) {
    final selectedAnchorName =
        AppPrefs.get<String>(AppPrefsKeys.selectedAnchorName) ?? '앵커 미설정';

    return Dialog(
      backgroundColor: AppColors.scaffoldBackground,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                    color: AppColors.primary.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(color: AppColors.divider),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemCount: NewsAction.values.length,
              itemBuilder: (context, index) {
                final action = NewsAction.values[index];
                return Card(
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  color: AppColors.cardBackground,
                  child: ListTile(
                    leading: Icon(action.icon),
                    title: Text(action.label),
                    subtitle: switch (action) {
                      NewsAction.listen => Text(selectedAnchorName),
                      NewsAction.read => Text(host),
                    },
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Navigator.of(context).pop(action);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
