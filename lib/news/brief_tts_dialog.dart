import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class BriefTtsDialog extends StatelessWidget {
  const BriefTtsDialog({
    super.key,
    required this.anchorName,
    required this.summary,
  });

  final String anchorName;
  final String summary;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.scaffoldBackground,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(anchorName),
            const SizedBox(height: 12),
            Text(summary),
          ],
        ),
      ),
    );
  }
}
