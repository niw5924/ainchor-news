import 'package:flutter/material.dart';
import 'package:readability/readability.dart' as readability;

import '../api/brief_tts_api.dart';
import '../constants/app_colors.dart';
import '../utils/toast_utils.dart';

class BriefTtsDialog extends StatefulWidget {
  const BriefTtsDialog({
    super.key,
    required this.anchorName,
    required this.link,
  });

  final String anchorName;
  final String link;

  @override
  State<BriefTtsDialog> createState() => _BriefTtsDialogState();
}

class _BriefTtsDialogState extends State<BriefTtsDialog> {
  bool converting = true;
  String summary = '';

  @override
  void initState() {
    super.initState();
    _convert();
  }

  Future<void> _convert() async {
    try {
      final article = await readability.parseAsync(widget.link);
      final text = article.textContent;
      if (text == null || text.isEmpty) {
        ToastUtils.error('본문이 비어있습니다.');
        Navigator.of(context).pop();
        return;
      }

      final res = await BriefTtsApi.convert(
        anchorName: widget.anchorName,
        text: text,
      );
      final summary = res['summary'];
      if (summary == null || summary.isEmpty) {
        ToastUtils.error('요약 결과가 없습니다.');
        Navigator.of(context).pop();
        return;
      }

      setState(() {
        this.summary = summary;
        converting = false;
      });
    } catch (e) {
      ToastUtils.error(e.toString());
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.scaffoldBackground,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children:
              converting
                  ? const [
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text('변환 중입니다.'),
                  ]
                  : [
                    Text(widget.anchorName),
                    const SizedBox(height: 12),
                    Text(summary),
                  ],
        ),
      ),
    );
  }
}
