import '../utils/date_time_utils.dart';
import '../utils/html_utils.dart';

class NaverNewsModel {
  final String title;
  final String description;
  final String pubDate;
  final String link;
  final String? imageUrl;

  const NaverNewsModel({
    required this.title,
    required this.description,
    required this.pubDate,
    required this.link,
    this.imageUrl,
  });

  factory NaverNewsModel.fromJson(Map<String, dynamic> json) {
    return NaverNewsModel(
      title: HtmlUtils.parseHtmlString(json['title']),
      description: HtmlUtils.parseHtmlString(json['description']),
      pubDate: DateTimeUtils.parsePubDateString(json['pubDate']),
      link:
          json['originallink'].isNotEmpty ? json['originallink'] : json['link'],
    );
  }

  NaverNewsModel copyWith({
    String? title,
    String? description,
    String? pubDate,
    String? link,
    String? imageUrl,
  }) {
    return NaverNewsModel(
      title: title ?? this.title,
      description: description ?? this.description,
      pubDate: pubDate ?? this.pubDate,
      link: link ?? this.link,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
