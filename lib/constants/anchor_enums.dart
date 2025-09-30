/// 앵커 프로필
enum Anchor {
  jihye('지혜', 'Jihye', '밝고 명료한 톤'),
  seoyeon('서연', 'Seoyeon', '차분하고 따뜻한 톤');

  const Anchor(this.nameKo, this.nameEn, this.voiceStyle);

  final String nameKo;
  final String nameEn;
  final String voiceStyle;
}
