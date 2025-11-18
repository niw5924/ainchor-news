import 'package:flutter/material.dart';

class AinchorListTile extends StatelessWidget {
  const AinchorListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.showTrailing = true,
    this.onTap,
  });

  final Widget title;
  final Widget? subtitle;
  final bool showTrailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: subtitle,
      trailing: showTrailing ? const Icon(Icons.chevron_right) : null,
      onTap: onTap,
    );
  }
}
