// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';

import '../screens/admin.dart';
import '../screens/authentication/login_page.dart';
import '../screens/authentication/signup_page.dart';
import '../screens/intro.dart';
import '../screens/mypage.dart';
import '../screens/data.dart';

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
      routepage: const TotalData(), routepath: '/data', routename: '총 데이터'),
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
