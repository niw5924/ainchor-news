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
    final card = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black, // 이미지 로딩 전 배경 색으로 깜빡임 방지
        image: const DecorationImage(
          image: AssetImage('assets/images/worldmap_darkblue_bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Rive(artboard: artboard, fit: BoxFit.contain),
    );

    if (!isSelected) {
      return card;
    }

    return Banner(
      message: 'MY PICK',
      location: BannerLocation.topEnd,
      color: AppColors.primary,
      child: ZoBreathingBorder(
        borderWidth: 2.0,
        borderRadius: BorderRadius.circular(16),
        colors: const [Colors.lightBlueAccent, Colors.blueAccent, Colors.blue],
        child: card,
      ),
    );
  }
}
