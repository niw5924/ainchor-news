import 'package:flutter/material.dart';

/// 뉴스 액션
enum NewsAction {
  listen(label: '요약 듣기', icon: Icons.headset_rounded),
  read(label: '기사 읽기', icon: Icons.chrome_reader_mode_rounded);

  const NewsAction({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
