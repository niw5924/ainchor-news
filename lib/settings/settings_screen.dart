import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/news_summary_sentence_enums.dart';
import '../utils/app_prefs.dart';
import '../widgets/ainchor_list_tile.dart';
import 'news_summary_sentence_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late String _savedAnchor;
  late int _savedCount;

  @override
  void initState() {
    super.initState();
    _savedAnchor =
        AppPrefs.get<String>(AppPrefsKeys.selectedAnchorName) ??
        AppPrefsDefaults.selectedAnchorName;
    _savedCount =
        AppPrefs.get<int>(AppPrefsKeys.newsSummarySentenceCount) ??
        AppPrefsDefaults.newsSummarySentenceCount;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AinchorListTile(
            title: const Text('현재 앵커'),
            subtitle: Text(_savedAnchor),
            showTrailing: false,
          ),
          const Divider(color: AppColors.divider),
          AinchorListTile(
            title: const Text('뉴스 요약 분량'),
            subtitle: Text('$_savedCount문장'),
            onTap: () async {
              final newsSummarySentence = await showDialog<NewsSummarySentence>(
                context: context,
                builder: (context) => const NewsSummarySentenceDialog(),
              );
              if (newsSummarySentence == null) return;
              await AppPrefs.set(
                AppPrefsKeys.newsSummarySentenceCount,
                newsSummarySentence.sentenceCount,
              );
              setState(() {
                _savedCount = newsSummarySentence.sentenceCount;
              });
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
