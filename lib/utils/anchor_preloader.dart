import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import '../constants/anchor_enums.dart';

/// 런타임 캐시 단일화·전역 오염 방지용 싱글턴(외부 생성 금지)
class AnchorPreloader {
  /// 외부 생성 금지
  AnchorPreloader._();

  /// 싱글턴 인스턴스
  static final AnchorPreloader instance = AnchorPreloader._();

  final Map<int, Artboard> artboards = {};
  final Map<int, SMIInput<bool>> talkingInputs = {};

  Future<void> preloadAllAnchors() async {
    await RiveFile.initialize();
    for (int index = 0; index < Anchor.values.length; index++) {
      final anchor = Anchor.values[index];
      final riveBytes = await rootBundle.load(anchor.rivePath);
      final riveFile = RiveFile.import(riveBytes);

      final artboard = riveFile.mainArtboard;
      final controller = StateMachineController.fromArtboard(
        artboard,
        'State Machine',
      );

      if (controller != null) {
        artboard.addController(controller);
        final talkingInput = controller.findInput<bool>('isTalking');
        if (talkingInput != null) {
          talkingInput.value = false;
          talkingInputs[index] = talkingInput;
        }
      }

      artboards[index] = artboard;
    }
  }
}
