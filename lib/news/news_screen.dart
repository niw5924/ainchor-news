import 'package:ainchor_news/news/brief_tts_dialog.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_colors.dart';
import '../constants/news_action_enums.dart';
import '../constants/news_category_enums.dart';
import '../constants/news_sort_enums.dart';
import '../models/naver_news_model.dart';
import '../services/naver_news_service.dart';
import '../utils/app_prefs.dart';
import '../utils/toast_utils.dart';
import '../widgets/ainchor_choice_chip.dart';
import 'news_action_dialog.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  NewsSort _sort = NewsSort.date;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsCategory = NewsCategory.values;

    return DefaultTabController(
      length: newsCategory.length,
      child: Column(
        children: [
          TabBar(
            indicatorWeight: 3.0,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorColor: AppColors.primary,
            dividerColor: AppColors.divider,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.secondary,
            tabs: newsCategory.map((c) => Tab(text: c.label)).toList(),
          ),
          const SizedBox(height: 16),
          SearchBar(
            controller: _searchController,
            hintText: '뉴스 검색',
            leading: const Icon(Icons.search),
            trailing: [
              if (_searchController.text.isNotEmpty) ...[
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                    });
                  },
                ),
              ],
            ],
            backgroundColor: const WidgetStatePropertyAll(
              AppColors.appBarBackground,
            ),
            onChanged: (value) {
              setState(() {
                print(value);
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AinchorChoiceChip(
                label: NewsSort.date.label,
                selected: _sort == NewsSort.date,
                onSelected: (selected) {
                  if (!selected || _sort == NewsSort.date) return;
                  setState(() {
                    _sort = NewsSort.date;
                  });
                },
              ),
              const SizedBox(width: 8),
              AinchorChoiceChip(
                label: NewsSort.sim.label,
                selected: _sort == NewsSort.sim,
                onSelected: (selected) {
                  if (!selected || _sort == NewsSort.sim) return;
                  setState(() {
                    _sort = NewsSort.sim;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              children:
                  newsCategory
                      .map((c) => _NewsList(query: c.label, sort: _sort))
                      .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsList extends StatefulWidget {
  const _NewsList({required this.query, required this.sort});

  final String query;
  final NewsSort sort;

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
      return NaverNewsService().fetchNews(
        query: widget.query,
        start: start,
        sort: widget.sort,
      );
    },
  );

  @override
  void didUpdateWidget(covariant _NewsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sort != widget.sort) {
      _pagingController.refresh();
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PagingListener<int, NaverNewsModel>(
      controller: _pagingController,
      builder: (context, state, fetchNextPage) {
        return RefreshIndicator(
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
              itemBuilder: (context, item, index) {
                if (item.imageUrl != null && item.imageUrl!.isNotEmpty) {
                  return _HeadlineNewsTile(item: item);
                }
                return _NewsTile(item: item);
              },
            ),
          ),
        );
      },
    );
  }
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            const SizedBox(height: 8),
            Text(pubDate),
            Text(
              host,
              style: const TextStyle(decoration: TextDecoration.underline),
            ),
          ],
        ),
        onTap: () async {
          final newsAction = await showDialog<NewsAction>(
            context: context,
            builder: (_) => NewsActionDialog(title: title, host: host),
          );
          if (newsAction == null) return;
          switch (newsAction) {
            case NewsAction.listen:
              final savedAnchor = AppPrefsState.anchor.value;
              if (savedAnchor == AppPrefsDefaults.anchor) {
                ToastUtils.error('앵커를 먼저 설정해 주세요.');
                break;
              }
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (_) => BriefTtsDialog(anchorName: savedAnchor, link: link),
              );
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

class _HeadlineNewsTile extends StatelessWidget {
  const _HeadlineNewsTile({required this.item});

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
      child: InkWell(
        onTap: () async {
          final newsAction = await showDialog<NewsAction>(
            context: context,
            builder: (_) => NewsActionDialog(title: title, host: host),
          );
          if (newsAction == null) return;
          switch (newsAction) {
            case NewsAction.listen:
              final savedAnchor = AppPrefsState.anchor.value;
              if (savedAnchor == AppPrefsDefaults.anchor) {
                ToastUtils.error('앵커를 먼저 설정해 주세요.');
                break;
              }
              await showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (_) => BriefTtsDialog(anchorName: savedAnchor, link: link),
              );
              break;
            case NewsAction.read:
              await launchUrl(Uri.parse(link));
              break;
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(description),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withValues(alpha: 0.3),
                    foregroundColor: AppColors.primary,
                    child: Text(
                      host.isNotEmpty ? host[0].toUpperCase() : '?',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(pubDate),
                      Text(
                        host,
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
