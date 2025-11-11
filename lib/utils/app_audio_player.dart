import 'package:just_audio/just_audio.dart';

class AppAudioPlayer {
  AppAudioPlayer._() {
    _player.playerStateStream.listen((s) async {
      if (s.processingState == ProcessingState.completed) {
        await _player.seek(Duration.zero);
        await _player.pause();
      }
    });
  }

  static final AppAudioPlayer instance = AppAudioPlayer._();

  final AudioPlayer _player = AudioPlayer();

  bool get playing => _player.playing;

  Future<void> setAsset(String path) => _player.setAsset(path);

  Future<void> play() => _player.play();

  Future<void> pause() => _player.pause();
}
