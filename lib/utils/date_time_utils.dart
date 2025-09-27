import 'package:intl/intl.dart';

class DateTimeUtils {
  /// 입력: Sat, 27 Sep 2025 22:44:00 +0900
  /// 출력: 2025-09-27 (토) 22:44
  static String parsePubDateString(String pubDateString) {
    final dt = DateFormat(
      "EEE, dd MMM yyyy HH:mm:ss Z",
      'en',
    ).parse(pubDateString);
    return DateFormat('yyyy-MM-dd (EEE) HH:mm', 'ko').format(dt);
  }
}
