import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import '../constants/app_colors.dart';

class AnchorCard extends StatelessWidget {
  const AnchorCard({
    super.key,
    required this.width,
    required this.height,
    required this.artboard,
  });

  final double width;
  final double height;
  final Artboard artboard;

  @override
  Widget build(BuildContext context) {
    return Card(
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
  }
}
