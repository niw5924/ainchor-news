import 'package:flutter/material.dart';

class AinchorListTile extends StatelessWidget {
  const AinchorListTile({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final Widget title;
  final Widget subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: subtitle,
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
