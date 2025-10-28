import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_colors.dart';
import '../constants/news_action_enums.dart';
import '../constants/news_category_enums.dart';
import '../services/naver_news_service.dart';
import '../utils/date_time_utils.dart';
import '../utils/html_utils.dart';
import 'news_action_dialog.dart';

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
            indicatorWeight: 3.0,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: AppColors.primary,
            dividerColor: AppColors.divider,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.secondary,
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

class _NewsList extends StatefulWidget {
  const _NewsList({required this.query});

  final String query;

  @override
  State<_NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<_NewsList> {
  late Future<List> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchNews();
  }

  Future<List> _fetchNews() =>
      NaverNewsService().fetchNews(query: widget.query);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${snapshot.error}'),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _future = _fetchNews();
                    });
                  },
                  child: const Text('새로고침'),
                ),
              ],
            ),
          );
        }
        final items = snapshot.data!;
        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('표시할 뉴스가 없습니다.'),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _future = _fetchNews();
                    });
                  },
                  child: const Text('새로고침'),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _future = _fetchNews();
            });
          },
          child: ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final title = HtmlUtils.parseHtmlString(item['title']);
              final description = HtmlUtils.parseHtmlString(
                item['description'],
              );
              final pubDate = DateTimeUtils.parsePubDateString(item['pubDate']);
              final link =
                  item['originallink'].isNotEmpty
                      ? item['originallink']
                      : item['link'];
              final host = Uri.parse(link).host.replaceFirst('www.', '');

              return Card(
                margin: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                color: AppColors.cardBackground,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                    foregroundColor: AppColors.primary,
                    child: Text(
                      host[0].toUpperCase(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(description),
                      const SizedBox(height: 4),
                      Text(pubDate),
                      Text(
                        host,
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    final action = await showDialog<NewsAction>(
                      context: context,
                      builder:
                          (_) => NewsActionDialog(title: title, host: host),
                    );
                    if (action == null) return;

                    switch (action) {
                      case NewsAction.listen:
                        break;
                      case NewsAction.read:
                        await launchUrl(Uri.parse(link));
                        break;
                    }
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
