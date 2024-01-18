import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/sidebar.dart';
import 'screens/home.dart';
import 'screens/authentication/login_page.dart';
import 'screens/authentication/signup_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final routingURL = [
  {'path': '/', 'page': const Home()},
  {'path': '/login', 'page': const LoginPage()},
  {'path': '/signup', 'page': const SignUpScreen()},
  {'path': '/home', 'page': const Home()},
];

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  routes: [
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
