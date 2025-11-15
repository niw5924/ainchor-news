import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

import '../constants/anchor_enums.dart';

class AnchorRiveUtils {
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

  static ({Artboard artboard, SMIInput<bool> talkingInput}) createInstance(
    int index,
  ) {
    final riveFile = riveFiles[index]!;
    final artboard = riveFile.mainArtboard.instance();
    final controller =
        StateMachineController.fromArtboard(artboard, 'State Machine')!;
    artboard.addController(controller);
    final talkingInput = controller.findInput<bool>('isTalking')!;
    talkingInput.value = false;

    return (artboard: artboard, talkingInput: talkingInput);
  }
}
