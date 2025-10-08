import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:zo_animated_border/zo_animated_border.dart';
import 'package:just_audio/just_audio.dart';

import '../constants/anchor_enums.dart';
import '../constants/app_colors.dart';

class AnchorScreen extends StatefulWidget {
  const AnchorScreen({super.key});

  @override
  State<AnchorScreen> createState() => _AnchorScreenState();
}

class _AnchorScreenState extends State<AnchorScreen> {
  final _player = AudioPlayer();
  static const _assetPath = 'assets/audios/jihye_sample.mp3';

  @override
  void initState() {
    super.initState();
    _player.setAsset(_assetPath);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    final s = _player.playerState;
    if (s.processingState == ProcessingState.completed) {
      await _player.seek(Duration.zero);
      await _player.play();
      return;
    }
    if (s.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    final anchor = Anchor.jihye;

    return Column(
      children: [
        Flexible(
          flex: 2,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width * 0.7,
            child: ZoBreathingBorder(
              borderWidth: 2.0,
              borderRadius: BorderRadius.circular(16),
              colors: const [
                Colors.lightBlueAccent,
                Colors.blueAccent,
                Colors.blue,
              ],
              child: Card(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                color: AppColors.cardBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const RiveAnimation.asset(
                  'assets/rives/jihye_anchor.riv',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        Divider(color: AppColors.divider),
        Flexible(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width * 0.7,
            child: Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              color: AppColors.cardBackground,
              child: ListTile(
                leading: ZoSignalBorder(
                  maxRadius: 40,
                  ringColors: const [
                    Colors.lightBlueAccent,
                    Colors.blueAccent,
                    Colors.blue,
                  ],
                  animationDuration: const Duration(seconds: 10),
                  child: StreamBuilder<PlayerState>(
                    stream: _player.playerStateStream,
                    builder: (context, snapshot) {
                      final s = snapshot.data;
                      final completed =
                          s?.processingState == ProcessingState.completed;
                      final showPause = (s?.playing == true) && !completed;
                      return IconButton(
                        onPressed: _togglePlay,
                        icon: Icon(showPause ? Icons.pause : Icons.play_arrow),
                      );
                    },
                  ),
                ),
                title: Text('${anchor.nameKo} (${anchor.nameEn})'),
                subtitle: Text(anchor.voiceStyle),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
