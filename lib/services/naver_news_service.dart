import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:readability/readability.dart' as readability;

import '../api/dio_client.dart';
import '../constants/news_sort_enums.dart';
import '../models/naver_news_model.dart';

const int naverNewsPageSize = 10;

class NaverNewsService {
  Future<List<NaverNewsModel>> fetchNews({
    required String query,
    required int start,
    required NewsSort sort,
  }) async {
    final naverClientId = dotenv.env['NAVER_CLIENT_ID']!;
    final naverClientSecret = dotenv.env['NAVER_CLIENT_SECRET']!;

    final response = await DioClient.dio.get(
      'https://openapi.naver.com/v1/search/news.json',
      queryParameters: {
        'query': query,
        'display': naverNewsPageSize,
        'start': start,
        'sort': sort.apiValue,
      },
      options: Options(
        headers: {
          'X-Naver-Client-Id': naverClientId,
          'X-Naver-Client-Secret': naverClientSecret,
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}: ${response.data}');
    }

    final items = List<Map<String, dynamic>>.from(response.data['items']);
    final newsList = items.map(NaverNewsModel.fromJson).toList();
    await setImageUrl(newsList);
    return newsList;
  }

  /// 첫 번째 뉴스 항목에 Readability로 추출한 이미지 URL을 설정한다.
  Future<void> setImageUrl(List<NaverNewsModel> list) async {
    if (list.isEmpty) return;
    try {
      final first = list.first;
      final article = await readability.parseAsync(first.link);
      final imageUrl = article.imageUrl;
      if (imageUrl == null || imageUrl.isEmpty) return;
      list[0] = first.copyWith(imageUrl: imageUrl);
    } catch (e) {
      print('이미지 URL 설정 실패: $e');
    }
  }
}
