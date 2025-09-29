import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_colors.dart';
import '../constants/news_enums.dart';
import '../services/naver_news_service.dart';
import '../utils/date_time_utils.dart';
import '../utils/html_utils.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = NewsCategory.values;

    return DefaultTabController(
      length: categories.length,
      child: Column(
        children: [
          TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.black,
            tabs: categories.map((c) => Tab(text: c.label)).toList(),
          ),
          Expanded(
            child: TabBarView(
              children:
                  categories.map((c) => _NewsList(query: c.label)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsList extends StatelessWidget {
  const _NewsList({required this.query});

  final String query;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: NaverNewsService().fetchNews(query: query),
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
            final title = HtmlUtils.parseHtmlString(item['title']);
            final description = HtmlUtils.parseHtmlString(item['description']);
            final pubDate = DateTimeUtils.parsePubDateString(item['pubDate']);
            final originallink = item['originallink'];

            return Card(
              margin: EdgeInsets.zero,
              clipBehavior: Clip.antiAlias,
              color: AppColors.cardBackground,
              child: ListTile(
                title: Text(title),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(description),
                    const SizedBox(height: 4),
                    Text(pubDate),
                  ],
                ),
                onTap: () => launchUrl(Uri.parse(originallink)),
              ),
            );
          },
        );
      },
    );
  }
}
