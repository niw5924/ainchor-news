import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  Future<List> fetchTitles() async {
    final naverClientId = dotenv.env['NAVER_CLIENT_ID'];
    final naverClientSecret = dotenv.env['NAVER_CLIENT_SECRET'];
    final dio = Dio();
    final response = await dio.get(
      'https://openapi.naver.com/v1/search/news.json',
      queryParameters: {'query': '스포츠', 'display': 10},
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
    final titles = items.map((e) => e['title']).toList();
    return titles;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: fetchTitles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        }
        final titles = snapshot.data!;
        if (titles.isEmpty) {
          return const Center(child: Text('표시할 뉴스가 없어요.'));
        }
        return ListView.builder(
          itemCount: titles.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text('${titles[index]}'));
          },
        );
      },
    );
  }
}
