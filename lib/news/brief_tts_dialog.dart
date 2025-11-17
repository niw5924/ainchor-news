import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:readability/readability.dart' as readability;
import 'package:rive/rive.dart';

import '../api/brief_tts_api.dart';
import '../constants/anchor_enums.dart';
import '../constants/app_colors.dart';
import '../utils/anchor_rive_utils.dart';
import '../utils/toast_utils.dart';
import '../widgets/anchor_card.dart';

class BriefTtsDialog extends StatefulWidget {
  const BriefTtsDialog({
    super.key,
    required this.anchorName,
    required this.link,
  });

  final String anchorName;
  final String link;

  @override
  State<BriefTtsDialog> createState() => _BriefTtsDialogState();
}

class _BriefTtsDialogState extends State<BriefTtsDialog>
    with WidgetsBindingObserver {
  late final AudioPlayer _briefTtsAudio;
  late final StreamSubscription<PlayerState> _briefTtsAudioSub;
  late final Artboard _artboard;
  late final SMIInput<bool> _talkingInput;

  set _talking(bool value) => _talkingInput.value = value;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    final anchorIndex = Anchor.values.indexWhere(
      (a) => a.name == widget.anchorName,
    );
    final instance = AnchorRiveUtils.createInstance(anchorIndex);
    _artboard = instance.artboard;
    _talkingInput = instance.talkingInput;

    _briefTtsAudio = AudioPlayer();
    _briefTtsAudioSub = _briefTtsAudio.playerStateStream.listen((s) {
      final completed = s.processingState == ProcessingState.completed;
      final talking = s.playing && !completed;
      _talking = talking;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _briefTtsAudio.pause();
    } else if (state == AppLifecycleState.resumed) {
      _briefTtsAudio.play();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _briefTtsAudioSub.cancel();
    _briefTtsAudio.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.scaffoldBackground,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: FutureBuilder<String>(
            future: Future<String>(() async {
              final article = await readability.parseAsync(widget.link);
              final text = article.textContent;
              if (text == null || text.isEmpty) {
                throw Exception('본문이 비어있습니다.');
              }

              final sumRes = await BriefTtsApi.summary(text: text);
              final summarized = sumRes['summary'];
              if (summarized == null || summarized.isEmpty) {
                throw Exception('요약 결과가 없습니다.');
              }

              return summarized;
            })..then((summary) async {
              try {
                final bytes = await BriefTtsApi.tts(
                  anchorName: widget.anchorName,
                  summary: summary,
                );
                final uri = Uri.dataFromBytes(bytes, mimeType: 'audio/mpeg');
                await _briefTtsAudio.setUrl(uri.toString());
                await _briefTtsAudio.play();
              } catch (e) {
                ToastUtils.error('음성을 재생하는 중 오류가 발생했습니다.');
              }
            }),
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snap.hasError) {
                return Center(child: Text('${snap.error}'));
              }

              final summary = snap.data!;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnchorCard(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: MediaQuery.of(context).size.height * 0.3,
                    artboard: _artboard,
                    isSelected: false,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.anchorName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: Scrollbar(
                      child: SingleChildScrollView(child: Text(summary)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('닫기'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
