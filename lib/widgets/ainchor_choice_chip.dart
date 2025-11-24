import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AinchorChoiceChip extends StatelessWidget {
  const AinchorChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: AppColors.cardBackground,
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
