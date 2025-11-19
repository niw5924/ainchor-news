enum NewsSummarySentence {
  short(label: '간단히', sentenceCount: 3),
  medium(label: '보통', sentenceCount: 5),
  long(label: '자세히', sentenceCount: 7);

  const NewsSummarySentence({required this.label, required this.sentenceCount});

  final String label;
  final int sentenceCount;
}
