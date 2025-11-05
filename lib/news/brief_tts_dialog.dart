import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class BriefTtsDialog extends StatelessWidget {
  const BriefTtsDialog({super.key, required this.summary});

  final String summary;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.scaffoldBackground,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Text(summary)],
        ),
      ),
    );
  }
}
