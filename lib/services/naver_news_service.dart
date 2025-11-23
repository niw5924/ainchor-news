import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/naver_news_model.dart';

const int naverNewsPageSize = 10;

class NaverNewsService {
  Future<List<NaverNewsModel>> fetchNews({
    required String query,
    required int start,
  }) async {
    final dio = Dio();
    final naverClientId = dotenv.env['NAVER_CLIENT_ID'];
    final naverClientSecret = dotenv.env['NAVER_CLIENT_SECRET'];

    final response = await dio.get(
      'https://openapi.naver.com/v1/search/news.json',
      queryParameters: {
        'query': query,
        'display': naverNewsPageSize,
        'start': start,
        'sort': 'date',
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
    return items.map(NaverNewsModel.fromJson).toList();
  }
}
