/// 앵커 프로필
enum Anchor {
  jihye(
    nameKo: '지혜',
    nameEn: 'Jihye',
    voiceStyle: '차분하고 따뜻한 톤',
    rivePath: 'assets/rives/jihye_anchor.riv',
    audioPath: 'assets/audios/jihye_sample.mp3',
  ),
  seoyeon(
    nameKo: '서연',
    nameEn: 'Seoyeon',
    voiceStyle: '밝고 명료한 톤',
    rivePath: 'assets/rives/seoyeon_anchor.riv',
    audioPath: 'assets/audios/seoyeon_sample.mp3',
  );

  const Anchor({
    required this.nameKo,
    required this.nameEn,
    required this.voiceStyle,
    required this.rivePath,
    required this.audioPath,
  });

  final String nameKo;
  final String nameEn;
  final String voiceStyle;
  final String rivePath;
  final String audioPath;
}
