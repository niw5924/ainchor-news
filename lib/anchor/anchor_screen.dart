import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class AnchorScreen extends StatelessWidget {
  const AnchorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: RiveAnimation.asset(
        'assets/rives/jihye_anchor.riv',
        fit: BoxFit.contain,
      ),
    );
  }
}
