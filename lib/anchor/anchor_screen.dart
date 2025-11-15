import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rive/rive.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';
import 'package:zo_animated_border/zo_animated_border.dart';

import '../constants/anchor_enums.dart';
import '../constants/app_colors.dart';
import '../main_screen.dart';
import '../utils/anchor_rive_utils.dart';
import '../utils/app_prefs.dart';
import '../utils/toast_utils.dart';
import '../widgets/anchor_card.dart';

class AnchorScreen extends StatefulWidget {
  const AnchorScreen({super.key});

  @override
  State<AnchorScreen> createState() => _AnchorScreenState();
}

class _AnchorScreenState extends State<AnchorScreen> {
  late final AudioPlayer _anchorTabAudio;
  late final StreamSubscription<PlayerState> _anchorTabAudioSub;
  late final VoidCallback _tabListener;

  bool _isPlaying = false;
  String? _selectedName;
  int _currentIndex = 0;

  List<Anchor> get _anchors => Anchor.values;

  SMIInput<bool>? get _currentTalking =>
      AnchorPreloader.instance.talkingInputs[_currentIndex];

  @override
  void initState() {
    super.initState();

    _anchorTabAudio = AudioPlayer();
    _anchorTabAudioSub = _anchorTabAudio.playerStateStream.listen((s) {
      final completed = s.processingState == ProcessingState.completed;
      final talking = s.playing && !completed;
      setState(() {
        _isPlaying = talking;
      });
      _currentTalking?.value = talking;
    });

    _tabListener = () {
      if (shellIndex.value != 1) {
        _anchorTabAudio.pause();
        _currentTalking?.value = false;
      }
    };
    shellIndex.addListener(_tabListener);

    _selectedName = AppPrefs.get<String>(AppPrefsKeys.selectedAnchorName);
    _anchorTabAudio.setAsset(_anchors[_currentIndex].audioPath);
  }

  @override
  void dispose() {
    _currentTalking?.value = false;
    shellIndex.removeListener(_tabListener);
    _anchorTabAudioSub.cancel();
    _anchorTabAudio.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    final s = _anchorTabAudio.playerState;
    if (s.processingState == ProcessingState.completed) {
      await _anchorTabAudio.seek(Duration.zero);
      await _anchorTabAudio.play();
      return;
    }
    if (s.playing) {
      await _anchorTabAudio.pause();
    } else {
      await _anchorTabAudio.play();
    }
  }

  Future<void> _onIndexChanged(int newIndex) async {
    await _anchorTabAudio.pause();
    _currentTalking?.value = false;
    _currentIndex = newIndex;
    final newAnchor = _anchors[_currentIndex];
    await _anchorTabAudio.setAsset(newAnchor.audioPath);
  }

  Widget _buildAnchorCard(BuildContext context, int index) {
    final anchor = _anchors[index];
    final artboard = AnchorPreloader.instance.artboards[index]!;
    final contentCard = AnchorCard(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height * 0.45,
      artboard: artboard,
    );
    final isSelected = _selectedName == anchor.name;
    final isActive = index == _currentIndex;
    final showPause = isActive && _isPlaying;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(height: 16),
        ZoomTapAnimation(
          begin: 1.0,
          end: 0.9,
          beginDuration: const Duration(milliseconds: 50),
          endDuration: const Duration(milliseconds: 100),
          beginCurve: Curves.easeOutCubic,
          endCurve: Curves.fastOutSlowIn,
          onTap: () async {
            HapticFeedback.mediumImpact();
            final next = isSelected ? null : anchor.name;
            if (next == null) {
              await AppPrefs.remove(AppPrefsKeys.selectedAnchorName);
              ToastUtils.success("${anchor.name}을(를) 나만의 앵커에서 해제했어요");
            } else {
              await AppPrefs.set(AppPrefsKeys.selectedAnchorName, next);
              ToastUtils.success("${anchor.name}을(를) 나만의 앵커로 지정했어요");
            }
            setState(() => _selectedName = next);
          },
          child:
              isSelected
                  ? ZoBreathingBorder(
                    borderWidth: 2.0,
                    borderRadius: BorderRadius.circular(16),
                    colors: const [
                      Colors.lightBlueAccent,
                      Colors.blueAccent,
                      Colors.blue,
                    ],
                    child: contentCard,
                  )
                  : contentCard,
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Flexible(
                    flex: 1,
                    child: Card(
                      margin: EdgeInsets.zero,
                      clipBehavior: Clip.antiAlias,
                      color: AppColors.cardBackground,
                      child: ListTile(
                        title: const Text('이름'),
                        subtitle: Text(anchor.name),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    flex: 1,
                    child: Card(
                      margin: EdgeInsets.zero,
                      clipBehavior: Clip.antiAlias,
                      color: AppColors.cardBackground,
                      child: ListTile(
                        title: const Text('음성 스타일'),
                        subtitle: Text(anchor.voiceStyle),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Card(
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
                    child: IconButton(
                      onPressed: _togglePlay,
                      icon: Icon(showPause ? Icons.pause : Icons.play_arrow),
                    ),
                  ),
                  title: const Text('샘플 음성'),
                  subtitle: const Text('오프닝 인사말'),
                ),
              ),
            ],
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
        alignment: Alignment.topCenter,
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
