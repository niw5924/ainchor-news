import 'package:ainchor_news/api/brief_tts_api.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:readability/readability.dart' as readability;

import '../constants/app_colors.dart';
import '../constants/news_action_enums.dart';
import '../constants/news_category_enums.dart';
import '../models/naver_news_model.dart';
import '../services/naver_news_service.dart';
import '../utils/app_prefs.dart';
import '../utils/toast_utils.dart';
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
  late final _pagingController = PagingController<int, NaverNewsModel>(
    getNextPageKey:
        (state) => state.lastPageIsEmpty ? null : state.nextIntPageKey,
    fetchPage: (pageKey) async {
      final start = (pageKey - 1) * naverNewsPageSize + 1;
      if (start > 1000) return <NaverNewsModel>[];
      return NaverNewsService().fetchNews(query: widget.query, start: start);
    },
  );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => PagingListener<int, NaverNewsModel>(
    controller: _pagingController,
    builder:
        (context, state, fetchNextPage) => RefreshIndicator(
          onRefresh: () async {
            _pagingController.refresh();
          },
          child: PagedListView<int, NaverNewsModel>.separated(
            state: state,
            fetchNextPage: fetchNextPage,
            padding: const EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            builderDelegate: PagedChildBuilderDelegate<NaverNewsModel>(
              itemBuilder: (context, item, index) => _NewsTile(item: item),
            ),
          ),
        ),
  );
}

class _NewsTile extends StatelessWidget {
  const _NewsTile({required this.item});

  final NaverNewsModel item;

  @override
  Widget build(BuildContext context) {
    final title = item.title;
    final description = item.description;
    final pubDate = item.pubDate;
    final link = item.link;
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
            host.isNotEmpty ? host[0].toUpperCase() : '?',
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
              style: const TextStyle(decoration: TextDecoration.underline),
            ),
          ],
        ),
        onTap: () async {
          final action = await showDialog<NewsAction>(
            context: context,
            builder: (_) => NewsActionDialog(title: title, host: host),
          );
          if (action == null) return;
          switch (action) {
            case NewsAction.listen:
              try {
                final anchorName = AppPrefs.get<String>(
                  AppPrefsKeys.selectedAnchorName,
                );
                if (anchorName == null) {
                  ToastUtils.error('앵커를 먼저 설정해 주세요.');
                  break;
                }
                final article = await readability.parseAsync(link);
                final res = await BriefTtsApi.convert(article.textContent!);
                ToastUtils.success(res['success'].toString());
              } catch (e) {
                ToastUtils.error(e.toString());
              }
              break;
            case NewsAction.read:
              await launchUrl(Uri.parse(link));
              break;
          }
        },
      ),
    );
  }
}
