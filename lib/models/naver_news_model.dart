import '../utils/date_time_utils.dart';
import '../utils/html_utils.dart';

class NaverNewsModel {
  final String title;
  final String description;
  final String pubDate;
  final String link;

  const NaverNewsModel({
    required this.title,
    required this.description,
    required this.pubDate,
    required this.link,
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
}
