import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'widgets/sidebar.dart';
import 'screens/home.dart';
import 'screens/authentication/login_page.dart';
import 'screens/authentication/signup_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return SideBar(child: child, state: state, key: state.pageKey);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) {
            return const Home();
          },
        ),
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: '/signup',
          builder: (BuildContext context, GoRouterState state) {
            return const SignUpScreen();
          },
        ),
        GoRoute(
          path: '/home',
          builder: (BuildContext context, GoRouterState state) {
            return const Home();
          },
        )
      ],
    ),
  ],
);
