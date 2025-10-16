import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:zo_animated_border/zo_animated_border.dart';
import 'package:just_audio/just_audio.dart';
import 'package:card_swiper/card_swiper.dart';
import '../constants/anchor_enums.dart';
import '../constants/app_colors.dart';

class AnchorScreen extends StatefulWidget {
  const AnchorScreen({super.key});

  @override
  State<AnchorScreen> createState() => _AnchorScreenState();
}

class _AnchorScreenState extends State<AnchorScreen> {
  final _player = AudioPlayer();
  final List<Anchor> _anchors = const [Anchor.jihye, Anchor.seoyeon];
  int _currentIndex = 0;
  final Map<int, SMIInput<bool>?> _talkInputs = {};
  StreamSubscription<PlayerState>? _playerSub;

  SMIInput<bool>? get _currentTalking => _talkInputs[_currentIndex];

  @override
  void initState() {
    super.initState();
    _player.setAsset(_anchors[_currentIndex].audioPath);
    _playerSub = _player.playerStateStream.listen((s) {
      final completed = s.processingState == ProcessingState.completed;
      final talking = s.playing && !completed;
      _currentTalking?.value = talking;
    });
  }

  @override
  void dispose() {
    _playerSub?.cancel();
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

  void Function(Artboard) _onRiveInitFor(int index) {
    return (Artboard artboard) {
      final controller = StateMachineController.fromArtboard(
        artboard,
        'State Machine',
      );
      if (controller != null) {
        artboard.addController(controller);
        _talkInputs[index] = controller.findInput<bool>('isTalking');
        _talkInputs[index]?.value = false;
      }
    };
  }

  Future<void> _onIndexChanged(int newIndex) async {
    _talkInputs[_currentIndex]?.value = false;
    if (_player.playing) {
      await _player.pause();
    }
    _currentIndex = newIndex;
    final newAnchor = _anchors[_currentIndex];
    await _player.setAsset(newAnchor.audioPath);
    _talkInputs[_currentIndex]?.value = false;
  }

  Widget _buildAnchorCard(BuildContext context, int index) {
    final anchor = _anchors[index];
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
                child: RiveAnimation.asset(
                  anchor.rivePath,
                  fit: BoxFit.contain,
                  onInit: _onRiveInitFor(index),
                ),
              ),
            ),
          ),
        ),
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

  @override
  Widget build(BuildContext context) {
    return Swiper(
      itemCount: _anchors.length,
      itemBuilder: _buildAnchorCard,
      onIndexChanged: _onIndexChanged,
      loop: false,
      pagination: SwiperPagination(
        builder: DotSwiperPaginationBuilder(
          color: AppColors.primary.withValues(alpha: 0.2),
          activeColor: AppColors.primary,
          size: 6,
          activeSize: 8,
        ),
      ),
    );
  }
}
