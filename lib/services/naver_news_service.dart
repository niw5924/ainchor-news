import 'package:ainchor_news/models/naver_news_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NaverNewsService {
  Future<List> fetchNews({required String query, required int start}) async {
    final dio = Dio();
    final naverClientId = dotenv.env['NAVER_CLIENT_ID'];
    final naverClientSecret = dotenv.env['NAVER_CLIENT_SECRET'];

    final response = await dio.get(
      'https://openapi.naver.com/v1/search/news.json',
      queryParameters: {
        'query': query,
        'display': 10,
        'start': start,
        'sort': 'sim',
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

    final items = response.data['items'];
    return items.map((e) => NaverNewsModel.fromJson(e)).toList();
  }
}
