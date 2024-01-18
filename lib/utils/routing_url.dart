import '../screens/home.dart';
import '../screens/authentication/login_page.dart';
import '../screens/authentication/signup_page.dart';

final routingURL = [
  {'path': '/login', 'page': const LoginPage(), 'name': 'Login'},
  {'path': '/signup', 'page': const SignUpScreen(), 'name': 'SignUp'},
  {'path': '/home', 'page': const Home(), 'name': 'Home'},
];
