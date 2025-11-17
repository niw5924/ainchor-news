import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:zo_animated_border/zo_animated_border.dart';

import '../constants/app_colors.dart';

class AnchorCard extends StatelessWidget {
  const AnchorCard({
    super.key,
    required this.width,
    required this.height,
    required this.artboard,
    required this.isSelected,
  });

  final double width;
  final double height;
  final Artboard artboard;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final card = Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        width: width,
        height: height,
        child: Rive(artboard: artboard, fit: BoxFit.contain),
      ),
    );

    if (!isSelected) {
      return card;
    }

    return ZoBreathingBorder(
      borderWidth: 2.0,
      borderRadius: BorderRadius.circular(16),
      colors: const [Colors.lightBlueAccent, Colors.blueAccent, Colors.blue],
      child: card,
    );
  }
}
