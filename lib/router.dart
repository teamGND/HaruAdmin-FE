import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:haru_admin/screens/admin.dart';
import 'package:haru_admin/screens/authentication/login_page.dart';
import 'package:haru_admin/screens/authentication/signup_page.dart';
import 'package:haru_admin/screens/grammer/add_grammer.dart';
import 'package:haru_admin/screens/grammer/grammer_screen.dart';
import 'package:haru_admin/screens/intro/add_intro_screen.dart';
import 'package:haru_admin/screens/intro/intro_test_screen.dart';
import 'package:haru_admin/screens/meta/meta_screen.dart';
import 'package:haru_admin/screens/mypage.dart';
import 'package:haru_admin/screens/test/add_test_screen.dart';
import 'package:haru_admin/screens/word/add_word_screen.dart';
import 'package:haru_admin/screens/word/word_screen.dart';
import 'package:haru_admin/themes/colors.dart';
import 'package:haru_admin/widgets/dot.dart';
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
        ...sidebarRoutes.map((sidebar) => sidebar.route).toList(),
        GoRoute(
          name: '인트로 데이터 추가',
          path: '/intro/add',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: AddIntroScreen(),
          ),
        ),
        GoRoute(
          name: '테스트 데이터 추가',
          path: '/test/add/:category/:introId',
          pageBuilder: (context, state) => NoTransitionPage(
            child: AddTestScreen(
              state.pathParameters['category'],
              state.pathParameters['introId'],
            ),
          ),
        ),
        GoRoute(
          name: '문법 데이터 추가',
          path: '/grammar/add/:grammarId',
          pageBuilder: (context, state) => NoTransitionPage(
            child: AddGrammerScreen(
              state.pathParameters['grammarId'],
            ),
          ),
        ),
        GoRoute(
          name: '단어 데이터 추가',
          path: '/word/add/:wordId',
          pageBuilder: (context, state) => NoTransitionPage(
            child: AddWordScreen(
              state.pathParameters['wordId'],
            ),
          ),
        ),
      ],
    ),
  ],
);

class SidebarModel {
  final GoRoute route;
  final Widget icon;
  final String label;
  final bool isStudyMenu;

  SidebarModel({
    required this.icon,
    required this.label,
    required this.route,
    this.isStudyMenu = false,
  });
}

List<SidebarModel> sidebarRoutes = [
  SidebarModel(
    icon: const Dot(color: ColorPallete.introColor),
    label: 'Intro',
    route: GoRoute(
      name: '인트로 & 퀴즈/테스트',
      path: '/intro',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: IntroTestScreen()),
    ),
    isStudyMenu: true,
  ),
  SidebarModel(
    icon: const Dot(color: ColorPallete.wordColor),
    label: 'Word',
    route: GoRoute(
      name: '단어 데이터',
      path: '/word',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: WordScreen()),
    ),
    isStudyMenu: true,
  ),
  SidebarModel(
    icon: const Dot(color: ColorPallete.grammarColor),
    label: 'Grammar',
    route: GoRoute(
      name: '문법 데이터',
      path: '/grammar',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: GrammerScreen()),
    ),
    isStudyMenu: true,
  ),
  SidebarModel(
    icon: const Dot(color: ColorPallete.testColor),
    label: 'Quiz & Test',
    route: GoRoute(
      name: '퀴즈와 테스트',
      path: '/test',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: IntroTestScreen()),
    ),
    isStudyMenu: true,
  ),
  SidebarModel(
    icon: const Dot(color: ColorPallete.metaColor),
    label: 'Meta Grammar',
    route: GoRoute(
      name: '메타 데이터',
      path: '/meta',
      pageBuilder: (context, state) =>
          const NoTransitionPage(child: MetaGrammarScreen()),
    ),
    isStudyMenu: true,
  ),
  SidebarModel(
    icon: const Icon(Icons.groups),
    label: 'Team',
    route: GoRoute(
        name: '관리자 계정 관리',
        path: '/admin',
        pageBuilder: (context, state) =>
            const NoTransitionPage(child: Admin())),
  ),
  SidebarModel(
    icon: const Icon(Icons.person),
    label: 'Me',
    route: GoRoute(
      name: '마이페이지',
      path: '/mypage',
      pageBuilder: (context, state) => const NoTransitionPage(child: Mypage()),
    ),
  ),
];
