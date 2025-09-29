/// 뉴스 카테고리 (라벨 = 검색 키워드 그대로 사용)
enum NewsCategory {
  politics('정치'),
  economy('경제'),
  society('사회'),
  it('IT'),
  sports('스포츠');

  const NewsCategory(this.label);

  final String label;
}
