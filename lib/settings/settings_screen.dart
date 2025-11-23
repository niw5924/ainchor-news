import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_colors.dart';
import '../constants/news_summary_sentence_enums.dart';
import '../utils/app_prefs.dart';
import '../widgets/ainchor_list_tile.dart';
import 'news_summary_sentence_dialog.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ValueListenableBuilder<String>(
            valueListenable: AppPrefsState.anchor,
            builder: (context, anchor, _) {
              return AinchorListTile(
                title: const Text('현재 앵커'),
                subtitle: Text(anchor),
                showTrailing: false,
                onTap: () => context.go('/anchor'),
              );
            },
          ),
          const Divider(color: AppColors.divider),
          ValueListenableBuilder<int>(
            valueListenable: AppPrefsState.summaryCount,
            builder: (context, summaryCount, _) {
              return AinchorListTile(
                title: const Text('뉴스 요약 분량'),
                subtitle: Text('$summaryCount문장'),
                onTap: () async {
                  final newsSummarySentence =
                      await showDialog<NewsSummarySentence>(
                        context: context,
                        builder: (context) => const NewsSummarySentenceDialog(),
                      );
                  if (newsSummarySentence == null) return;
                  await AppPrefs.set(
                    AppPrefsKeys.summaryCount,
                    newsSummarySentence.sentenceCount,
                  );
                },
              );
            },
          ),
          const Divider(color: AppColors.divider),
          AinchorListTile(
            title: const Text('오픈소스 라이선스'),
            onTap: () {
              showLicensePage(context: context, useRootNavigator: true);
            },
          ),
        ],
      ),
    );
  }
}
