import 'package:go_router/go_router.dart';

import 'avatar/avatar_screen.dart';
import 'main_screen.dart';
import 'news/news_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/news',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/news',
              name: 'news',
              builder: (context, state) => const NewsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/avatar',
              name: 'avatar',
              builder: (context, state) => const AvatarScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
