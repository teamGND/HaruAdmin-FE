import '../screens/authentication/login_page.dart';
import '../screens/authentication/signup_page.dart';
import '../screens/admin.dart';
import '../screens/intro.dart';
import '../screens/mypage.dart';
import '../screens/logout.dart';

final routingURL = [
  {'path': '/login', 'page': const LoginPage(), 'name': 'Login'},
  {'path': '/signup', 'page': const SignUpScreen(), 'name': 'SignUp'},
  {'path': '/admin', 'page': const Admin(), 'name': '관리자 계정 관리'},
  {'path': '/intro', 'page': const Intro(), 'name': '인트로 데이터'},
  {'path': '/mypage', 'page': const Mypage(), 'name': '마이페이지'},
  {'path': '/logout', 'page': const Logout(), 'name': '로그아웃'},
];
