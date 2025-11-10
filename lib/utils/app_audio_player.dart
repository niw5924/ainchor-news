import 'package:just_audio/just_audio.dart';

class AppAudioPlayer {
  AppAudioPlayer._();

  static final AppAudioPlayer instance = AppAudioPlayer._();

  final AudioPlayer _player = AudioPlayer();

  Stream<PlayerState> get stateStream => _player.playerStateStream;
  PlayerState get state => _player.playerState;
  bool get playing => _player.playing;

  Future<void> setAsset(String path) => _player.setAsset(path);
  Future<void> play() => _player.play();
  Future<void> pause() => _player.pause();
  Future<void> moveToStart() => _player.seek(Duration.zero);

  Future<void> toggle() async {
    if (state.processingState == ProcessingState.completed) {
      await moveToStart();
      await play();
      return;
    }
    if (playing) {
      await pause();
    } else {
      await play();
    }
  }
}
