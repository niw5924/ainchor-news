import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AppAudioPlayer {
  AppAudioPlayer._() {
    _player.playerStateStream.listen((s) async {
      if (s.processingState == ProcessingState.completed) {
        await _player.seek(Duration.zero);
        await pause();
      } else {
        playing.value = _player.playing;
      }
    });
  }

  static final AppAudioPlayer instance = AppAudioPlayer._();

  final AudioPlayer _player = AudioPlayer();

  final ValueNotifier<bool> playing = ValueNotifier<bool>(false);

  Future<void> setAsset(String path) async {
    await _player.setAsset(path);
  }

  Future<void> setUrl(String url) async {
    await _player.setUrl(url);
  }

  Future<void> play() async {
    playing.value = true;
    await _player.play();
  }

  Future<void> pause() async {
    playing.value = false;
    await _player.pause();
  }
}
