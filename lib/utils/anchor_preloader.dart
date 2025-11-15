import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import '../constants/anchor_enums.dart';

class AnchorPreloader {
  static final Map<int, RiveFile> riveFiles = {};

  static Future<void> preloadAllAnchors() async {
    await RiveFile.initialize();

    for (int index = 0; index < Anchor.values.length; index++) {
      final anchor = Anchor.values[index];
      final riveBytes = await rootBundle.load(anchor.rivePath);
      final riveFile = RiveFile.import(riveBytes);
      riveFiles[index] = riveFile;
    }
  }
}
