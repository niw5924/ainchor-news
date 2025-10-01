import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../constants/anchor_enums.dart';
import '../constants/app_colors.dart';

class AnchorScreen extends StatelessWidget {
  const AnchorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final anchor = Anchor.jihye;

    return Column(
      children: [
        Flexible(
          flex: 6,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width * 0.7,
            child: Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              color: AppColors.cardBackground,
              child: RiveAnimation.asset(
                'assets/rives/jihye_anchor.riv',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        Flexible(flex: 1, child: Center(child: Divider())),
        Flexible(
          flex: 3,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width * 0.7,
            child: Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              color: AppColors.cardBackground,
              child: ListTile(
                title: Text('${anchor.nameKo} (${anchor.nameEn})'),
                subtitle: Text(anchor.voiceStyle),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
