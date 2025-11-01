class NaverNewsModel {
  final String title;
  final String description;
  final String pubDate;
  final String originallink;
  final String link;

  const NaverNewsModel({
    required this.title,
    required this.description,
    required this.pubDate,
    required this.originallink,
    required this.link,
  });

  factory NaverNewsModel.fromJson(Map<String, dynamic> json) {
    return NaverNewsModel(
      title: json['title'],
      description: json['description'],
      pubDate: json['pubDate'],
      originallink: json['originallink'],
      link: json['link'],
    );
  }
}
