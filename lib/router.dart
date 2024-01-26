import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_admin/screens/authentication/login_page.dart';
import 'package:haru_admin/screens/authentication/signup_page.dart';

import 'utils/routing_url.dart';
import 'widgets/sidebar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignUpPage(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return SideBar(state: state, key: state.pageKey, child: child);
      },
      routes: routingURL
          .map((url) => GoRoute(
              path: url.getPath, builder: (context, state) => url.getpage))
          .toList(),
    )
  ],
);
