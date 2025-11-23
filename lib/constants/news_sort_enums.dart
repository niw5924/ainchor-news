enum NewsSort {
  date(label: '최신순', apiValue: 'date'),
  sim(label: '정확도순', apiValue: 'sim');

  const NewsSort({required this.label, required this.apiValue});

  final String label;
  final String apiValue;
}
