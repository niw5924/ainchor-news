import 'package:flutter/material.dart';

class AinchorListTile extends StatelessWidget {
  const AinchorListTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final Widget title;
  final Widget subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: subtitle,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
