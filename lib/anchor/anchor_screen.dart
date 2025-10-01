import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../constants/anchor_enums.dart';

class AnchorScreen extends StatelessWidget {
  const AnchorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final anchor = Anchor.jihye;
    return Column(
      children: [
        Flexible(
          flex: 2,
          child: Center(
            child: RiveAnimation.asset(
              'assets/rives/jihye_anchor.riv',
              fit: BoxFit.contain,
            ),
          ),
        ),
        Divider(),
        Flexible(
          flex: 1,
          child: ListTile(
            title: Text('${anchor.nameKo} (${anchor.nameEn})'),
            subtitle: Text(anchor.voiceStyle),
          ),
        ),
      ],
    );
  }
}
