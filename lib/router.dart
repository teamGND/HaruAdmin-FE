import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_admin/screens/admin.dart';
import 'package:haru_admin/screens/authentication/login_page.dart';
import 'package:haru_admin/screens/authentication/signup_page.dart';
import 'package:haru_admin/screens/grammer/add_grammer.dart';
import 'package:haru_admin/screens/grammer/grammer.dart';
import 'package:haru_admin/screens/intro/add_intro_screen.dart';
import 'package:haru_admin/screens/intro/intro_test_screen.dart';
import 'package:haru_admin/screens/meta/add_meta_screen.dart';
import 'package:haru_admin/screens/meta/meta_screen.dart';
import 'package:haru_admin/screens/mypage.dart';
import 'package:haru_admin/screens/test/add_quiz_screen.dart';
import 'package:haru_admin/screens/test/add_test_screen.dart';
import 'package:haru_admin/screens/word/add_word_screen.dart';
import 'package:haru_admin/screens/word/word_screen.dart';
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
      routes: [
        ...sidebarRoutes['data']!,
        ...sidebarRoutes['account']!,
        ...sidebarRoutes['my']!,
        GoRoute(
          name: '인트로 데이터 추가',
          path: '/intro/add',
          builder: (context, state) => const AddIntroScreen(),
        ),
        GoRoute(
          name: '테스트 데이터 추가',
          path: '/test/add/:category/:introId',
          builder: (context, state) => AddTestScreen(
            state.pathParameters['category'],
            state.pathParameters['introId'],
          ),
        ),
        GoRoute(
          name: '퀴즈 데이터 추가',
          path: '/quiz/add/:category/:introId',
          builder: (context, state) => AddQuizScreen(
            state.pathParameters['category'],
            state.pathParameters['introId'],
          ),
        ),
        GoRoute(
          name: '문법 데이터 추가',
          path: '/grammar/add/:grammarId',
          builder: (context, state) => AddGrammerScreen(
            state.pathParameters['grammarId'],
          ),
        ),
        GoRoute(
          name: '단어 데이터 추가',
          path: '/word/add',
          builder: (context, state) => const AddWordScreen(),
        ),
        GoRoute(
          name: '메타 데이터 추가',
          path: '/meta/add',
          builder: (context, state) => const AddMeta(),
        ),
      ],
    ),
  ],
);

Map<String, List<GoRoute>> sidebarRoutes = {
  'account': [
    GoRoute(
        name: '관리자 계정 관리',
        path: '/admin',
        builder: (context, state) => const Admin()),
  ],
  'data': [
    GoRoute(
      name: '인트로 & 퀴즈/테스트',
      path: '/intro',
      builder: (context, state) => const IntroTestScreen(),
    ),
    GoRoute(
      name: '단어 데이터',
      path: '/word',
      builder: (context, state) => const Word(),
    ),
    GoRoute(
      name: '문법 데이터',
      path: '/grammar',
      builder: (context, state) => const GrammerData(),
    ),
    GoRoute(
      name: '메타 데이터',
      path: '/meta',
      builder: (context, state) => const MetaGrammarScreen(),
    ),
  ],
  'my': [
    GoRoute(
      name: '마이페이지',
      path: '/mypage',
      builder: (context, state) => const Mypage(),
    ),
  ]
};
