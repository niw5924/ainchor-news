import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:zo_animated_border/zo_animated_border.dart';

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
          flex: 2,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width * 0.7,
            child: ZoBreathingBorder(
              borderWidth: 2.0,
              borderRadius: BorderRadius.circular(16),
              colors: const [
                Colors.lightBlueAccent,
                Colors.blueAccent,
                Colors.blue,
              ],
              child: Card(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                color: AppColors.cardBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const RiveAnimation.asset(
                  'assets/rives/jihye_anchor.riv',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        Divider(color: AppColors.divider),
        Flexible(
          flex: 1,
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
