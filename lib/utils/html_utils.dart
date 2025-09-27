import 'package:html/parser.dart';

class HtmlUtils {
  static String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    return document.body!.text.trim();
  }
}
