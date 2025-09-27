import 'package:flutter/material.dart';

import '../services/naver_news_service.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: NaverNewsService().fetchNews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('${snapshot.error}'));
        }
        final items = snapshot.data!;
        if (items.isEmpty) {
          return const Center(child: Text('표시할 뉴스가 없어요.'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];

            return Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                title: Text('${item['title']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${item['description']}'),
                    Text('${item['pubDate']}'),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
