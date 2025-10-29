/// 앵커 프로필
enum Anchor {
  jihye(
    name: '지혜',
    voiceStyle: '차분하고 따뜻한 톤',
    rivePath: 'assets/rives/jihye_anchor.riv',
    audioPath: 'assets/audios/jihye_sample.mp3',
  ),
  seoyeon(
    name: '서연',
    voiceStyle: '밝고 명료한 톤',
    rivePath: 'assets/rives/seoyeon_anchor.riv',
    audioPath: 'assets/audios/seoyeon_sample.mp3',
  );

  const Anchor({
    required this.name,
    required this.voiceStyle,
    required this.rivePath,
    required this.audioPath,
  });

  final String name;
  final String voiceStyle;
  final String rivePath;
  final String audioPath;
}
