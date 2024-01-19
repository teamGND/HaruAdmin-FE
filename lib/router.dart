import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'utils/routing_url.dart';
import 'widgets/sidebar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    /*
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => const LoginPage(),
      ),
    */
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return SideBar(state: state, key: state.pageKey, child: child);
      },
      routes: routingURL
          .map((url) => GoRoute(
              path: url['path'] as String,
              builder: (context, state) => url['page'] as Widget))
          .toList(),
    )
  ],
);
