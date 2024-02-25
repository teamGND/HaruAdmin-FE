// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import '../screens/admin.dart';
import '../screens/authentication/login_page.dart';
import '../screens/authentication/signup_page.dart';

import '../screens/intro/intro.dart';
import '../screens/intro/add_intro.dart';

import '../screens/mypage.dart';

import '../screens/test/test.dart';
import '../screens/test/add_test.dart';

import '../screens/word/word.dart';
import '../screens/word/add_word.dart';

import '../screens/grammer/grammer.dart';
import '../screens/grammer/add_grammer_data.dart';

import '../screens/meta/meta.dart';
import '../screens/meta/add_meta.dart';

class RouteState {
  final String routepath; // path
  final Widget routepage; // 스크린 위젯
  final String routename; // 스크린 이름. 사이드바 옆에 보이게됨.

  RouteState({
    required this.routepath,
    required this.routepage,
    required this.routename,
  });

  String get getPath => routepath;
  Widget get getpage => routepage;
  String get getName => routename;
}

final List<RouteState> manageURL = [
  RouteState(
      routepage: const Admin(), routepath: '/admin', routename: '관리자 계정 관리'),
];

final List<RouteState> authURL = [
  RouteState(
      routepage: const LoginPage(), routepath: '/login', routename: '로그인'),
  RouteState(
      routepage: const SignUpPage(), routepath: '/signup', routename: '회원가입'),
];

final List<RouteState> dataURL = [
  RouteState(
      routepage: const Intro(), routepath: '/intro', routename: '인트로 데이터'),
  RouteState(
      routepage: const AddIntro(),
      routepath: '/intro/add',
      routename: '인트로 데이터 추가'),
  RouteState(routepage: const Test(), routepath: '/test', routename: '테스트 데이터'),
  RouteState(
      routepage: const AddTest(),
      routepath: '/test/add',
      routename: '테스트 데이터 추가'),
  RouteState(
      routepage: const GrammerData(),
      routepath: '/grammer',
      routename: '문법 데이터'),
  RouteState(
      routepage: const ModifyGrammer(),
      routepath: '/grammer/add',
      routename: '문법 데이터 추가'),
  RouteState(routepage: const Word(), routepath: '/word', routename: '단어 데이터'),
  RouteState(
      routepage: const AddWord(),
      routepath: '/word/add',
      routename: '단어 데이터 추가'),
  RouteState(routepage: const Meta(), routepath: '/meta', routename: '메타 데이터'),
  RouteState(
      routepage: const AddMeta(),
      routepath: '/meta/add',
      routename: '메타 데이터 추가'),
];

final List<RouteState> myURL = [
  RouteState(
      routepage: const Mypage(), routepath: '/mypage', routename: '마이페이지'),
];

final List<RouteState> routingURL = [
  ...authURL,
  ...manageURL,
  ...dataURL,
  ...myURL,
];
