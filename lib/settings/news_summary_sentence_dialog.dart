import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/news_summary_sentence_enums.dart';
import '../utils/app_prefs.dart';

class NewsSummarySentenceDialog extends StatelessWidget {
  const NewsSummarySentenceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final savedSummaryCount =
        AppPrefs.get<int>(AppPrefsKeys.summaryCount) ??
        AppPrefsDefaults.summaryCount;

    return Dialog(
      backgroundColor: AppColors.scaffoldBackground,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '뉴스 요약 분량',
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
              itemCount: NewsSummarySentence.values.length,
              itemBuilder: (context, index) {
                final newsSummarySentence = NewsSummarySentence.values[index];
                final isSelected =
                    newsSummarySentence.sentenceCount == savedSummaryCount;

                return Card(
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  color: AppColors.cardBackground,
                  child: ListTile(
                    title: Text(newsSummarySentence.label),
                    subtitle: Text('${newsSummarySentence.sentenceCount}문장'),
                    trailing:
                        isSelected
                            ? const Icon(
                              Icons.check_rounded,
                              color: AppColors.primary,
                            )
                            : null,
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Navigator.of(context).pop(newsSummarySentence);
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
